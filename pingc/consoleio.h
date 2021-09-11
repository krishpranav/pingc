/*
 * Copyright (c) 2021, Krisna Pranav
 *
 * SPDX-License-Identifier: MIT License
*/

#import <Foundation/Foundation.h>

enum OutputType: NSInteger {
    OutputTypeError,
    OutputTypeStandard
};

@interface ConsoleIO : NSObject
+ (void) writeMessage: (NSString *)message to:(NSInteger) to;

@end
