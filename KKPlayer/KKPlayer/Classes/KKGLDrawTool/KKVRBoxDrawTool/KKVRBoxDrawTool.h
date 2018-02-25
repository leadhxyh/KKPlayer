//
//  KKVRBoxDrawTool.h
//  KKPlayer
//
//  Created by finger on 26/12/2016.
//  Copyright © 2016 finger. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface KKVRBoxDrawTool : NSObject
@property(nonatomic,assign)CGSize viewportSize;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)vrBoxDrawTool;
- (instancetype)initWithViewportSize:(CGSize)viewportSize;
- (void)beforDraw;
- (void)drawBox;
@end
