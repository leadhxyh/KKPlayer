//
//  KKGLTexture.m
//  KKPlayer
//
//  Created by finger on 2017/3/27.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "KKGLTexture.h"

@implementation KKGLTexture

- (BOOL)updateTextureWithGLFrame:(KKGLFrame *)glFrame aspect:(CGFloat *)aspect{
    return NO;
}

- (void)flush{

}

- (void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
