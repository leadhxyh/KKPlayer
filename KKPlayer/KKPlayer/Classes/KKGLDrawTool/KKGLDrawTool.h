//
//  KKGLDrawTool.h
//  KKPlayer
//
//  Created by finger on 2018/2/7.
//  Copyright © 2018年 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKPlayerInterface.h"

@class KKGLFrame;
@class KKRenderView;
@interface KKGLDrawTool : NSObject
- (instancetype)initWithVideoType:(KKVideoType)videoType
                       dispayType:(KKDisplayType)dispayType
                           glView:(GLKView *)glView
                       renderView:(KKRenderView *)renderView
                          context:(EAGLContext *)context;
- (BOOL)updateTextureWithGLFrame:(KKGLFrame *)glFrame aspect:(CGFloat *)aspect;
- (void)reloadVrBoxViewSize;
- (void)drawWithGLFrame:(KKGLFrame *)glFrame viewPort:(CGRect)viewport;
@end
