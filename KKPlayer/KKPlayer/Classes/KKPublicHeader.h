//
//  KKPublicHeader.h
//  KKPlayer
//
//  Created by finger on 2018/2/9.
//  Copyright © 2018年 finger. All rights reserved.
//

#ifndef KKPublicHeader_h
#define KKPublicHeader_h

#import <Foundation/Foundation.h>
#import "RACEXTScope.h"
#import "KKTools.h"
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

// weak self
#define KKWeakSelf __weak typeof(self) weakSelf = self;
#define KKStrongSelf __strong typeof(weakSelf) strongSelf = weakSelf;

// log level
#ifdef DEBUG
#define KKPlayerLog(...) NSLog(__VA_ARGS__)
#else
#define KKPlayerLog(...)
#endif

#endif
