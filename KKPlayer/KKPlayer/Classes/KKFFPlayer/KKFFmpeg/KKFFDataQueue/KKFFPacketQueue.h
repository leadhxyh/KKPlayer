//
//  KKFFPacketQueue.h
//  KKPlayer
//
//  Created by finger on 18/01/2017.
//  Copyright © 2017 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "avformat.h"

@interface KKFFPacketQueue:NSObject
@property(nonatomic,assign,readonly)NSUInteger count;
@property(nonatomic,assign,readonly)NSInteger size;
@property(atomic,assign,readonly)NSTimeInterval duration;
@property(nonatomic,assign,readonly)NSTimeInterval timebase;
+ (instancetype)packetQueueWithTimebase:(NSTimeInterval)timebase;
- (void)putPacket:(AVPacket)packet duration:(NSTimeInterval)duration;
- (AVPacket)getPacketWithBlocking;//如果队列中没有packet则等待
- (AVPacket)getPacketWithNoBlocking;//如果队列中没有packet则直接返回
- (void)flush;
- (void)destroy;
@end
