/*
 * Copyright (c) 2021, Krisna Pranav
 *
 * SPDX-License-Identifier: MIT License
*/

// imports
#import <Foundation/Foundation.h>
#import "consoleio.h"
#import "tcping.h"

BOOL running = YES;

void ping(NSString *domain, UInt16 port, UInt count, dispatch_group_t group, dispatch_queue_t queue, NSMutableArray<Tcping *> * sockets) {
    for (int i = 1; i <= count; ++i) {
        Tcping * t = [[Tcping alloc] initWith:group queue:queue];
        [sockets addObject:t];
        [t connectSocket:domain port:port];
        sleep(1);
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc < 3) {
            [ConsoleIO printUsage];
            return 0;
        }
        dispatch_queue_t queue = dispatch_queue_create("Tcping", NULL);
        dispatch_group_t group = dispatch_group_create();
        NSString * ip = @"";
        NSString * port = @"65535";
        NSMutableArray<Tcping *> * sockets = [[NSMutableArray alloc] initWithCapacity:1];
        if (argc == 3) {
            NSString * a = [[NSString alloc] initWithCString:argv[1] encoding:NSUTF8StringEncoding];
            NSString * b = [[NSString alloc] initWithCString:argv[2] encoding:NSUTF8StringEncoding];
            if ([a containsString:@":"]) {
                ip = a;
                port = b;
            } else if ([b containsString:@":"]) {
                ip = b;
                port = a;
            } else {
                if ([a length] > [b length]) {
                    ip = a;
                    port = b;
                } else {
                    ip = b;
                    port = a;
                }
            }
            UInt16 p = port.intValue;
            if (p) {
                ping(ip, p, 10, group, queue, sockets);
            } else {
                [ConsoleIO printUsage];
                return 0;
            }
        } else {
            int countIndex = 0;
            int countStringIndex = 0;
            NSString * argument = @"";
            NSString * count = @"";
            for (int i = 0; i < argc; ++i) {
                NSString * item = [[NSString alloc] initWithCString:argv[i] encoding:NSUTF8StringEncoding];
                
                if ([item isEqualToString:@"-c"] || [item isEqualToString:@"--count"]) {
                    argument = item;
                    countStringIndex = i;
                    countIndex = countStringIndex+1;
                    if (countIndex >= argc) {
                        [ConsoleIO printUsage];
                        return 0;
                    } else {
                        count = [[NSString alloc] initWithCString:argv[countIndex] encoding:NSUTF8StringEncoding];
                    }
                } else {
                    if (i != countIndex && i != countStringIndex) {
                        if ([item containsString:@":"] || [item containsString:@"."]) {
                            ip = item;
                        } else {
                            port = item;
                        }
                    }
                }
            }
            
            if ([argument isEqualToString:@"-c"] || [argument isEqualToString:@"--count"]) {
                UInt16 p = port.intValue;
                if (p && p <= 65535) {
                    UInt16 c = count.intValue;
                    if (c && c <= 65535) {
                        ping(ip, p, c, group, queue, sockets);
                    } else {
                        [ConsoleIO writeMessage:@"Count only a number, or out of range(1-65535)" to:OutputTypeStandard];
                        return 0;
                    }
                } else {
                    [ConsoleIO writeMessage:@"Port only a number, or out of range(1-65535)" to:OutputTypeStandard];
                    return 0;
                }
            } else {
                [ConsoleIO printUsage];
                return 0;
            }
        }
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (sockets.count > 0) {
                NSInteger successCount = 0;
                NSTimeInterval min = INFINITY;
                NSTimeInterval max = 0;
                NSTimeInterval sum = 0;
                for (Tcping * t in sockets) {
                    if (t.speed != INFINITY) {
                        successCount += 1;
                        if (t.speed > max) {
                            max = t.speed;
                        }
                        if (t.speed < min) {
                            min = t.speed;
                        }
                        sum += t.speed;
                    }
                }
                if (successCount == 0) {
                    [ConsoleIO printReulst:YES detail:sockets[0] count:sockets.count lossCount:sockets.count min:[NSNumber numberWithDouble:min] max:[NSNumber numberWithDouble:max] avge:[NSNumber numberWithDouble:INFINITY]];
                } else {
                    double s = successCount*1.0;
                    [ConsoleIO printReulst:YES detail:sockets[0] count:sockets.count lossCount:sockets.count-successCount min:[NSNumber numberWithDouble:min] max:[NSNumber numberWithDouble:max] avge:[NSNumber numberWithDouble:sum/s]];
                }
                running = NO;
            }
        });
        while (running && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
            return 0;
        }
    }
    return 0;
}
