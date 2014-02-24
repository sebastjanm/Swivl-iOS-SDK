//
//  PanningProgram.h
//  AVSandbox
//
//  Created by Geoff Chatterton on 6/21/12.
//  Copyright (c) 2012 Duff Research LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanningProgram : NSObject

// E.g., continuous CCW pan:
// angle = -360
// reverses = NO
// repeats = YES

// perform a single, 10 degree pan:
// angle = 10
// reverses = NO
// repeats = NO

// perform a single, 10 degree, back-and-forth pan:
// angle = 10
// reverses = YES
// repeats = NO

// perform continuous, 10 degree, back-and-forth pan:
// angle = 10
// reverses = YES
// repeats = YES

// Not really valid, but should probably do a continuous CW pan:
// angle = 10
// reverses = NO
// repeats = YES

@property (nonatomic, assign) float degreesPerSecond;
@property (nonatomic, assign) float angle; //degrees
@property (nonatomic, assign) BOOL reverses;
@property (nonatomic, assign) BOOL repeats;

- (NSString*)description;

- (BOOL)saveWithKey:(NSString*)key;
- (id)initFromKey:(NSString*)key;

@end
