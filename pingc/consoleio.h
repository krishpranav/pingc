/*
 * Copyright (c) 2021, Krisna Pranav
 *
 * SPDX-License-Identifier: MIT License
*/

#import <Foundation/Foundation.h>

/**
@brief: enum value
*/

enum OutputType: NSInteger {
    OutputTypeError,
    OutputTypeStandard
};

/**
@brief: interface ConsoleIO
*/

@interface ConsoleIO : NSObject
+ (void) writeMessage: (NSString *)message to:(NSInteger) to;

@end
