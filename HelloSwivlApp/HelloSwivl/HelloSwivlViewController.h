//
//  HelloSwivlViewController.h
//  HelloSwivl
//
//  Copyright (c) 2013 Satarii Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanningProgram.h"
#import "HelloSwivlAppDelegate.h"

@interface HelloSwivlViewController : UIViewController
{
	IBOutlet UILabel* m_status;
	IBOutlet UILabel* m_fwVersion;
	IBOutlet UILabel* m_markerBatteryLevel;
	IBOutlet UIImageView* m_markerBatteryLevelMeter;
	IBOutlet UILabel* m_swivlBatteryLevel;
	IBOutlet UIImageView* m_swivlBatteryLevelMeter;
	IBOutlet UILabel* m_swivlMode;
	IBOutlet UISegmentedControl* m_swivlModeSwitch;
	IBOutlet UILabel* m_modeOptions;
	IBOutlet UILabel* m_switchLabel;
	IBOutlet UISwitch* m_theSwitch;
	IBOutlet UILabel* m_trackSpeed;
	IBOutlet UISegmentedControl* m_trackSpeedSwitch;
	IBOutlet UILabel* m_programRepeatsSwitchLabel;
	IBOutlet UISwitch* m_programRepeatsSwitch;
	IBOutlet UIButton* m_runPanProgramButton;
	PanningProgram* panProgram;
@private
    NSTimer* m_updateTimer;
}
@property(strong, nonatomic) UILabel* status;
@property(strong, nonatomic) UILabel* fwVersion;
@property(strong, nonatomic) NSTimer* updateTimer;
@property(strong, nonatomic) UILabel* markerBatteryLevel;
@property(strong, nonatomic) UIImageView* markerBatteryLevelMeter;
@property(strong, nonatomic) UILabel* swivlBatteryLevel;
@property(strong, nonatomic) UIImageView* swivlBatteryLevelMeter;
@property(strong, nonatomic) UILabel* swivlMode;
@property(strong, nonatomic) UISegmentedControl* swivlModeSwitch;
@property(strong, nonatomic) UILabel* modeOptions;
@property(strong, nonatomic) UILabel* switchLabel;
@property(strong, nonatomic) UISwitch* theSwitch;
@property(strong, nonatomic) UILabel* trackSpeed;
@property(strong, nonatomic) UISegmentedControl* trackSpeedSwitch;
@property(strong, nonatomic) UILabel* programRepeatsSwitchLabel;
@property(strong, nonatomic) UISwitch* programRepeatsSwitch;
@property(strong, nonatomic) UIButton* runPanProgramButton;


- (IBAction)swivlModeSegmentChanged:(id)sender;
- (IBAction)switchChanged:(id)sender;
- (IBAction)trackingSpeedSegmentChanged:(id)sender;
- (IBAction)programRepeatsSwitchChanged:(id)sender;
- (IBAction)runPanProgramButtonPressed:(id)sender;

@end
