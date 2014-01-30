//
//  HelloSwivlRecordViewController.h
//  HelloSwivl
//
//  Copyright (c) 2013 Satarii Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelloSwivlAppDelegate.h"

@interface HelloSwivlRecordViewController : UIViewController
{
	IBOutlet UIButton* m_recordButton;
	IBOutlet UIImageView* m_recordButtonHilite;
	IBOutlet UIImageView* m_recordingActiveHilite;
}

- (IBAction)recordButtonPressed:(id)sender;

@end
