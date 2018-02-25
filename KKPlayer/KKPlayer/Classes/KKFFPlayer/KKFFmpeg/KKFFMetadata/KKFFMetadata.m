//
//  KKFFMetadata.m
//  KKPlayer
//
//  Created by finger on 2017/3/6.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "KKFFMetadata.h"

@implementation KKFFMetadata

+ (instancetype)metadataWithAVDictionary:(AVDictionary *)avDictionary{
    return [[self alloc] initWithAVDictionary:avDictionary];
}

- (instancetype)initWithAVDictionary:(AVDictionary *)avDictionary{
    if (self = [super init]){
        NSDictionary *dic = KKFFAVDictionaryToNSDictionary(avDictionary);
        self.metadata = dic;
        self.language = [dic objectForKey:@"language"];
        self.BPS = [[dic objectForKey:@"BPS"] longLongValue];
        self.duration = [dic objectForKey:@"DURATION"];
        self.numberOfBytes = [[dic objectForKey:@"NUMBER_OF_BYTES"] longLongValue];
        self.numberOfFrames = [[dic objectForKey:@"NUMBER_OF_FRAMES"] longLongValue];
    }
    return self;
}

@end
