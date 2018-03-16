//
//  KKGLCoordBufferVRBox.h
//  KKPlayer
//
//  Created by finger on 2018/2/7.
//  Copyright © 2018年 finger. All rights reserved.
//

#import "KKGLCoordBuffer.h"

typedef NS_ENUM(NSUInteger, KKVRBoxType) {
    KKVRBoxTypeLeft,
    KKVRBoxTypeRight,
};

@interface KKGLCoordBufferVRBox : NSObject
@property(nonatomic,assign,readonly)KKVRBoxType vrBoxType;
@property(nonatomic,assign,readonly)GLuint indexBufferId;
@property(nonatomic,assign,readonly)GLuint vertexBufferId;
@property(nonatomic,assign,readonly)int indexCount;
@property(nonatomic,assign,readonly)int vertexCount;
- (instancetype)initWithBoxType:(KKVRBoxType)vrBoxType;
@end
