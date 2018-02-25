//
//  KKTools.m
//  KKPlayer
//
//  Created by finger on 19/01/2017.
//  Copyright © 2017 finger. All rights reserved.
//

#import "KKTools.h"
#import "KKFFDecoder.h"
#import "swscale.h"
#import "imgutils.h"
#import "avformat.h"

#pragma mark - Util Function

void KKFFLog(void *context, int level, const char *format, va_list args){
//    NSString *message = [[NSString alloc] initWithFormat:[NSString stringWithUTF8String:format] arguments:args];
//    KKPlayerLog(@"KKFFLog : %@", message);
}

NSError * KKFFCheckError(int result){
    return KKFFCheckErrorCode(result, -1);
}

NSError * KKFFCheckErrorCode(int result, NSUInteger errorCode){
    if (result < 0) {
        char *error_string_buffer = malloc(256);
        av_strerror(result, error_string_buffer, 256);
        NSString *error_string = [NSString stringWithFormat:@"ffmpeg code : %d, ffmpeg msg : %s", result, error_string_buffer];
        NSError *error = [NSError errorWithDomain:error_string code:errorCode userInfo:nil];
        return error;
    }
    return nil;
}

double KKFFStreamGetTimebase(AVStream * stream, double default_timebase){
    double timebase;
    if (stream->time_base.den > 0 && stream->time_base.num > 0) {
        timebase = av_q2d(stream->time_base);
    } else {
        timebase = default_timebase;
    }
    return timebase;
}

double KKFFStreamGetFPS(AVStream *stream, double timebase){
    double fps;
    if (stream->avg_frame_rate.den > 0 && stream->avg_frame_rate.num > 0) {
        fps = av_q2d(stream->avg_frame_rate);
    } else if (stream->r_frame_rate.den > 0 && stream->r_frame_rate.num > 0) {
        fps = av_q2d(stream->r_frame_rate);
    } else {
        fps = 1.0 / timebase;
    }
    return fps;
}

#pragma mark -- NSDictionary<->AVDictionary

NSDictionary *KKFFAVDictionaryToNSDictionary(AVDictionary * avDictionary){
    if (avDictionary == NULL) return nil;
    
    int count = av_dict_count(avDictionary);
    if (count <= 0) return nil;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    AVDictionaryEntry *entry = NULL;
    while ((entry = av_dict_get(avDictionary, "", entry, AV_DICT_IGNORE_SUFFIX))) {
        @autoreleasepool {
            NSString * key = [NSString stringWithUTF8String:entry->key];
            NSString * value = [NSString stringWithUTF8String:entry->value];
            [dictionary setObject:value forKey:key];
        }
    }
    
    return dictionary;
}

AVDictionary * KKFFNSDictionaryToAVDictionary(NSDictionary * dictionary){
    if (dictionary.count <= 0) {
        return NULL;
    }
    
    __block BOOL success = NO;
    __block AVDictionary * dict = NULL;
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            av_dict_set_int(&dict, [key UTF8String], [obj integerValue], 0);
            success = YES;
        } else if ([obj isKindOfClass:[NSString class]]) {
            av_dict_set(&dict, [key UTF8String], [obj UTF8String], 0);
            success = YES;
        }
    }];
    if (success) {
        return dict;
    }
    return NULL;
}

#pragma mark -- YUV Utils

int KKYUVChannelFilterNeedSize(int linesize, int width, int height, int channel_count){
    width = MIN(linesize, width);
    return width * height * channel_count;
}

void KKYUVChannelFilter(UInt8 *src, int linesize, int width, int height, UInt8 *dst, size_t dstsize, int channel_count){
    width = MIN(linesize, width);
    UInt8 *temp = dst;
    memset(dst, 0, dstsize);
    for (int i = 0; i < height; i++) {
        memcpy(temp, src, width * channel_count);
        temp += (width * channel_count);
        src += linesize;
    }
}

UIImage * KKYUVConvertToImage(UInt8 * src_data[], int src_linesize[], int width, int height, enum AVPixelFormat pixelFormat){
    struct SwsContext * sws_context = NULL;
    sws_context = sws_getCachedContext(sws_context,
                                       width,
                                       height,
                                       pixelFormat,
                                       width,
                                       height,
                                       AV_PIX_FMT_RGB24,
                                       SWS_FAST_BILINEAR,
                                       NULL, NULL, NULL);
    if (!sws_context) return nil;
    
    uint8_t * data[AV_NUM_DATA_POINTERS];
    int linesize[AV_NUM_DATA_POINTERS];
    
    int result = av_image_alloc(data, linesize, width, height, AV_PIX_FMT_RGB24, 1);
    if (result < 0) {
        if (sws_context) {
            sws_freeContext(sws_context);
        }
        return nil;
    }
    
    result = sws_scale(sws_context, (const uint8_t **)src_data, src_linesize, 0, height, data, linesize);
    if (sws_context) {
        sws_freeContext(sws_context);
    }
    if (result < 0) return nil;
    if (linesize[0] <= 0 || data[0] == NULL) return nil;
    
    UIImage * image = KKImageWithRGBData(data[0], linesize[0], width, height);
    av_freep(&data[0]);
    
    return image;
}

#pragma mark -- CFDictionary

void CFDictSetData(CFMutableDictionaryRef dict, CFStringRef key, uint8_t *value, uint64_t length){
    CFDataRef data = CFDataCreate(NULL, value, (CFIndex)length);
    CFDictionarySetValue(dict, key, data);
    CFRelease(data);
}

void CFDictSetInt32(CFMutableDictionaryRef dict, CFStringRef key, int32_t value){
    CFNumberRef number = CFNumberCreate(NULL, kCFNumberSInt32Type, &value);
    CFDictionarySetValue(dict, key, number);
    CFRelease(number);
}

void CFDictSetString(CFMutableDictionaryRef dict, CFStringRef key, const char * value){
    CFStringRef string = CFStringCreateWithCString(NULL, value, kCFStringEncodingASCII);
    CFDictionarySetValue(dict, key, string);
    CFRelease(string);
}

void CFDictSetBoolean(CFMutableDictionaryRef dict, CFStringRef key, BOOL value){
    CFDictionarySetValue(dict, key, value ? kCFBooleanTrue: kCFBooleanFalse);
}

void CFDictSetObject(CFMutableDictionaryRef dict, CFStringRef key, CFTypeRef *value){
    CFDictionarySetValue(dict, key, value);
}

#pragma mark -- UIImage

UIImage *KKImageWithCGImage(CGImageRef image){
    return [UIImage imageWithCGImage:image];
}

UIImage *KKImageWithCVPixelBuffer(CVPixelBufferRef pixelBuffer){
    CIImage * ciImage = KKImageCIImageWithCVPexelBuffer(pixelBuffer);
    if (!ciImage) return nil;
    return [UIImage imageWithCIImage:ciImage];
}

CIImage *KKImageCIImageWithCVPexelBuffer(CVPixelBufferRef pixelBuffer){
    CIImage * image = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    return image;
}

CGImageRef KKImageCGImageWithCVPexelBuffer(CVPixelBufferRef pixelBuffer){
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);

    size_t count = CVPixelBufferGetPlaneCount(pixelBuffer);
    if (count > 1) {
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        return nil;
    }

    uint8_t * baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(pixelBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(baseAddress,
                                                 width,
                                                 height,
                                                 8,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);

    CGImageRef imageRef = CGBitmapContextCreateImage(context);

    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);

    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

    return imageRef;
}

UIImage *KKImageWithRGBData(UInt8 *rgb_data, int linesize, int width, int height){
    CGImageRef imageRef = KKImageCGImageWithRGBData(rgb_data, linesize, width, height);
    if (!imageRef) return nil;
    UIImage * image = KKImageWithCGImage(imageRef);
    CGImageRelease(imageRef);
    return image;
}

CGImageRef KKImageCGImageWithRGBData(UInt8 *rgb_data, int linesize, int width, int height){
    CFDataRef data = CFDataCreate(kCFAllocatorDefault, rgb_data, linesize * height);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imageRef = CGImageCreate(width,
                                       height,
                                       8,
                                       24,
                                       linesize,
                                       colorSpace,
                                       kCGBitmapByteOrderDefault,
                                       provider,
                                       NULL,
                                       NO,
                                       kCGRenderingIntentDefault);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provider);
    CFRelease(data);

    return imageRef;
}

