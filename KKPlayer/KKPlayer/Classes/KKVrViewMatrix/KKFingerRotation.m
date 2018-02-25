//
//  KKFingerRotation.m
//  KKPlayer
//
//  Created by KKFinger on 17/01/2017.
//  Copyright © 2017 KKFinger. All rights reserved.
//

#import "KKFingerRotation.h"

@implementation KKFingerRotation

+ (instancetype)fingerRotation{
    return [[self alloc] init];
}

+ (CGFloat)degress{
    return 60.0;
}

- (void)clean{
    self.x = 0;
    self.y = 0;
}

@end
