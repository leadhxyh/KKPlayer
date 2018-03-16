//
//  KKGLProgramYUV420.h
//  KKPlayer
//
//  Created by finger on 2017/3/27.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "KKGLProgram.h"

@interface KKGLProgramYUV420 : KKGLProgram
@property(nonatomic,assign)GLint locationSamplerY;//sampler2D纹理图
@property(nonatomic,assign)GLint locationSamplerU;//sampler2D纹理图
@property(nonatomic,assign)GLint locationSamplerV;//sampler2D纹理图
+ (instancetype)program;
@end
