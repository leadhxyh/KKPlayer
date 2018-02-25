//
//  KKFFMetadata.h
//  KKPlayer
//
//  Created by finger on 2017/3/6.
//  Copyright © 2017年 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKTools.h"

@interface KKFFMetadata : NSObject
@property(nonatomic,strong)NSDictionary *metadata;
@property(nonatomic,copy)NSString *language;
@property(nonatomic,assign)long long BPS;
@property(nonatomic,copy)NSString *duration;
@property(nonatomic,assign)long long numberOfBytes;
@property(nonatomic,assign)long long numberOfFrames;

+ (instancetype)metadataWithAVDictionary:(AVDictionary *)avDictionary;

@end
