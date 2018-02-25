//
//  KKGLTextureYUV420.m
//  KKPlayer
//
//  Created by finger on 2017/3/27.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "KKGLTextureYUV420.h"

@interface KKGLTextureYUV420 ()

@end

@implementation KKGLTextureYUV420

static GLuint gl_texture_ids[3];

- (instancetype)init{
    if (self = [super init]) {
        glGenTextures(3, gl_texture_ids);
    }
    return self;
}

//更新纹理图
- (BOOL)updateTextureWithGLFrame:(KKGLFrame *)glFrame aspect:(CGFloat *)aspect{
    KKFFAVYUVVideoFrame *videoFrame = [glFrame videoFrameForYUV420];
    if (!videoFrame) {
        return NO;
    }
    const int frameWidth = videoFrame.width;
    const int frameHeight = videoFrame.height;
    *aspect = (frameWidth * 1.0) / (frameHeight * 1.0);
    
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    
    const int widths[3]  = {
        frameWidth,
        frameWidth / 2,
        frameWidth / 2
    };
    const int heights[3] = {
        frameHeight,
        frameHeight / 2,
        frameHeight / 2
    };
    
    for (KKYUVChannel channel = KKYUVChannelLuma; channel < KKYUVChannelCount; channel++){
        glActiveTexture(GL_TEXTURE0 + channel);
        glBindTexture(GL_TEXTURE_2D, gl_texture_ids[channel]);
        glTexImage2D(GL_TEXTURE_2D,
                     0,
                     GL_LUMINANCE,
                     widths[channel],
                     heights[channel],
                     0,
                     GL_LUMINANCE,
                     GL_UNSIGNED_BYTE,
                     videoFrame->channelPixelBuffer[channel]);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    }
    return YES;
}

@end
