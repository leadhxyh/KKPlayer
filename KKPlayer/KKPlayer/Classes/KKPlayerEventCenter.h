//
//  KKPlayerEventCenter.h
//  KKPlayer
//
//  Created by finger on 2018/2/9.
//  Copyright © 2018年 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKPlayerInterface.h"

@interface KKPlayerEventCenter : NSObject
+ (void)raiseEvent:(KKPlayerInterface *)player error:(NSError *)error;
+ (void)raiseEvent:(KKPlayerInterface *)player statePrevious:(KKPlayerState)previous current:(KKPlayerState)current;
+ (void)raiseEvent:(KKPlayerInterface *)player progressPercent:(CGFloat)percent current:(CGFloat)current total:(CGFloat)total;
+ (void)raiseEvent:(KKPlayerInterface *)player playablePercent:(CGFloat)percent current:(CGFloat)current total:(CGFloat)total;
@end
