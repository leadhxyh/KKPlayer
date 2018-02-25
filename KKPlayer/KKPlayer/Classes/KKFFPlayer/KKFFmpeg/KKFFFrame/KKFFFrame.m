//
//  KKFFFrame.m
//  KKPlayer
//
//  Created by finger on 06/01/2017.
//  Copyright © 2017 finger. All rights reserved.
//

#import "KKFFFrame.h"
#import "KKTools.h"

@implementation KKFFFrame

- (void)startPlaying{
    self->_playing = YES;
    if ([self.delegate respondsToSelector:@selector(frameDidStartPlaying:)]) {
        [self.delegate frameDidStartPlaying:self];
    }
}

- (void)stopPlaying{
    self->_playing = NO;
    if ([self.delegate respondsToSelector:@selector(frameDidStopPlaying:)]) {
        [self.delegate frameDidStopPlaying:self];
    }
}

- (void)cancel{
    self->_playing = NO;
    if ([self.delegate respondsToSelector:@selector(frameDidCancel:)]) {
        [self.delegate frameDidCancel:self];
    }
}

//- (void)dealloc{
//    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
//}

@end


@implementation KKFFSubtileFrame

- (KKFFFrameType)type{
    return KKFFFrameTypeSubtitle;
}

@end


@implementation KKFFArtworkFrame

- (KKFFFrameType)type{
    return KKFFFrameTypeArtwork;
}

@end
