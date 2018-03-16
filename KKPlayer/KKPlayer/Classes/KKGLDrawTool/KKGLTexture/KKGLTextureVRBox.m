//
//  KKGLTextureVRBox.m
//  KKPlayer
//
//  Created by finger on 2018/2/7.
//  Copyright © 2018年 finger. All rights reserved.
//

#import "KKGLTextureVRBox.h"
#import <GLKit/GLKit.h>

@interface KKGLTextureVRBox()
@property(nonatomic,assign)GLuint textureId;
@property(nonatomic,assign)GLuint colorRenderId;
@property(nonatomic,assign)GLuint frameBufferId;
@end

@implementation KKGLTextureVRBox

- (instancetype)init{
    self = [super init];
    if(self){
        [self setupTextureBuffer];
    }
    return self ;
}

- (void)setupTextureBuffer{
    glGenTextures(1, &self->_textureId);
    glBindTexture(GL_TEXTURE_2D, self->_textureId);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    glGenRenderbuffers(1, &self->_colorRenderId);
    glBindRenderbuffer(GL_RENDERBUFFER, self->_colorRenderId);
    
    glGenFramebuffers(1, &self->_frameBufferId);
    glBindFramebuffer(GL_FRAMEBUFFER, self->_frameBufferId);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, self->_textureId, 0);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, self->_colorRenderId);
}

- (void)resetTextureBufferSize:(CGSize)viewportSize{
    glBindTexture(GL_TEXTURE_2D, self->_textureId);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, viewportSize.width, viewportSize.height, 0, GL_RGB, GL_UNSIGNED_BYTE, nil);

    glBindRenderbuffer(GL_RENDERBUFFER, self->_colorRenderId);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, viewportSize.width, viewportSize.height);
}

@end
