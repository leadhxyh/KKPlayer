//
//  KKGLFrame.m
//  KKPlayer
//
//  Created by finger on 2017/3/27.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "KKGLFrame.h"

@interface KKGLFrame()
@property(nonatomic,assign)CVPixelBufferRef pixelBuffer;
@property(nonatomic,strong)KKFFVideoFrame *videoFrame;
@end

@implementation KKGLFrame

+ (instancetype)frame{
    return [[self alloc] init];
}

- (void)dealloc{
    [self flush];
}

- (void)flush{
    self->_hasUpate = NO;
    if (self.pixelBuffer) {
        CVPixelBufferRelease(self.pixelBuffer);
        self.pixelBuffer = NULL;
    }
    if (self.videoFrame) {
        [self.videoFrame stopPlaying];
        self.videoFrame = nil;
    }
}

- (void)updateWithCVPixelBuffer:(CVPixelBufferRef)pixelBuffer;{
    [self flush];
    self->_type = KKGLFrameTypeNV12;
    self.pixelBuffer = pixelBuffer;
    self->_hasUpate = YES;
}

- (void)updateWithFFVideoFrame:(KKFFVideoFrame *)videoFrame;{
    [self flush];
    
    self.videoFrame = videoFrame;
    if ([videoFrame isKindOfClass:[KKFFCVYUVVideoFrame class]]) {
        self->_type = KKGLFrameTypeNV12;
    } else {
        self->_type = KKGLFrameTypeYUV420;
    }
    [self.videoFrame startPlaying];
    
    self->_rotateType = videoFrame.rotateType;
    self->_hasUpate = YES;
}

- (CVPixelBufferRef)pixelBufferForNV12{
    if (self.pixelBuffer) {
        return self.pixelBuffer;
    } else {
        return [(KKFFCVYUVVideoFrame *)self.videoFrame pixelBuffer];
    }
    return nil;
}

- (KKFFCVYUVVideoFrame *)videoFrameForNV12{
    return (KKFFCVYUVVideoFrame *)self.videoFrame;
}

- (KKFFAVYUVVideoFrame *)videoFrameForYUV420{
    return (KKFFAVYUVVideoFrame *)self.videoFrame;
}

- (NSTimeInterval)currentPosition{
    if (self.videoFrame) {
        return self.videoFrame.position;
    }
    return -1;
}

- (NSTimeInterval)currentDuration{
    if (self.videoFrame) {
        return self.videoFrame.duration;
    }
    return -1;
}

- (UIImage *)imageFromVideoFrame{
    if ([self.videoFrame isKindOfClass:[KKFFAVYUVVideoFrame class]]) {
        KKFFAVYUVVideoFrame *frame = (KKFFAVYUVVideoFrame *)self.videoFrame;
        UIImage *image = frame.snapshot;
        if (image) return image;
    } else if ([self.videoFrame isKindOfClass:[KKFFCVYUVVideoFrame class]]) {
        KKFFCVYUVVideoFrame *frame = (KKFFCVYUVVideoFrame *)self.videoFrame;
        if (frame.pixelBuffer) {
            UIImage *image = KKImageWithCVPixelBuffer(frame.pixelBuffer);
            if (image) return image;
        }
    }
    return nil;
}

- (void)didDraw{
    self->_hasUpate = NO;
}

@end
