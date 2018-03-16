//
//  KKGLCoordBuffer.h
//  KKPlayer
//
//  Created by finger on 16/01/2017.
//  Copyright © 2017 finger. All rights reserved.
//

#import <GLKit/GLKit.h>

typedef NS_ENUM(NSUInteger, KKTextureRotateType) {
    KKTextureRotateType0,
    KKTextureRotateType90,
    KKTextureRotateType180,
    KKTextureRotateType270,
};

@interface KKGLCoordBuffer:NSObject
@property(nonatomic,assign)GLuint indexBufferId;
@property(nonatomic,assign)GLuint vertexBufferId;
@property(nonatomic,assign)GLuint textureBufferId;
@property(nonatomic,assign)int indexCount;
@property(nonatomic,assign)int vertexCount;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)coordBuffer;

#pragma mark -- 子类实现

- (void)genBufferIdentify;
- (void)setupCoordBuffer;
- (void)bindPositionLocation:(GLint)positionLocation
        textureCoordLocation:(GLint)textureCoordLocation;
- (void)bindPositionLocation:(GLint)positionLocation
        textureCoordLocation:(GLint)textureCoordLocation
           textureRotateType:(KKTextureRotateType)textureRotateType;

@end
