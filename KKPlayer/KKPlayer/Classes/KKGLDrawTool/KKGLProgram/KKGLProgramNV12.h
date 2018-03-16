//
//  KKGLProgramNV12.h
//  KKPlayer
//
//  Created by finger on 2017/3/27.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "KKGLProgram.h"

@interface KKGLProgramNV12:KKGLProgram
@property(nonatomic,assign)GLint locationSamplerY;//sampler2D纹理图
@property(nonatomic,assign)GLint locationSamplerUV;//sampler2D纹理图
@property(nonatomic,assign)GLint locationColorConversionMatrix;
+ (instancetype)program;
@end
