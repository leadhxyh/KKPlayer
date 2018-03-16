//
//  KKFFAudioFrame.h
//  KKPlayer
//
//  Created by finger on 2017/2/17.
//  Copyright © 2017年 single. All rights reserved.
//

#import "KKFFFrame.h"

@interface KKFFAudioFrame:KKFFFrame{
@public
    float *samples;
}
@property(nonatomic,assign)NSInteger outputOffset;
@property(nonatomic,assign)NSUInteger samplesLength;
@end
