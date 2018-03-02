//
//  KKRenderView.h
//  KKPlayer
//
//  Created by KKFinger on 12/01/2017.
//  Copyright © 2017 KKFinger. All rights reserved.
//

/*
 *KKRenderView为AVPlayerLayer和GLKView的父视图
 *
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

@protocol KKRenderFFmpegDelegate <NSObject>
- (KKFFVideoFrame *)renderFrameWithCurrentPostion:(NSTimeInterval)currentPostion
                                  currentDuration:(NSTimeInterval)currentDuration;
@end

@protocol KKRenderAVPlayerDelegate <NSObject>
- (AVPlayer *)renderGetAVPlayer;//获取AVPlayer，加入到KKRenderView中的AVPlayerLayer中
- (CVPixelBufferRef)renderGetPixelBufferAtCurrentTime;//使用AVPlayer播放vr视频时，用于获取视频帧数据并传递给GLKView渲染
- (UIImage *)renderGetSnapshotAtCurrentTime;//截屏
@end

@interface KKRenderView:UIView
@property(nonatomic,weak,readonly)KKPlayerInterface *playerInterface;
@property(nonatomic,strong,readonly)KKFingerRotation *fingerRotation;

@property(nonatomic,assign)KKDecoderType decodeType;
@property(nonatomic,assign)KKRenderViewType renderViewType;//渲染方式,选择对应的渲染图层

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
