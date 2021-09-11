/*
 * Copyright (c) 2021, Krisna Pranav
 *
 * SPDX-License-Identifier: MIT License
*/

// imports
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
        _queue = queue;
        _group = group;
        _speed = INFINITY;
    }
    return self;
}

- (void)connectSocket:(NSString *)domain port:(UInt16)port {
    _domain = domain;
    _port = port;
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_queue];
    if (!_socket.isConnected) {
        dispatch_group_enter(_group);
        _startTime = [NSDate date];
        NSError * error = nil;
        [_socket connectToHost:domain onPort:port withTimeout:1.0 error:&error];
        if (error) {
            dispatch_group_leave(_group);
        }
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    _host = host;
    _speed = ([[NSDate date] timeIntervalSince1970]-[_startTime timeIntervalSince1970])*1000;
    [ConsoleIO printReulst:NO detail:self count:0 lossCount:0 min:@0 max:@0 avge:@0];
    dispatch_group_leave(_group);
    [sock disconnect];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    if (err) {
        [ConsoleIO writeMessage:[err localizedDescription] to:OutputTypeError];
        dispatch_group_leave(_group);
    }
}
@end
