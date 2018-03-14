//
//  KKWaterMarkTool.h
//  KKPlayer
//
//  Created by KKFinger on 2018/3/14.
//  Copyright © 2018年 single. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "avfilter.h"
#import "buffersink.h"
#import "buffersrc.h"
#import "pixfmt.h"
#import "imgutils.h"

@interface KKWaterMarkTool : NSObject{
@public
    AVFilterContext *buffersinkCtx;
    AVFilterContext *buffersrcCtx;
    AVFilterGraph *filterGraph;
}

- (NSInteger)setupFilters:(NSString *)filtersDescr videoCodecCtx:(AVCodecContext *)videoCodecCtx;

@end
