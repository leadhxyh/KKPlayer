//
//  KKPlayerEventCenter.m
//  KKPlayer
//
//  Created by finger on 2018/2/9.
//  Copyright © 2018年 finger. All rights reserved.
//

#import "KKPlayerEventCenter.h"

@implementation KKPlayerEventCenter

+ (void)raiseEvent:(KKPlayerInterface *)player error:(NSError *)error{
    if(player.decoderType == KKDecoderTypeAVPlayer){
        [player switchDecoderToFFmpeg];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(player.errorBlock){
                player.errorBlock(player, error);
            }
            if(player.playerStateDelegate && [player.playerStateDelegate respondsToSelector:@selector(playerError:error:)]){
                [player.playerStateDelegate playerError:player error:error];
            }
        });
    }
}

+ (void)raiseEvent:(KKPlayerInterface *)player statePrevious:(KKPlayerState)previous current:(KKPlayerState)current{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(player.stateChangeBlock){
            player.stateChangeBlock(player, previous, current);
        }
        if(player.playerStateDelegate && [player.playerStateDelegate respondsToSelector:@selector(stateChange:preState:state:)]){
            [player.playerStateDelegate stateChange:player preState:previous state:current];
        }
    });
}

+ (void)raiseEvent:(KKPlayerInterface *)player progressPercent:(CGFloat)percent current:(CGFloat)current total:(CGFloat)total{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(player.progressChangeBlock){
            player.progressChangeBlock(player, percent, current, total);
        }
        if(player.playerStateDelegate && [player.playerStateDelegate respondsToSelector:@selector(progressChange:percent:currentTime:totalTime:)]){
            [player.playerStateDelegate progressChange:player percent:percent currentTime:current totalTime:total];
        }
    });
}

+ (void)raiseEvent:(KKPlayerInterface *)player playablePercent:(CGFloat)percent current:(CGFloat)current total:(CGFloat)total{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(player.playableChangeBlock){
            player.playableChangeBlock(player, percent, current, total);
        }
        if(player.playerStateDelegate && [player.playerStateDelegate respondsToSelector:@selector(playableChange:percent:currentTime:totalTime:)]){
            [player.playerStateDelegate playableChange:player percent:percent currentTime:current totalTime:total];
        }
    });
}

@end
