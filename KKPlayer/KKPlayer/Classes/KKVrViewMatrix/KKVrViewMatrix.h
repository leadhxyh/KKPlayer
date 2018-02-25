//
//  KKVrViewMatrix.h
//  KKPlayer
//
//  Created by KKFinger on 16/01/2017.
//  Copyright © 2017 KKFinger. All rights reserved.
//

#import "KKFingerRotation.h"

@interface KKVrViewMatrix : NSObject
- (BOOL)singleMatrixWithSize:(CGSize)size matrix:(GLKMatrix4 *)matrix fingerRotation:(KKFingerRotation *)fingerRotation;
- (BOOL)doubleMatrixWithSize:(CGSize)size leftMatrix:(GLKMatrix4 *)leftMatrix rightMatrix:(GLKMatrix4 *)rightMatrix fingerRotation:(KKFingerRotation *)fingerRotation;
@end
