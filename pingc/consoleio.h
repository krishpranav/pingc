/*
 * Copyright (c) 2021, Krisna Pranav
 *
 * SPDX-License-Identifier: MIT License
*/

// imports
#import <Foundation/Foundation.h>
#import "tcping.h"

/**
 @brief: enum
 */

enum OutputType: NSInteger {
    OutputTypeError,
    OutputTypeStandard
};

NS_ASSUME_NONNULL_BEGIN

/**
 @brief: ConsoleIO interface class
 */

@interface ConsoleIO : NSObject
+ (void)writeMessage:(NSString *)message to:(NSInteger) to;
+ (void)printUsage;
+ (void)printReulst:(BOOL)isFinish detail:(Tcping *)detail count:(NSUInteger)count lossCount:(NSUInteger)lossCount min:(NSNumber *)min max:(NSNumber *)max avge:(NSNumber *)avge;
@end

NS_ASSUME_NONNULL_END
