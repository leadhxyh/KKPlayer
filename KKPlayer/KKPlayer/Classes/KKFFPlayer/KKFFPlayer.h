//
//  KKFFPlayer.h
//  KKPlayer
//
//  Created by finger on 03/01/2017.
//  Copyright © 2017 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKPlayerInterface.h"

@interface KKFFPlayer:NSObject

@property(nonatomic,weak,readonly)KKPlayerInterface *playerInterface;

@property(nonatomic,assign,readonly)KKPlayerState state;
@property(nonatomic,assign,readonly)CGSize presentationSize;
@property(nonatomic,assign,readonly)NSTimeInterval bitrate;
@property(nonatomic,assign,readonly)NSTimeInterval progress;
@property(nonatomic,assign,readonly)NSTimeInterval duration;
@property(nonatomic,assign,readonly)NSTimeInterval playableTime;
@property(nonatomic,assign,readonly)BOOL seeking;
@property(nonatomic,assign,readonly)BOOL seekEnable;
@property(nonatomic,assign,readonly)BOOL videoDecodeOnMainThread;

//音视频轨道信息
@property(nonatomic,assign,readonly)BOOL videoEnable;
@property(nonatomic,assign,readonly)BOOL audioEnable;
@property(nonatomic,strong,readonly)KKPlayerTrack *videoTrack;
@property(nonatomic,strong,readonly)KKPlayerTrack *audioTrack;
@property(nonatomic,strong,readonly)NSArray<KKPlayerTrack *> *videoTracks;
@property(nonatomic,strong,readonly)NSArray<KKPlayerTrack *> *audioTracks;

+ (instancetype)new NS_UNAVAILABLE;
+ (instancetype)init NS_UNAVAILABLE;
+ (instancetype)playerWithPlayerInterface:(KKPlayerInterface *)playerInterface;

#pragma mark -- 准备解码

- (void)prepareVideo;

#pragma mark -- 播放控制

- (void)play;
- (void)pause;
- (void)stop;
- (void)seekToTime:(NSTimeInterval)time;
- (void)seekToTime:(NSTimeInterval)time completeHandler:(void(^)(BOOL finished))completeHandler;
- (void)reloadVolume;
- (void)reloadPlayableBufferInterval;

@end
