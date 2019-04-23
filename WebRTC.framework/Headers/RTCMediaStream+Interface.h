/*
 * Copyright © 2014 GENBAND. All Rights Reserved.
 *
 * GENBAND CONFIDENTIAL. All information, copyrights, trade secrets
 * and other intellectual property rights, contained herein are the property
 * of GENBAND. This document is strictly confidential and must not be
 * copied, accessed, disclosed or used in any manner, in whole or in part,
 * without GENBAND's express written authorization.
 *
 */

#import "RTCMediaStream.h"

@class RTCVideoTrack;
@class RTCAudioTrack;
@class RTCMediaStream;

@protocol RTCMediaStreamDelegate <NSObject>

- (void) onRemoveAudioTrack:(RTCAudioTrack *)track mediaStream:(RTCMediaStream *)stream;
- (void) onAddAudioTrack:(RTCAudioTrack *)track mediaStream:(RTCMediaStream *)stream;
- (void) onRemoveVideoTrack:(RTCVideoTrack *)track mediaStream:(RTCMediaStream *)stream;
- (void) onAddVideoTrack:(RTCVideoTrack *)track mediaStream:(RTCMediaStream *)stream;

@end

@interface RTCMediaStream (Interface)

- (void) setDelegate:(id<RTCMediaStreamDelegate>)delegate;

@end