//
//  MotionDescriptor.h
//  SwivlCommonLib
//
//  Created by Admin on 2/12/14.
//  Copyright (c) 2014 Duff Research. All rights reserved.
//

#import <Foundation/Foundation.h>

// Motion axis
#define AXIS_PAN                    0
#define AXIS_TILT                   1

// Types of movements
typedef enum
{
    MOVE_DUMMY,
    MOVE_IR_ALWAYS,             // Track IR marker
    MOVE_IR_ON_BUTTON,          // Track IR marker when Checkmark button is pressed
    MOVE_IR_OFF_BUTTON,         // Track IR marker when Checkmark button is released
    MOVE_WAIT_MS,               // Pause
    MOVE_TO_REL_POS,            // Relative Move. Move from current position by given number of steps
    MOVE_TO_ABS_POS,            // Absolute Move. Move to given position (in steps)
    MOVE_WITH_SPEED,            // Continuously move with given speed and direction
    MOVE_WITH_SPEED_AND_STOP,   // Continuously move with given speed and stop after timeout
} MoveType_t;

@interface MotionDescriptor : NSObject

@property (nonatomic, assign) uint16_t ID;
@property (nonatomic, assign) uint8_t axis;     // Use AXIS_PAN or AXIS_TILT
@property (nonatomic, assign) uint8_t type;
@property (nonatomic, assign) int32_t steps;    // Number of steps to move and direction
@property (nonatomic, assign) uint16_t speed;   // Range 0 to 2000
@property (nonatomic, assign) BOOL startNow;
@property (nonatomic, assign) uint32_t timeoutMs;   // Optional. Use 0 to ignore.

- (NSString*)description;

- (BOOL)saveWithKey:(NSString*)key;
- (id)initFromKey:(NSString*)key;

@end
