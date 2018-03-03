//
//  KKFFVideoFrame.h
//  KKPlayer
//
//  Created by finger on 2017/2/17.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "KKFFFrame.h"
#import <AVFoundation/AVFoundation.h>
#import "avformat.h"
#import "pixfmt.h"

typedef NS_ENUM(int, KKYUVChannel) {
    KKYUVChannelLuma = 0,//YUV格式的Y通道，表示亮度
    KKYUVChannelChromaB = 1,//YUV格式的Cb通道,表示当前颜色对蓝色的偏移
    KKYUVChannelChromaR = 2,//YUV格式的Cr通道，表示当前颜色对红色的偏移
    KKYUVChannelCount = 3,//通道个数，3个
};

typedef NS_ENUM(NSUInteger, KKFFVideoFrameRotateType) {
    KKFFVideoFrameRotateType0,
    KKFFVideoFrameRotateType90,
    KKFFVideoFrameRotateType180,
    KKFFVideoFrameRotateType270,
};

@interface KKFFVideoFrame:KKFFFrame
@property(nonatomic,assign)KKFFVideoFrameRotateType rotateType;
@end

// FFmpeg AVFrame YUV frame
@interface KKFFAVYUVVideoFrame:KKFFVideoFrame{
@public
    UInt8 *channelPixelBuffer[KKYUVChannelCount];
}
@property(nonatomic,assign,readonly)int width;
@property(nonatomic,assign,readonly)int height;
+ (instancetype)videoFrame;
- (void)setFrameData:(AVFrame *)frame width:(int)width height:(int)height;
- (UIImage *)snapshot;
@end

//VideoToolBox YUV frame
@interface KKFFCVYUVVideoFrame:KKFFVideoFrame
@property(nonatomic,assign,readonly)CVPixelBufferRef pixelBuffer;
- (instancetype)initWithAVPixelBuffer:(CVPixelBufferRef)pixelBuffer;
- (void)setPixelBuffer:(CVPixelBufferRef)pixelBuffer;
@end

