//
//  KKGLTexture.h
//  KKPlayer
//
//  Created by finger on 2017/3/27.
//  Copyright © 2017年 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "KKGLFrame.h"

@interface KKGLTexture:NSObject
- (BOOL)updateTextureWithGLFrame:(KKGLFrame *)glFrame aspect:(CGFloat *)aspect;//更新纹理图
- (void)flush;
@end
