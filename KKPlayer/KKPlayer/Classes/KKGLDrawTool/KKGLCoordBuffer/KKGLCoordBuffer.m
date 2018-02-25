//
//  KKGLCoordBuffer.m
//  KKPlayer
//
//  Created by finger on 16/01/2017.
//  Copyright © 2017 finger. All rights reserved.
//

#import "KKGLCoordBuffer.h"

@implementation KKGLCoordBuffer

+ (instancetype)coordBuffer{
    return [[self alloc] init];
}

- (instancetype)init{
    if (self = [super init]) {
        [self genBufferIdentify];
        [self setupCoordBuffer];
    }
    return self;
}

- (void)dealloc{
    KKPlayerLog(@"%@ release", self.class);
}

#pragma mark -- 子类实现

- (void)genBufferIdentify{}
- (void)setupCoordBuffer {}
- (void)bindPositionLocation:(GLint)position_location
        textureCoordLocation:(GLint)textureCoordLocation {}
- (void)bindPositionLocation:(GLint)position_location
        textureCoordLocation:(GLint)textureCoordLocation
           textureRotateType:(KKTextureRotateType)textureRotateType {}

@end
