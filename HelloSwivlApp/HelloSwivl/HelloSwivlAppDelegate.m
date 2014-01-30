//
//  HelloSwivlAppDelegate.m
//  HelloSwivl
//
//  Copyright (c) 2013 Satarii Inc. All rights reserved.//

#import "HelloSwivlAppDelegate.h"

NSString* SwivlTransitionToRecordingScreenNotification = @"SwivlTransitionToRecordingScreenNotification";
NSString* SwivlRecordingStatusUpdateNotification = @"SwivlRecordingStatusUpdateNotification";

@interface HelloSwivlAppDelegate()
{
	SwivlCommonLib* m_swivl;
}
@end

HelloSwivlAppDelegate* g_appDelegate = nil;

@implementation HelloSwivlAppDelegate

@synthesize swivl = m_swivl;
@synthesize atRecordingView = m_atRecordingView;
@synthesize isRecording = m_isRecording;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
	g_appDelegate = self;
	m_swivl = [SwivlCommonLib sharedSwivlBaseForDelegate:self];

	self.atRecordingView = NO;
	self.isRecording = NO;

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark SwivlBaseDelegate

- (void) swivlLibVersion: (NSDictionary *)dict
{
    NSLog(@"SwivlCommonLib has sent us version information:[%@]", dict);
}

- (BOOL) appIsRecording
{
	BOOL recording = self.isRecording;
    return recording;
}

- (void) setAppRecording: (BOOL ) recording
{
    NSNotification* event =
        [NSNotification
            notificationWithName:SwivlRecordingStatusUpdateNotification
			object:[NSNumber numberWithBool:recording]];

    [[NSNotificationCenter defaultCenter] postNotification:event];

}

- (BOOL) appAtRecordingView
{
	BOOL atRecordingScreen = self.atRecordingView;
	return atRecordingScreen;
}

- (void) transitionAppToRecordingView
{
    NSNotification* event =
        [NSNotification
            notificationWithName:SwivlTransitionToRecordingScreenNotification
			object:nil];

    [[NSNotificationCenter defaultCenter] postNotification:event];
}

- (void) appTagsRecording
{
	NSLog(@"SwivlCommonLib has called %s [This function is deprecated!]", __FUNCTION__);
}

@end
