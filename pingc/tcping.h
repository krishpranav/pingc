/*
 * Copyright (c) 2021, Krisna Pranav
 *
 * SPDX-License-Identifier: MIT License
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tcping : NSObject
@property (nonatomic, strong) NSDate * startTime;
@property (nonatomic) NSTimeInterval speed;
@property (nonatomic, copy) NSString * domain;
@property (nonatomic, copy) NSString * host;
@property (nonatomic) UInt16 port;
@property (nonatomic) dispatch_group_t group;
@property (nonatomic) dispatch_queue_t queue;

- (instancetype)initWith:(dispatch_group_t)group queue:(dispatch_queue_t) queue;

- (void)connectSocket:(NSString *)domain port:(UInt16)port;

@end

NS_ASSUME_NONNULL_END
