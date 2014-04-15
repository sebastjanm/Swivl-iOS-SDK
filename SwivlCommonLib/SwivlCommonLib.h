//
//  SwivlCommonLib.h
//  SwivlCommonLib
//
//  Created by Vince Cotter on 8/9/12.
//  Copyright (c) 2012 Duff Research. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PanningProgram.h"
#import "MotionDescriptor.h"

/* 
 * The library assumes the app has defined the following
 * NSNotification keys:
 */

extern NSString* AVSandboxSwivlDockAttached;
extern NSString* AVSandboxSwivlDockDetached;
extern NSString* AVSandboxMarkerBatteryLevelChanged;
extern NSString* AVSandboxBaseBatteryLevelChanged;
extern NSString* AVSandboxRecordingStoppedNotification; // Recording stopped for some reason (user, error, etc.)
extern NSString* AVSandboxRecordingStartedNotification; // Recording has started
extern NSString* AVSandboxFastTrackingEnabledStateChangedNotification; // to update the dock
extern NSString* AVSandboxNavToFromRecordingScreen; // keeps SwivlManager state machine in sync with UI (Bool obj is YES going to recording screen)
extern NSString* AVSandboxTrackingStateChangedNotification; // to update the app; check
extern NSString* AVSandboxPanningStateChangedNotification; // to update the app; check

/*
 * There are some UIAlert strings common to both the app,
 * and to the low-level code that manages the Swivl base:
 */
#define NEEDSFWUPDATE_TITLE         @"Required Firmware Update"
#define FWUPDATEINSTRUCTIONSURL     @"http://www.swivl.com/firmware-update/"
#define NEEDSFULLUPDATE_TITLE       @"Firmware Update Required"
#define UPDATEOLDVERSION_MSG        @"There is a required firmware update for your Swivl. Click on the Instructions button to proceed.\n" 
#define UPDATELATER_MSG             @"Not Now"
#define SHOWMEHOW_MSG               @"Instructions"

// Audio connector configuration options
#define AUDIO_CONNECTOR_APPLE       0x00
#define AUDIO_CONNECTOR_LAPTOP      0x05
#define AUDIO_CONNECTOR_SPECIAL     0x06


@protocol SwivlBaseDelegate <NSObject>
- (void) swivlLibVersion: (NSDictionary *)dict;	// SwivlCommonLib sets version info in the app with this call at start-up.
- (BOOL) appIsRecording;                        // Returns YES if app is currently recording video; NO otherwise.
- (void) setAppRecording: (BOOL ) recording;    // If 'recording' is YES, request the app start video recording. If NO, stop recording.
- (BOOL) appAtRecordingView;                    // Returns YES if app UI is at the recording view; NO otherwise.
- (void) transitionAppToRecordingView;          // Requests that the app transition itself (programmatically) to the recording view.
- (void) appTagsRecording;                      // (obsolete?) 

- (void) swivlMoveFinished: (UInt32)state withID:(UInt32)ID;

- (void) swivlScriptBufferState: (UInt8)state isRunning:(BOOL)isRunning;
- (void) swivlScriptResult: (SInt8)thread Result:(SInt8)res Run:(UInt16)run Stack:(UInt32)stack;

@optional //This metods works only on PRO version of LIB
- (void) baseAudioJackStateChanged: (BOOL)pluggedin;
@end

@interface SwivlCommonLib : NSObject

@property (readonly) BOOL swivlConnected;
@property BOOL programmedActionEnabled;
@property BOOL autoPanEnabled;
@property (readonly) BOOL panning;
@property (readonly) BOOL tracking;
@property BOOL fastTrackingEnabled;
@property (readonly) NSNumber *deprecatedBaseFW;
@property (readonly) signed char baseBatteryLevel;
@property (readonly) signed char markerBatteryLevel;
@property (readonly) BOOL primaryMarkerConnected;
@property (readonly) NSString* dockFWVersion;
@property BOOL verticalTrackingEnabled;

+ (SwivlCommonLib* ) sharedSwivlBaseForDelegate:(id)delegate;

// Called whenever the UI indicates that the user has left the screen where 
// tracking or programmed pan settings are changed
- (void) updateBaseSettings:(PanningProgram *) program;
- (BOOL) baseAudioJackState;

- (void) swivlMoveLoad: (MotionDescriptor*)move;
- (void) swivlMoveStartPan: (BOOL)pan andTilt:(BOOL)tilt;
- (void) swivlResetPanPosition;
- (UInt32) swivlLastFinishedMoveId;
- (UInt32) swivlMoveState;

- (int)  swivlScriptLoadBlock: (char*)data length:(int)length;
- (void) swivlScriptRequestBufferState;
- (void) swivlScriptStartThread: (uint16_t)threadStartSymbolLabel mainThreadFlag:(BOOL)mainFlag;
- (void) swivlScriptStartSingleThread;
- (void) swivlScriptStop;
- (int) swivlScriptSetMemory: (uint8_t)memLabel numParameters:(uint8_t)num buffer:(uint32_t*)buffer;

// Request is not necessary now. Extended state is sent periodically anyway.
- (void) swivlRequestExtendedState;

- (BOOL) swivlScriptLastIsRunningFlag;
- (UInt8) swivlScriptLastBufferState;

- (UInt8) swivlLastUsbState;
- (UInt8) swivlLastAudioConnectorConfig;

// Use one of the pre-defined parameters
// AUDIO_CONNECTOR_APPLE, AUDIO_CONNECTOR_LAPTOP or AUDIO_CONNECTOR_SPECIAL
- (void) swivlSetAudioConnectorConfig: (UInt8)config;

- (void) swivlSetCameraTriggerPortWithShutter: (BOOL)shutter andFocus:(BOOL)focus setOnOff:(BOOL)onoff timeout:(UInt32)timeout;

- (void) swivlUsbResetWithConnectorSelect: (BOOL)useMicroUsb;

@end
