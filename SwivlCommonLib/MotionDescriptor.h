//
//  MotionDescriptor.h
//  SwivlCommonLib
//
//  Created by Admin on 2/12/14.
//  Copyright (c) 2014 Duff Research. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MotionDescriptor : NSObject

@property (nonatomic, assign) uint16_t ID;
@property (nonatomic, assign) int axis;
@property (nonatomic, assign) BOOL isAbsolute;
@property (nonatomic, assign) int steps;
@property (nonatomic, assign) int speed;
@property (nonatomic, assign) BOOL startNow;
@property (nonatomic, assign) uint32_t timeoutMs;

- (NSString*)description;

- (BOOL)saveWithKey:(NSString*)key;
- (id)initFromKey:(NSString*)key;

@end
