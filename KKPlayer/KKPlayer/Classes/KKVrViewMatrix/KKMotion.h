//
//  KKMotion.h
//  KKPlayer
//
//  Created by finger on 16/01/2017.
//  Copyright © 2017 finger. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface KKMotion:NSObject
@property(nonatomic,assign,readonly,getter=isReady)BOOL ready;
- (void)start;
- (void)stop;
- (GLKMatrix4)modelViewMatrix;
@end
