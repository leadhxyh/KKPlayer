//
//  KKRenderView.h
//  KKPlayer
//
//  Created by KKFinger on 12/01/2017.
//  Copyright © 2017 KKFinger. All rights reserved.
//

/*
 *渲染流程：
 1、GLKViewDelegate的- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect会不断地调用，在代理里面不断的获取音视频的解码数据
 */

#import <AVFoundation/AVFoundation.h>
#import "KKPlayerInterface.h"
#import "KKAVPlayer.h"
#import "KKFFPlayer.h"

@class KKFingerRotation;
@class KKGLFrame;
@class KKFFVideoFrame;

//渲染方式
typedef NS_ENUM(NSUInteger,KKRendererType) {
    KKRendererTypeEmpty,
    KKRendererTypeAVPlayerLayer,//AVplayer
    KKRendererTypeOpenGL,//ffmpeg,videoToolbox
};

@protocol KKRenderFFmpegDelegate <NSObject>
- (KKFFVideoFrame *)renderFrameWithCurrentPostion:(NSTimeInterval)currentPostion
                                  currentDuration:(NSTimeInterval)currentDuration;
@end

@protocol KKRenderAVPlayerDelegate <NSObject>
- (AVPlayer *)renderGetAVPlayer;
- (CVPixelBufferRef)renderGetPixelBufferAtCurrentTime;
- (UIImage *)renderGetSnapshotAtCurrentTime;
@end

@interface KKRenderView:UIView
@property(nonatomic,weak,readonly)KKPlayerInterface *playerInterface;
@property(nonatomic,strong,readonly)KKFingerRotation *fingerRotation;

@property(nonatomic,assign)KKDecoderType decodeType;
@property(nonatomic,assign)KKRendererType rendererType;

@property(nonatomic,weak)id<KKRenderAVPlayerDelegate>renderAVPlayerDelegate;
@property(nonatomic,weak)id<KKRenderFFmpegDelegate>renderFFmpegDelegate;

+ (instancetype)new NS_UNAVAILABLE;
+ (instancetype)renderViewWithPlayerInterface:(KKPlayerInterface *)playerInterface;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)resetAVPlayerVideoGravity;
- (void)resetAVPlayer;
- (void)fetchVideoFrameForGLFrame:(KKGLFrame *)glFrame;

- (UIImage *)snapshot;

@end
