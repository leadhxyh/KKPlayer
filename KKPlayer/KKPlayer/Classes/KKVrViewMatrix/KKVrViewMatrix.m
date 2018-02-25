//
//  KKVrViewMatrix.m
//  KKPlayer
//
//  Created by KKFinger on 16/01/2017.
//  Copyright © 2017 KKFinger. All rights reserved.
//

#import "KKVrViewMatrix.h"
#import "KKMotion.h"

@interface KKVrViewMatrix ()
@property (nonatomic, strong) KKMotion *motion;
@end

@implementation KKVrViewMatrix

- (instancetype)init{
    if (self = [super init]) {
        [self setupMotion];
    }
    return self;
}

#pragma mark -- motion

- (void)setupMotion{
    self.motion = [[KKMotion alloc] init];
    [self.motion start];
}

- (BOOL)singleMatrixWithSize:(CGSize)size matrix:(GLKMatrix4 *)matrix fingerRotation:(KKFingerRotation *)fingerRotation{
    
    if (!self.motion.isReady) return NO;

    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, -fingerRotation.x);
    modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, self.motion.modelViewMatrix);
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, fingerRotation.y);
    
    float aspect = fabs(size.width / size.height);
    GLKMatrix4 mvpMatrix = GLKMatrix4Identity;
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians([KKFingerRotation degress]), aspect, 0.1f, 400.0f);
    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(0, 0, 0.0, 0, 0, -1000, 0, 1, 0);
    mvpMatrix = GLKMatrix4Multiply(projectionMatrix, viewMatrix);
    mvpMatrix = GLKMatrix4Multiply(mvpMatrix, modelViewMatrix);
    
    *matrix = mvpMatrix;
    
    return YES;
}

- (BOOL)doubleMatrixWithSize:(CGSize)size leftMatrix:(GLKMatrix4 *)leftMatrix rightMatrix:(GLKMatrix4 *)rightMatrix fingerRotation:(KKFingerRotation *)fingerRotation{
    
    if (!self.motion.isReady) return NO;
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, -fingerRotation.x);
    modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, self.motion.modelViewMatrix);
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, fingerRotation.y);
    
//    GLKMatrix4 modelViewMatrix = self.motion.modelViewMatrix;
    
    float aspect = fabs(size.width / 2 / size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians([KKFingerRotation degress]), aspect, 0.1f, 400.0f);
    
    CGFloat distance = 0.012;
    
    GLKMatrix4 leftViewMatrix = GLKMatrix4MakeLookAt(-distance, 0, 0.0, 0, 0, -1000, 0, 1, 0);
    GLKMatrix4 rightViewMatrix = GLKMatrix4MakeLookAt(distance, 0, 0.0, 0, 0, -1000, 0, 1, 0);
    
    GLKMatrix4 leftMvpMatrix = GLKMatrix4Multiply(projectionMatrix, leftViewMatrix);
    GLKMatrix4 rightMvpMatrix = GLKMatrix4Multiply(projectionMatrix, rightViewMatrix);
    
    leftMvpMatrix = GLKMatrix4Multiply(leftMvpMatrix, modelViewMatrix);
    rightMvpMatrix = GLKMatrix4Multiply(rightMvpMatrix, modelViewMatrix);
    
    *leftMatrix = leftMvpMatrix;
    *rightMatrix = rightMvpMatrix;
    
    return YES;
}

- (void)dealloc{
    [self.motion stop];
    KKPlayerLog(@"%@ release", self.class);
}

@end
