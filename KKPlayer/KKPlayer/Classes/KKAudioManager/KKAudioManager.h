//
//  KKAudioManager.h
//  KKPlayer
//
//  Created by finger on 09/01/2017.
//  Copyright © 2017 single. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KKAudioManagerInterruptionType) {
    KKAudioManagerInterruptionTypeBegin,
    KKAudioManagerInterruptionTypeEnded,
};

typedef NS_ENUM(NSUInteger, KKAudioManagerInterruptionOption) {
    KKAudioManagerInterruptionOptionNone,
    KKAudioManagerInterruptionOptionShouldResume,
};

typedef NS_ENUM(NSUInteger, KKAudioManagerRouteChangeReason) {
    KKAudioManagerRouteChangeReasonOldDeviceUnavailable,
};

@class KKAudioManager;

//获取音频帧数据
@protocol KKAudioManagerDelegate <NSObject>
- (void)audioManager:(KKAudioManager *)audioManager outputData:(float *)outputData numberOfFrames:(UInt32)numberOfFrames numberOfChannels:(UInt32)numberOfChannels;
@end

typedef void (^KKAudioManagerInterruptionHandler)(id handlerTarget, KKAudioManager *audioManager, KKAudioManagerInterruptionType type, KKAudioManagerInterruptionOption option);
typedef void (^KKAudioManagerRouteChangeHandler)(id handlerTarget, KKAudioManager *audioManager, KKAudioManagerRouteChangeReason reason);

@interface KKAudioManager : NSObject

@property(nonatomic,weak)id<KKAudioManagerDelegate>delegate;

@property(nonatomic,assign)float volume;
@property(nonatomic,assign,readonly)BOOL playing;
@property(nonatomic,assign,readonly)Float64 samplingRate;
@property(nonatomic,assign,readonly)UInt32 numberOfChannels;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)manager;

#pragma mark -- 中断、热插拔回调

- (void)setHandlerTarget:(id)handlerTarget
            interruption:(KKAudioManagerInterruptionHandler)interruptionHandler
             routeChange:(KKAudioManagerRouteChangeHandler)routeChangeHandler;

- (void)removeHandlerTarget:(id)handlerTarget;

#pragma mark -- 声音的播放暂停

- (void)play;
- (void)pause;

#pragma mark -- AudioUnit初始化

- (BOOL)registerAudioSession;
- (void)unregisterAudioSession;

@end
