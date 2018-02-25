//
//  KKFFTrack.h
//  KKPlayer
//
//  Created by finger on 2017/3/6.
//  Copyright © 2017年 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKFFMetadata.h"

typedef NS_ENUM(NSUInteger, KKFFTrackType) {
    KKFFTrackTypeVideo,
    KKFFTrackTypeAudio,
    KKFFTrackTypeSubtitle,
};

@interface KKFFTrack:NSObject
@property(nonatomic,assign)int index;
@property(nonatomic,assign)KKFFTrackType type;
@property(nonatomic,strong)KKFFMetadata *metadata;
@end
