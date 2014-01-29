//
//  IdleTimerManager.h
//  SwivlCommonApp
//
//  Copyright (c) 2013 Satarii Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>

/**
 Intended to provide a way of managing iOS inactivity/sleep timer syncronously by several clients/threads.
 Inactivity timer can be disabled due to video recording or file uploading, Swivl base connection or for other reasons.
 */
@interface IdleTimerManager : NSObject

enum IdleTimerClient {
    ITMClientRecording = 1 << 0,
    ITMClientUpload = 1 << 1,
    ITMClientDocked = 1 << 2,
    ITMClientOther = 1 << 3
};

/**
 Enables or disables iOS inactivity/sleep timer that will eventually put device to sleep.
 Sleep (i.e. timer) must be disabled whenever ANY client requests 'sleep disable' (canSleep = NO).
 Sleep should be enabled only when ALL clients clear their 'sleep disable' requests (canSleep = YES).
 @param canSleep enable sleep (YES) or disable sleep (NO).
 @param client client that requests sleep timer state change.
 */
+ (void)allowSleep:(BOOL)canSleep forClient:(enum IdleTimerClient)client;

@end
