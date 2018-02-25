//
//  KKFFFrameQueue.h
//  KKPlayer
//
//  Created by finger on 18/01/2017.
//  Copyright © 2017 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKFFFrame.h"

@interface KKFFFrameQueue : NSObject
@property(nonatomic,assign,readonly)NSInteger decodedSize;
@property(nonatomic,assign,readonly)NSInteger packetSize;
@property(nonatomic,assign,readonly)NSUInteger count;
@property(atomic,assign,readonly)NSTimeInterval duration;
@property(nonatomic,assign)NSUInteger minFrameCountThreshold;//队列中帧个数的最小阈值，小于这个阈值不能获取帧
@property(nonatomic,assign)BOOL ignoreMinFrameCountThresholdLimit;//忽略阈值的限制
+ (instancetype)frameQueue;
- (void)putFrame:(__kindof KKFFFrame *)frame;
- (void)putSortFrame:(__kindof KKFFFrame *)frame;
- (__kindof KKFFFrame *)getFirstFrameWithBlocking;//如果队列中没有frame则等待
- (__kindof KKFFFrame *)getFirstFrameWithNoBlocking;//如果队列中没有frame则直接返回
- (__kindof KKFFFrame *)getFrameWithNoBlockingAtPosistion:(NSTimeInterval)position discardFrames:(NSMutableArray <__kindof KKFFFrame *> **)discardFrames;
- (NSMutableArray <__kindof KKFFFrame *> *)discardFrameBeforPosition:(NSTimeInterval)position;
- (NSTimeInterval)getFirstPositionWithNoBlocking;
- (void)flush;
- (void)destroy;
@end
