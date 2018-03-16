//
//  KKGLTextureVRBox.h
//  KKPlayer
//
//  Created by finger on 2018/2/7.
//  Copyright © 2018年 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface KKGLTextureVRBox : NSObject
@property(nonatomic,assign,readonly)GLuint textureId;
@property(nonatomic,assign,readonly)GLuint colorRenderId;
@property(nonatomic,assign,readonly)GLuint frameBufferId;
- (void)resetTextureBufferSize:(CGSize)viewportSize;
@end
