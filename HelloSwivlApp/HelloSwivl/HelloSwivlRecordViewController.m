//
//  HelloSwivlRecordViewController.m
//  HelloSwivl
//
//  Copyright (c) 2013 Satarii Inc. All rights reserved.
//

#import "HelloSwivlRecordViewController.h"

NSString* AppRecordingStatusUpdateNotification = @"AppRecordingStatusUpdateNotification";

@interface HelloSwivlRecordViewController ()
- (void)notifiedAccessoryDetected:(id)unused;
- (void)notifiedSwivlRecordingStatusChanged:(NSNotification*)recording;
- (void)setRecordingState:(BOOL)recording;
@end

@implementation HelloSwivlRecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

	UISwipeGestureRecognizer* swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
	swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
	
	m_recordButtonHilite.hidden = NO;
	m_recordingActiveHilite.hidden = YES;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self 
										  selector:@selector(notifiedAccessoryDetected:) 
										  name:AVSandboxSwivlDockAttached object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self 
										  selector:@selector(notifiedSwivlRecordingStatusChanged:) 
										  name:SwivlRecordingStatusUpdateNotification object:nil];
	g_appDelegate.atRecordingView = YES;

	// Notify Swivl that you are at the recording screen:
    NSNotification* event = [NSNotification
								notificationWithName:AVSandboxNavToFromRecordingScreen
								object:[NSNumber numberWithBool:YES]];

    [[NSNotificationCenter defaultCenter] postNotification:event];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	g_appDelegate.atRecordingView = NO;

	// Notify Swivl that you are leaving the recording screen:
    NSNotification* event = [NSNotification
								notificationWithName:AVSandboxNavToFromRecordingScreen
								object:[NSNumber numberWithBool:NO]];

    [[NSNotificationCenter defaultCenter] postNotification:event];

	// Recording can only occur while at the RecordingScreen, so
	// tell everybody (the delegate, the Swivl if present) that
	// Recording is not happening..

	

	if (g_appDelegate.isRecording && g_appDelegate.swivl.swivlConnected)
	{
		NSNotification* event = [NSNotification 
									notificationWithName:AVSandboxRecordingStoppedNotification
									object:nil];
		[[NSNotificationCenter defaultCenter] postNotification:event];
	}

	g_appDelegate.isRecording = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)sender 
{
	[self performSegueWithIdentifier:@"goBack" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

- (void)notifiedAccessoryDetected:(id)unused
{
    NSLog(@"Accessory was detected %s", __FUNCTION__);
	[self performSegueWithIdentifier:@"goBack" sender:self];
}

- (void)notifiedSwivlRecordingStatusChanged:(NSNotification*)recording
{
    BOOL startRecording = [[recording object] boolValue];
	[self setRecordingState:startRecording];
}

- (IBAction)recordButtonPressed:(id)sender
{

	if (m_recordingActiveHilite.hidden)
	{
		[self setRecordingState:YES];
	}
	else
	{
		[self setRecordingState:NO];
	}
}

- (void)setRecordingState:(BOOL)recording
{
	if (recording)
	{
		m_recordingActiveHilite.hidden = NO;

		m_recordingActiveHilite.alpha = 1.0;
		[UIView animateWithDuration:0.4
				delay:0.0
				options:UIViewAnimationOptionCurveEaseOut |
				UIViewAnimationOptionRepeat |
				UIViewAnimationOptionAutoreverse |
				UIViewAnimationOptionAllowUserInteraction
				animations:^ { m_recordingActiveHilite.alpha = 0.0; }
		completion:nil];
	}
	else
	{
		m_recordingActiveHilite.hidden = YES;
	}

	g_appDelegate.isRecording = !m_recordingActiveHilite.hidden;
	
	// Update the Swivl with the latest Recording status:
    NSNotification* event = [NSNotification 
								notificationWithName:(g_appDelegate.isRecording ?
													  AVSandboxRecordingStartedNotification :
													  AVSandboxRecordingStoppedNotification )
								object:nil];

    [[NSNotificationCenter defaultCenter] postNotification:event];

}

@end
