//
//  HelloSwivlAppDelegate.h
//  HelloSwivl
//
//  Copyright (c) 2013 Satarii Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwivlCommonLib.h"

extern NSString* SwivlTransitionToRecordingScreenNotification;
extern NSString* SwivlRecordingStatusUpdateNotification;
extern NSString* AppRecordingStatusUpdateNotification;

@class HelloSwivlAppDelegate;
HelloSwivlAppDelegate* g_appDelegate;

@interface HelloSwivlAppDelegate : UIResponder <UIApplicationDelegate>
{
	BOOL m_atRecordingView;
	BOOL m_isRecording;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SwivlCommonLib* swivl;
@property BOOL atRecordingView;
@property BOOL isRecording;

@end
