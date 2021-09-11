/*
 * Copyright (c) 2021, Krisna Pranav
 *
 * SPDX-License-Identifier: MIT License
*/

#import "tcping.h"
#import "consoleio.h"
#import "gcdasyncsocket.h"

@interface Tcping () <GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket * socket;
@end

@implementation Tcping

- (instancetype)initWith:(dispatch_group_t)group queue:(dispatch_queue_t)queue {
    self = [super init];
    if (self) {
        _host = @"";
        _port = @"";
        _queue = queue;
        _group = group;
        _speed = INFINITY;
    }
    return self;
}

- (void)connectSocket: (NSString *)domain port:(UInt16)port {
    _domain = domain;
    _port = port;
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_queue];
    if (!socket.isConnected) {
        dispatch_group_enter(_group);
        _startTime = [NSDate date];
        NSError * error = nil;
        [_socket connectToHost:domain onPort:port withTimeout:1.0 error:&error];
        if (error) {
            dispatch_group_level(_group);
        }
    }
}

@end
