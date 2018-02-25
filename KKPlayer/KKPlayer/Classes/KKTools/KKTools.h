//
//  KKTools.h
//  KKPlayer
//
//  Created by finger on 19/01/2017.
//  Copyright © 2017 finger. All rights reserved.
//
#ifndef KKTools_h
#define KKTools_h

#import <Foundation/Foundation.h>
#import "pixfmt.h"
#import "avformat.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KKFFDecoderErrorCode) {
    KKFFDecoderErrorCodeFormatCreate,
    KKFFDecoderErrorCodeFormatOpenInput,
    KKFFDecoderErrorCodeFormatFindStreamInfo,
    KKFFDecoderErrorCodeStreamNotFound,
    KKFFDecoderErrorCodeCodecContextCreate,
    KKFFDecoderErrorCodeCodecContextSetParam,
    KKFFDecoderErrorCodeCodecFindDecoder,
    KKFFDecoderErrorCodeCodecVideoSendPacket,
    KKFFDecoderErrorCodeCodecAudioSendPacket,
    KKFFDecoderErrorCodeCodecVideoReceiveFrame,
    KKFFDecoderErrorCodeCodecAudioReceiveFrame,
    KKFFDecoderErrorCodeCodecOpen2,
    KKFFDecoderErrorCodeAuidoSwrInit,
};


#pragma mark - Util Function

void KKFFLog(void * context, int level, const char * format, va_list args);

NSError * KKFFCheckError(int result);
NSError * KKFFCheckErrorCode(int result, NSUInteger errorCode);

double KKFFStreamGetTimebase(AVStream * stream, double default_timebase);
double KKFFStreamGetFPS(AVStream * stream, double timebase);

#pragma mark -- NSDictionary<->AVDictionary

NSDictionary *KKFFAVDictionaryToNSDictionary(AVDictionary * avDictionary);
AVDictionary *KKFFNSDictionaryToAVDictionary(NSDictionary * dictionary);

#pragma mark -- YUV Utils

int KKYUVChannelFilterNeedSize(int linesize, int width, int height, int channel_count);
void KKYUVChannelFilter(UInt8 * src, int linesize, int width, int height, UInt8 * dst, size_t dstsize, int channel_count);
UIImage * KKYUVConvertToImage(UInt8 * src_data[], int src_linesize[], int width, int height, enum AVPixelFormat pixelFormat);

#pragma mark -- CFDictionary

void CFDictSetData(CFMutableDictionaryRef dict, CFStringRef key, uint8_t *value, uint64_t length);
void CFDictSetInt32(CFMutableDictionaryRef dict, CFStringRef key, int32_t value);
void CFDictSetString(CFMutableDictionaryRef dict, CFStringRef key, const char * value);
void CFDictSetBoolean(CFMutableDictionaryRef dict, CFStringRef key, BOOL value);
void CFDictSetObject(CFMutableDictionaryRef dict, CFStringRef key, CFTypeRef *value);

#pragma mark -- UIImage

UIImage * KKImageWithCGImage(CGImageRef image);

// CVPixelBufferRef
UIImage * KKImageWithCVPixelBuffer(CVPixelBufferRef pixelBuffer);
CIImage * KKImageCIImageWithCVPexelBuffer(CVPixelBufferRef pixelBuffer);
CGImageRef KKImageCGImageWithCVPexelBuffer(CVPixelBufferRef pixelBuffer);

// RGB data buffer
UIImage * KKImageWithRGBData(UInt8 * rgb_data, int linesize, int width, int height);
CGImageRef KKImageCGImageWithRGBData(UInt8 * rgb_data, int linesize, int width, int height);

#endif

