Swivl-iOS-SDK
=============

Swivl SDK for Swivl 2 hardware 

How To Get Started
---
1. In your pod file:

    ```ruby
pod 'Swivl-iOS-SDK',  :git => "git@github.com:Swivl/Swivl-iOS-SDK.git"
```
2. Install the dependencies in your project:

   ```bash
$ pod install
```
3. Add ``` #import "SwivlCommonLib.h" ``` to your project.
4. Create ```SwivlCommonLib``` object:
    
    ```objc
SwivlCommonLib *swivl = [SwivlCommonLib sharedSwivlBaseForDelegate:self]; 
```
5. Implement SwivlBaseDelegate protocol

Start/Stop recording
---
To start/stop recording implement ```- (BOOL) appIsRecording;``` method of ```SwivlBaseDelegate``` protocol:
```objc
- (BOOL) appIsRecording
{
    return YES; //start recording

    return NO; //stop recording
}
```
To get notification from Swivl when recording state is changed, just implement ``` - (void) setAppRecording: (BOOL ) recording;``` method of ```SwivlBaseDelegate``` protocol:
```objc
- (void) setAppRecording: (BOOL ) recording
{
    if (recording) 
    {
    //reacording was started
    }
    else 
    {
    //recording was stopped
    }
}
```
