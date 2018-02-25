//
//  KKFingerRotation.h
//  KKPlayer
//
//  Created by KKFinger on 17/01/2017.
//  Copyright © 2017 KKFinger. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface KKFingerRotation:NSObject
@property(nonatomic,assign)CGFloat x;
@property(nonatomic,assign)CGFloat y;
+ (instancetype)fingerRotation;
+ (CGFloat)degress;
- (void)clean;
@end
