//
//  KKGLFrame.h
//  KKPlayer
//
//  Created by finger on 2017/3/27.
//  Copyright © 2017年 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "KKFFVideoFrame.h"

typedef NS_ENUM(NSUInteger, KKGLFrameType) {
    KKGLFrameTypeNV12,
    KKGLFrameTypeYUV420,
};

@interface KKGLFrame : NSObject
@property(nonatomic,assign,readonly)KKGLFrameType type;
@property(nonatomic,assign,readonly) KKFFVideoFrameRotateType rotateType;
@property(nonatomic,assign,readonly)BOOL hasUpate;

+ (instancetype)frame;

- (void)didDraw;
- (void)flush;

//ffmpeg videoToolbox
- (void)updateWithFFVideoFrame:(KKFFVideoFrame *)videoFrame;
//AVPlayer
- (void)updateWithCVPixelBuffer:(CVPixelBufferRef)pixelBuffer;

- (CVPixelBufferRef)pixelBufferForNV12;
- (KKFFCVYUVVideoFrame *)videoFrameForNV12;
- (KKFFAVYUVVideoFrame *)videoFrameForYUV420;

- (NSTimeInterval)currentPosition;
- (NSTimeInterval)currentDuration;

- (UIImage *)imageFromVideoFrame;

@end
