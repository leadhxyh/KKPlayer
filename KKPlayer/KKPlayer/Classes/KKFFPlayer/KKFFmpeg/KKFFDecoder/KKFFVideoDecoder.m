//
//  KKFFVideoDecoder.m
//  KKPlayer
//
//  Created by finger on 2017/2/17.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "KKFFVideoDecoder.h"
#import "KKFFPacketQueue.h"
#import "KKFFFrameQueue.h"
#import "KKFFFramePool.h"
#import "KKTools.h"
#import "KKFFVideoToolBox.h"

//当解码遇到这AVPacket时，需要清理AVCodecContext的缓冲
static AVPacket flushPacket;

@interface KKFFVideoDecoder (){
    AVCodecContext *_codecContext;
    AVFrame *_tempFrame;
}
@property(nonatomic,assign)BOOL canceled;
@property(nonatomic,strong)KKFFPacketQueue *packetQueue;//原始数据队列
@property(nonatomic,strong)KKFFFrameQueue *frameQueue;//已解码队列
@property(nonatomic,strong)KKFFFramePool *framePool;
@property(nonatomic,strong)KKFFVideoToolBox *videoToolBox;
@end

@implementation KKFFVideoDecoder

+ (instancetype)decoderWithCodecContext:(AVCodecContext *)codecContext
                               timebase:(NSTimeInterval)timebase
                                    fps:(NSTimeInterval)fps
                      ffmpegDecodeAsync:(BOOL)ffmpegDecodeAsync
                      videoToolBoxAsync:(BOOL)videoToolBoxAsync
                             rotateType:(KKFFVideoFrameRotateType)rotateType
                               delegate:(id<KKFFVideoDecoderDlegate>)delegate{
    return [[self alloc] initWithCodecContext:codecContext
                                     timebase:timebase
                                          fps:fps
                            ffmpegDecodeAsync:ffmpegDecodeAsync
                            videoToolBoxAsync:videoToolBoxAsync
                                   rotateType:rotateType
                                     delegate:delegate];
}

- (instancetype)initWithCodecContext:(AVCodecContext *)codecContext
                            timebase:(NSTimeInterval)timebase
                                 fps:(NSTimeInterval)fps
                   ffmpegDecodeAsync:(BOOL)ffmpegDecodeAsync
                   videoToolBoxAsync:(BOOL)videoToolBoxAsync
                          rotateType:(KKFFVideoFrameRotateType)rotateType
                            delegate:(id<KKFFVideoDecoderDlegate>)delegate{
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            av_init_packet(&flushPacket);
            flushPacket.data = (uint8_t *)&flushPacket;
            flushPacket.duration = 0;
        });
        self.delegate = delegate;
        self->_codecContext = codecContext;
        self->_timebase = timebase;
        self->_fps = fps;
        self->_ffmpegDecodeAsync = ffmpegDecodeAsync;
        self->_videoToolBoxAsync = videoToolBoxAsync;
        self->_rotateType = rotateType;
        [self setupFrameQueue];
    }
    return self;
}

- (void)dealloc{
    if (_tempFrame) {
        av_free(_tempFrame);
        _tempFrame = NULL;
    }
    KKPlayerLog(@"KKFFVideoDecoder release");
}

#pragma mark -- 初始化数据队列相关数据

- (void)setupFrameQueue{
    self->_tempFrame = av_frame_alloc();
    self.videoToolBoxMaxDecodeFrameCount = 20;
    self.codecContextMaxDecodeFrameCount = 3;
    if (self.videoToolBoxAsync && _codecContext->codec_id == AV_CODEC_ID_H264) {
        self.videoToolBox = [KKFFVideoToolBox videoToolBoxWithCodecContext:self->_codecContext];
        if ([self.videoToolBox trySetupVTSession]) {
            self->_videoToolBoxDidOpen = YES;
        } else {
            [self.videoToolBox flush];
            self.videoToolBox = nil;
        }
    }
    self.packetQueue = [KKFFPacketQueue packetQueueWithTimebase:self.timebase];
    if (self.videoToolBoxDidOpen) {
        self.frameQueue = [KKFFFrameQueue frameQueue];
        self.frameQueue.minFrameCountThreshold = 4;
        self->_decodeAsync = YES;
    } else if (self.ffmpegDecodeAsync) {
        self.frameQueue = [KKFFFrameQueue frameQueue];
        self.framePool = [KKFFFramePool videoPool];
        self->_decodeAsync = YES;
    } else {
        self.framePool = [KKFFFramePool videoPool];
        self->_decodeSync = YES;
        self->_decodeOnMainThread = YES;
    }
}

#pragma mark -- 获取音视频帧

- (KKFFVideoFrame *)getFirstPositionFrame{
    if (self.videoToolBoxDidOpen || self.ffmpegDecodeAsync) {
        return [self.frameQueue getFirstFrameWithNoBlocking];
    } else {
        return [self ffmpegDecodeSync];
    }
}

- (KKFFVideoFrame *)getFrameAtPosition:(NSTimeInterval)position{
    if (self.videoToolBoxDidOpen || self.ffmpegDecodeAsync) {
        NSMutableArray <KKFFFrame *> *discardFrames = nil;
        KKFFVideoFrame *videoFrame = [self.frameQueue getFrameWithNoBlockingAtPosistion:position discardFrames:&discardFrames];
        for (KKFFVideoFrame *obj in discardFrames) {
            [obj cancel];
        }
        return videoFrame;
    } else {
        return [self ffmpegDecodeSync];
    }
}

#pragma mark -- 丢弃帧

- (void)discardFrameBeforPosition:(NSTimeInterval)position{
    if (self.videoToolBoxDidOpen || self.ffmpegDecodeAsync) {
        NSMutableArray <KKFFFrame *> *discardFrames = [self.frameQueue discardFrameBeforPosition:position];
        for (KKFFVideoFrame *obj in discardFrames) {
            [obj cancel];
        }
    }
}

#pragma mark -- 添加音视频原始帧数据到队列中

- (void)putPacket:(AVPacket)packet{
    NSTimeInterval duration = 0;
    if (packet.duration <= 0 && packet.size > 0 && packet.data != flushPacket.data) {
        duration = 1.0 / self.fps;
    }
    [self.packetQueue putPacket:packet duration:duration];
}

#pragma mark -- 解码线程

- (void)startDecodeThread{
    if (self.videoToolBoxDidOpen) {
        [self videoToolBoxDecodeAsyncThread];
    } else if (self.ffmpegDecodeAsync) {
        [self ffmpegDecodeAsyncThread];
    }
}

#pragma mark -- ffmpeg解码，异步

- (void)ffmpegDecodeAsyncThread{
    while (YES) {
        if (!self.ffmpegDecodeAsync) {
            break;
        }
        if (self.canceled || self.error) {
            KKPlayerLog(@"decode video thread quit");
            break;
        }
        if (self.endOfFile && self.packetQueue.count <= 0) {
            KKPlayerLog(@"decode video finished");
            break;
        }
        if (self.paused) {
            KKPlayerLog(@"decode video thread pause sleep");
            [NSThread sleepForTimeInterval:0.03];
            continue;
        }
        if (self.frameQueue.count >= self.codecContextMaxDecodeFrameCount) {
            //KKPlayerLog(@"decode video thread sleep");
            [NSThread sleepForTimeInterval:0.03];
            continue;
        }
        
        AVPacket packet = [self.packetQueue getPacketWithBlocking];
        if (packet.data == flushPacket.data) {
            KKPlayerLog(@"video codec flush");
            avcodec_flush_buffers(_codecContext);
            [self.frameQueue flush];
            continue;
        }
        
        if (packet.stream_index < 0 || packet.data == NULL) continue;
        
        KKFFVideoFrame *videoFrame = nil;
        int result = avcodec_send_packet(_codecContext, &packet);
        if (result < 0) {
            if (result != AVERROR(EAGAIN) && result != AVERROR_EOF) {
                self->_error = KKFFCheckError(result);
                [self delegateErrorCallback];
            }
        } else {
            while (result >= 0) {
                result = avcodec_receive_frame(_codecContext, _tempFrame);
                if (result < 0) {
                    if (result != AVERROR(EAGAIN) && result != AVERROR_EOF) {
                        self->_error = KKFFCheckError(result);
                        [self delegateErrorCallback];
                    }
                } else {
                    videoFrame = [self videoFrameFromTempFrame:packet.size];
                    if (videoFrame) {
                        [self.frameQueue putSortFrame:videoFrame];
                    }
                }
            }
        }
        av_packet_unref(&packet);
    }
}

#pragma mark -- ffmpeg解码，同步

- (KKFFVideoFrame *)ffmpegDecodeSync{
    if (self.canceled || self.error) {
        return nil;
    }
    if (self.paused) {
        return nil;
    }
    if (self.endOfFile && self.packetQueue.count <= 0) {
        return nil;
    }
    
    AVPacket packet = [self.packetQueue getPacketWithNoBlocking];
    if (packet.data == flushPacket.data) {
        avcodec_flush_buffers(_codecContext);
        return nil;
    }
    if (packet.stream_index < 0 || packet.data == NULL) {
        return nil;
    }
    
    KKFFVideoFrame *videoFrame = nil;
    int result = avcodec_send_packet(_codecContext, &packet);
    if (result < 0) {
        if (result != AVERROR(EAGAIN) && result != AVERROR_EOF) {
            self->_error = KKFFCheckError(result);
            [self delegateErrorCallback];
        }
    } else {
        while (result >= 0) {
            result = avcodec_receive_frame(_codecContext, _tempFrame);
            if (result < 0) {
                if (result != AVERROR(EAGAIN) && result != AVERROR_EOF) {
                    self->_error = KKFFCheckError(result);
                    [self delegateErrorCallback];
                }
            } else {
                videoFrame = [self videoFrameFromTempFrame:packet.size];
            }
        }
    }
    av_packet_unref(&packet);
    
    return videoFrame;
}

- (KKFFAVYUVVideoFrame *)videoFrameFromTempFrame:(int)packetSize{
    if (!_tempFrame->data[0] || !_tempFrame->data[1] || !_tempFrame->data[2]) return nil;
    
    KKFFAVYUVVideoFrame *videoFrame = [self.framePool getUnuseFrame];
    [videoFrame setFrameData:_tempFrame width:_codecContext->width height:_codecContext->height];
    videoFrame.position = av_frame_get_best_effort_timestamp(_tempFrame) * self.timebase;
    videoFrame.packetSize = packetSize;
    videoFrame.rotateType = self.rotateType;
    
    const int64_t frame_duration = av_frame_get_pkt_duration(_tempFrame);
    if (frame_duration) {
        videoFrame.duration = frame_duration * self.timebase;
        videoFrame.duration += _tempFrame->repeat_pict * self.timebase * 0.5;
    } else {
        videoFrame.duration = 1.0 / self.fps;
    }
    return videoFrame;
}

#pragma mark -- VideoToolBox，硬件加速

- (void)videoToolBoxDecodeAsyncThread{
    while (YES) {
        if (!self.videoToolBoxDidOpen) {
            break;
        }
        if (self.canceled || self.error) {
            KKPlayerLog(@"decode video thread quit");
            break;
        }
        if (self.endOfFile && self.packetQueue.count <= 0) {
            KKPlayerLog(@"decode video finished");
            break;
        }
        if (self.paused) {
            KKPlayerLog(@"decode video thread pause sleep");
            [NSThread sleepForTimeInterval:0.01];
            continue;
        }
        if (self.frameQueue.count >= self.videoToolBoxMaxDecodeFrameCount) {
            KKPlayerLog(@"decode video thread sleep");
            [NSThread sleepForTimeInterval:0.03];
            continue;
        }
        
        AVPacket packet = [self.packetQueue getPacketWithBlocking];
        if (packet.data == flushPacket.data) {
            KKPlayerLog(@"video codec flush");
            [self.frameQueue flush];
            [self.videoToolBox flush];
            continue;
        }
        
        if (packet.stream_index < 0 || packet.data == NULL) continue;
        
        KKFFVideoFrame *videoFrame = nil;
        BOOL vtbEnable = [self.videoToolBox trySetupVTSession];
        if (vtbEnable) {
            BOOL needFlush = NO;
            BOOL result = [self.videoToolBox sendPacket:packet needFlush:&needFlush];
            if (result) {
                videoFrame = [self videoFrameFromVideoToolBox:packet];
            } else if (needFlush) {
                [self.videoToolBox flush];
                BOOL result2 = [self.videoToolBox sendPacket:packet needFlush:&needFlush];
                if (result2) {
                    videoFrame = [self videoFrameFromVideoToolBox:packet];
                }
            }
        }
        if (videoFrame) {
            [self.frameQueue putSortFrame:videoFrame];
        }
        av_packet_unref(&packet);
    }
    self.frameQueue.ignoreMinFrameCountThresholdLimit = YES;
}

- (KKFFVideoFrame *)videoFrameFromVideoToolBox:(AVPacket)packet{
    CVImageBufferRef imageBuffer = [self.videoToolBox imageBuffer];
    if (imageBuffer == NULL) return nil;
    
    KKFFCVYUVVideoFrame *videoFrame = [[KKFFCVYUVVideoFrame alloc] initWithAVPixelBuffer:imageBuffer];
    if (packet.pts != AV_NOPTS_VALUE) {
        videoFrame.position = packet.pts * self.timebase;
    } else {
        videoFrame.position = packet.dts;
    }
    videoFrame.packetSize = packet.size;
    videoFrame.rotateType = self.rotateType;
    
    const int64_t frameDuration = packet.duration;
    if (frameDuration) {
        videoFrame.duration = frameDuration * self.timebase;
    } else {
        videoFrame.duration = 1.0 / self.fps;
    }
    return videoFrame;
}

#pragma mark -- 解码错误

- (void)delegateErrorCallback{
    if (self.error) {
        [self.delegate videoDecoder:self didError:self.error];
    }
}

#pragma mark -- 清理

/*
 注意,在seek时，需要将所有的数据队列及AVCodecContext的缓冲清空，清空AVCodecContext缓冲的策略是:
 在AVPacket队列中加入flushPacket，解码线程将AVPacket队列中的数据取出时，如果是flushPacket，则将
 AVCodecContext的缓冲清理，不清理AVCodecContext的缓冲会造成播放画面卡主不动的问题
 */
- (void)flush{
    [self.packetQueue flush];
    [self.frameQueue flush];
    [self.framePool flush];
    [self putPacket:flushPacket];
}

- (void)destroy{
    self.canceled = YES;
    [self.frameQueue destroy];
    [self.packetQueue destroy];
    [self.framePool flush];
}

#pragma mark -- @property getter && setter

- (NSInteger)packetSize{
    if (self.videoToolBoxDidOpen || self.ffmpegDecodeAsync) {
        return self.packetQueue.size + self.frameQueue.packetSize;
    } else {
        return self.packetQueue.size;
    }
}

- (BOOL)frameQueueEmpty{
    if (self.videoToolBoxDidOpen || self.ffmpegDecodeAsync) {
        return self.packetQueue.count <= 0 && self.frameQueue.count <= 0;
    } else {
        return self.packetQueue.count <= 0;
    }
}

- (NSTimeInterval)duration{
    if (self.videoToolBoxDidOpen || self.ffmpegDecodeAsync) {
        return self.packetQueue.duration + self.frameQueue.duration;
    } else {
        return self.packetQueue.duration;
    }
}

@end
