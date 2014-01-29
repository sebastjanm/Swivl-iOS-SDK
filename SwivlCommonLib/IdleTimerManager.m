//
//  IdleTimerManager.m
//  SwivlCommonApp
//
//  Created by Geoff Chatterton on 10/11/12.
//
//

#import "IdleTimerManager.h"

unsigned int g_idleTimerDisabled = 0;

@implementation IdleTimerManager

+ (void)allowSleep:(BOOL)canSleep forClient:(enum IdleTimerClient)client
{
    if(canSleep)
        g_idleTimerDisabled &= ~client;
    else
        g_idleTimerDisabled |= client;

    [UIApplication sharedApplication].idleTimerDisabled = (g_idleTimerDisabled != 0);
    NSLog(@"idleTimerDisabled = %02x", g_idleTimerDisabled);
}

@end
