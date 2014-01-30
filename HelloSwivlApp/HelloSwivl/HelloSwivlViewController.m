//
//  HelloSwivlViewController.m
//  HelloSwivl
//
//  Copyright (c) 2013 Satarii Inc. All rights reserved.
//

#import "HelloSwivlViewController.h"

@interface HelloSwivlViewController ()
- (void)notifiedAccessoryChanged:(id)unused;
- (void)updateUI;
- (UIImage*)batteryImageForLevel:(int)level;
- (void)swivlRequestsTransitionToRecordingScreen:(NSNotification*)notification;
@end

@implementation HelloSwivlViewController
@synthesize status = m_status;
@synthesize fwVersion = m_fwVersion;
@synthesize updateTimer = m_updateTimer;
@synthesize markerBatteryLevel = m_markerBatteryLevel;
@synthesize markerBatteryLevelMeter = m_markerBatteryLevelMeter;
@synthesize swivlBatteryLevel = m_swivlBatteryLevel;
@synthesize swivlBatteryLevelMeter = m_swivlBatteryLevelMeter;
@synthesize swivlMode = m_swivlMode;
@synthesize swivlModeSwitch = m_swivlModeSwitch;
@synthesize modeOptions = m_modeOptions;
@synthesize switchLabel = m_switchLabel;
@synthesize theSwitch = m_theSwitch;
@synthesize trackSpeed = m_trackSpeed;
@synthesize trackSpeedSwitch = m_trackSpeedSwitch;
@synthesize programRepeatsSwitchLabel = m_programRepeatsSwitchLabel;
@synthesize programRepeatsSwitch = m_programRepeatsSwitch;
@synthesize runPanProgramButton = m_runPanProgramButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	UISwipeGestureRecognizer* swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
	swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

	// Set up a default panning program:
	panProgram = [[PanningProgram alloc] init];
	panProgram.degreesPerSecond = 60.;
	panProgram.angle = 20.;
	panProgram.reverses = YES;
	panProgram.repeats = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiedAccessoryChanged:) name:AVSandboxSwivlDockAttached object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiedAccessoryChanged:) name:AVSandboxSwivlDockDetached object:nil];

    [self updateUI];

    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(swivlRequestsTransitionToRecordingScreen:)
        name:SwivlTransitionToRecordingScreenNotification
        object:nil];

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(m_updateTimer)
    {
        [m_updateTimer invalidate];
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self name:SwivlTransitionToRecordingScreenNotification object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)swivlModeSegmentChanged:(id)sender
{
    UISegmentedControl* segment = (UISegmentedControl*)sender;
    switch(segment.selectedSegmentIndex)
    {
	case 0: 
	{
		g_appDelegate.swivl.programmedActionEnabled = NO; 
		break;
	}
	case 1: 
	{
		g_appDelegate.swivl.programmedActionEnabled = YES; 
		break;
	}
	default: 
	{
		g_appDelegate.swivl.programmedActionEnabled = NO; 
		break;
	}
    }
	
	[g_appDelegate.swivl updateBaseSettings:panProgram];
	[self updateUI];
}

- (IBAction)switchChanged:(id)sender
{
    UISwitch* theSwitch = (UISwitch*)sender;

	if (g_appDelegate.swivl.programmedActionEnabled)
	{
		g_appDelegate.swivl.autoPanEnabled = theSwitch.isOn;
		[self updateUI];
	}
	else
	{
		g_appDelegate.swivl.verticalTrackingEnabled = theSwitch.isOn;
		[g_appDelegate.swivl updateBaseSettings:panProgram];
	}


}

- (IBAction)trackingSpeedSegmentChanged:(id)sender
{
    UISegmentedControl* segment = (UISegmentedControl*)sender;
    switch(segment.selectedSegmentIndex)
    {
	case 0: 
	{
		g_appDelegate.swivl.fastTrackingEnabled = NO; 
		break;
	}
	case 1: 
	{
		g_appDelegate.swivl.fastTrackingEnabled = YES; 
		break;
	}
	default: 
	{
		g_appDelegate.swivl.fastTrackingEnabled = NO; 
		break;
	}
	}

	[g_appDelegate.swivl updateBaseSettings:panProgram];

}

- (IBAction)programRepeatsSwitchChanged:(id)sender
{
    UISwitch* theSwitch = (UISwitch*)sender;
	panProgram.repeats = theSwitch.isOn;
	if (!g_appDelegate.swivl.autoPanEnabled)
	{	// Calling updateBaseSettings will start the pan if
		// autoPanEnabled is true, so don't make the call in this case.
		// Instead, pressing the 'runPanProgramButton' starts the pan.
		[g_appDelegate.swivl updateBaseSettings:panProgram];
	}
}

- (IBAction)runPanProgramButtonPressed:(id)sender
{
	[g_appDelegate.swivl updateBaseSettings:panProgram];
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)sender 
{
	[self performSegueWithIdentifier:@"segue" sender:self];
}

- (void)notifiedAccessoryChanged:(id)unused
{
    NSLog(@"Accessory status has changed %s", __FUNCTION__);
	
	[self updateUI];
}

- (void)updateUI
{
	BOOL swivlDetected = g_appDelegate.swivl.swivlConnected;

    if(m_updateTimer)
    {
        [m_updateTimer invalidate];
        self.updateTimer = nil;
    }

	if (swivlDetected)
	{
		self.status.text = @"Attached to Swivl";
		NSString *version = g_appDelegate.swivl.dockFWVersion;
		if ([version compare:@"Dock Doesn't Report FW Version"] == NSOrderedSame)
		{
			// Try again if you've asked too soon:
			self.fwVersion.text = @"Reading Swivl Base Firmware Version...";

			self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 
										target:self 
										selector:@selector(updateUI) 
										userInfo:nil repeats:NO];


		}
		else
		{
			self.fwVersion.text = [NSString stringWithFormat:@"Base Firmware: %@", version];
		}
		
	}
	else
	{
		self.status.text = @"No Swivl Detected";
	}

	self.fwVersion.hidden = !swivlDetected;
	self.markerBatteryLevel.hidden = !swivlDetected;
	self.markerBatteryLevelMeter.hidden = !swivlDetected;
	self.swivlBatteryLevel.hidden = !swivlDetected;
	self.swivlBatteryLevelMeter.hidden = !swivlDetected;
	self.swivlMode.hidden = !swivlDetected;
	self.swivlModeSwitch.hidden = !swivlDetected;
	self.swivlModeSwitch.selectedSegmentIndex = (g_appDelegate.swivl.programmedActionEnabled ? 1 : 0);
	
	if (swivlDetected)
	{
        self.markerBatteryLevelMeter.image = [self batteryImageForLevel:g_appDelegate.swivl.markerBatteryLevel];
        self.swivlBatteryLevelMeter.image = [self batteryImageForLevel:g_appDelegate.swivl.baseBatteryLevel];

		// If you're connected, check the battery levels every few seconds.
		// Mainly so you can detect when a Marker is turned on or off..
		self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 
									target:self 
									selector:@selector(updateUI) 
									userInfo:nil repeats:NO];

	}

	if (g_appDelegate.swivl.programmedActionEnabled)
	{
		self.trackSpeed.hidden = YES;
		self.trackSpeedSwitch.hidden = YES;
		self.programRepeatsSwitchLabel.hidden = !swivlDetected;
		self.programRepeatsSwitch.hidden = !swivlDetected;
		
		self.modeOptions.text = @"Panning Mode Options:";
		self.switchLabel.text = @"Automatic Pan";
		self.theSwitch.on = g_appDelegate.swivl.autoPanEnabled;
		self.programRepeatsSwitch.on = panProgram.repeats;
		self.runPanProgramButton.hidden = (g_appDelegate.swivl.autoPanEnabled ? !swivlDetected : YES);
	}
	else
	{
		self.trackSpeed.hidden = !swivlDetected;
		self.trackSpeedSwitch.hidden = !swivlDetected;
		self.programRepeatsSwitchLabel.hidden = YES;
		self.programRepeatsSwitch.hidden = YES;
		self.runPanProgramButton.hidden = YES;

		self.modeOptions.text = @"Tracking Mode Options:";
		self.switchLabel.text = @"Automatic Tilt";
		self.theSwitch.on = g_appDelegate.swivl.verticalTrackingEnabled;
	}

	self.modeOptions.hidden = !swivlDetected;
	self.switchLabel.hidden = !swivlDetected;
	self.theSwitch.hidden = !swivlDetected;

}

- (UIImage*)batteryImageForLevel:(int)level /* 0 - 100 */
{
    level = ((level + 5) / 10) * 10; // round up to nearest multiple of 10
    if(level > 100) level = 100;
    if(level < 0) level = 0;

    NSString* imageName = [NSString stringWithFormat:@"battery-%d.png", level];
    UIImage* image = [UIImage imageNamed:imageName];
    if(image == nil)
        image = [UIImage imageNamed:@"battery-0.png"];

    return image;
}

- (void)swivlRequestsTransitionToRecordingScreen:(NSNotification*)notification
{
	[self performSegueWithIdentifier:@"segue" sender:self];
}

@end
