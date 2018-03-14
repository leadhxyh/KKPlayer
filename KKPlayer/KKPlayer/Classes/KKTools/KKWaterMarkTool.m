//
//  KKWaterMarkTool.m
//  KKPlayer
//
//  Created by KKFinger on 2018/3/14.
//  Copyright © 2018年 single. All rights reserved.
//

#import "KKWaterMarkTool.h"

@implementation KKWaterMarkTool

- (NSInteger)setupFilters:(NSString *)filtersDescr videoCodecCtx:(AVCodecContext *)videoCodecCtx{
    char args[512] = {0};
    int ret = -1 ;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        avfilter_register_all();
    });

    AVFilter *buffersrc = avfilter_get_by_name("buffer");
    AVFilter *buffersink = avfilter_get_by_name("buffersink");
    AVFilterInOut *outputs = avfilter_inout_alloc();
    AVFilterInOut *inputs = avfilter_inout_alloc();
    enum AVPixelFormat pix_fmts[] = { videoCodecCtx->pix_fmt, AV_PIX_FMT_NONE };
    AVBufferSinkParams *buffersink_params = NULL;
    
    buffersinkCtx = NULL;
    buffersrcCtx = NULL;
    filterGraph = avfilter_graph_alloc();
    
    /* buffer video source: the decoded frames from the decoder will be inserted here. */
    snprintf(args, sizeof(args),
             "video_size=%dx%d:pix_fmt=%d:time_base=%d/%d:pixel_aspect=%d/%d",
             videoCodecCtx->width, videoCodecCtx->height, videoCodecCtx->pix_fmt,
             1001, 24001,
             videoCodecCtx->sample_aspect_ratio.num, videoCodecCtx->sample_aspect_ratio.den);
    
    ret = avfilter_graph_create_filter(&buffersrcCtx, buffersrc,"in",args, NULL, filterGraph);
    if (ret < 0) {
        printf("Cannot create buffer source\n");
        return ret;
    }
    
    /* buffer video sink: to terminate the filter chain. */
    buffersink_params = av_buffersink_params_alloc();
    buffersink_params->pixel_fmts = pix_fmts;
    ret = avfilter_graph_create_filter(&buffersinkCtx,buffersink,"out",NULL,buffersink_params,filterGraph);
    av_free(buffersink_params);
    buffersink_params = NULL;
    if (ret < 0) {
        printf("Cannot create buffer sink\n");
        return ret;
    }
    
    /* Endpoints for the filter graph. */
    outputs->name = av_strdup("in");
    outputs->filter_ctx = buffersrcCtx;
    outputs->pad_idx = 0;
    outputs->next = NULL;
    
    inputs->name = av_strdup("out");
    inputs->filter_ctx = buffersinkCtx;
    inputs->pad_idx = 0;
    inputs->next = NULL;
    
    if ((ret = avfilter_graph_parse_ptr(filterGraph, filtersDescr.UTF8String,&inputs,&outputs, NULL)) < 0){
        return ret;
    }
    
    if ((ret = avfilter_graph_config(filterGraph, NULL)) < 0){
        return ret;
    }
    
    return 0;
}

@end
