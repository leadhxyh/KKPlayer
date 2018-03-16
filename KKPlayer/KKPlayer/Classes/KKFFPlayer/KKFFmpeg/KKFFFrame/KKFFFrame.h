//
//  KKFFFrame.h
//  KKPlayer
//
//  Created by finger on 06/01/2017.
//  Copyright © 2017 finger. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KKFFFrameType) {
    KKFFFrameTypeVideo,
    KKFFFrameTypeAVYUVVideo,
    KKFFFrameTypeCVYUVVideo,
    KKFFFrameTypeAudio,
    KKFFFrameTypeSubtitle,
    KKFFFrameTypeArtwork,
};

@class KKFFFrame;

@protocol KKFFFrameDelegate <NSObject>
- (void)frameDidStartPlaying:(KKFFFrame *)frame;
- (void)frameDidStopPlaying:(KKFFFrame *)frame;
- (void)frameDidCancel:(KKFFFrame *)frame;
@end

@interface KKFFFrame : NSObject
@property(nonatomic,weak)id<KKFFFrameDelegate> delegate;
@property(nonatomic,assign,readonly)BOOL playing;
@property(nonatomic,assign)KKFFFrameType type;
@property(nonatomic,assign)NSTimeInterval position;
@property(nonatomic,assign)NSTimeInterval duration;
@property(nonatomic,assign,readonly)NSInteger decodedSize;//解码后的数据大小
@property(nonatomic,assign)NSInteger packetSize;

- (void)startPlaying;
- (void)stopPlaying;
- (void)cancel;

@end


@interface KKFFSubtileFrame:KKFFFrame
@end


@interface KKFFArtworkFrame:KKFFFrame
@property(nonatomic,strong)NSData *picture;
@end
