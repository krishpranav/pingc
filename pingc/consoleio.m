/*
 * Copyright (c) 2021, Krisna Pranav
 *
 * SPDX-License-Identifier: MIT License
*/

#import "consoleio.h"
#import "version.h"

@implementation ConsoleIO
+ (void)writeMessage:(NSString *)message to:(NSInteger)to {
    switch (to) {
        case OutputTypeError:
            NSLog(@"%@", message);
            break;
        default:
            fputs(message.UTF8String, stderr);
            break;
    }
}

+ (void)printUsage {
   
    NSString * v = @""
"\npingc is a ping over tcp connection.\n"
"\n"
"Examples:\n\
    1. ping over tcp with custom port 10 times\n\
        > pingc www.baidu.com 80\n\
    2. ping over tcp with custom port 5 times\n\
        > pingc -c 5 www.baidu.com 443\n\
\n\
USAGE: pingc [--count <count>] <ip> <port>\n\
\n\
ARGUMENTS:\n\
    <ip>                    The IP or Domain to pingc.\n\
    <port>                  The port to pingc.\n\
\n\
OPTIONS:\n\
    -c, --count <count>     The number of times to repeat 'pingc'. Default value is 10, Max value is 65535\n\
    -h, --help              Show help information.\n";
    
    NSString * verbose = [NSString stringWithFormat:v, VERSION];
    [ConsoleIO writeMessage:verbose to:OutputTypeStandard];
}

+ (void)printReulst:(BOOL)isFinish detail:(Tcping *)detail count:(NSUInteger)count lossCount:(NSUInteger)lossCount min:(NSNumber *)min max:(NSNumber *)max avge:(NSNumber *)avge {
    NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
    nf.numberStyle = NSNumberFormatterDecimalStyle;
    nf.maximumFractionDigits = 3;
    
    if (isFinish) {
        [ConsoleIO writeMessage:[NSString stringWithFormat:@"Ping statistics %@:%u\n", detail.domain, detail.port] to:OutputTypeStandard];
        [ConsoleIO writeMessage:[NSString stringWithFormat:@"    %lu probes sent.\n", count] to:OutputTypeStandard];
        [ConsoleIO writeMessage:[NSString stringWithFormat:@"    %lu successful, %lu failed.\n", count-lossCount, lossCount] to:OutputTypeStandard];
        [ConsoleIO writeMessage:@"Approximate trip times:\n" to:OutputTypeStandard];
        [ConsoleIO writeMessage:[NSString stringWithFormat:@"    Minimum = %@ms, Maximum = %@ms, Average = %@ms\n", [nf stringFromNumber:min], [nf stringFromNumber:max], [nf stringFromNumber:avge]] to:OutputTypeStandard];
    } else {
        if ([detail.host isEqualToString:detail.domain]) {
            [ConsoleIO writeMessage:[NSString stringWithFormat:@"%@:%u - Connected - %@ms\n", detail.host, detail.port, [nf stringFromNumber:[NSNumber numberWithDouble:detail.speed]]] to:OutputTypeStandard];
        } else {
            [ConsoleIO writeMessage:[NSString stringWithFormat:@"%@:%u has address: %@:%u - Connected - %@ms\n", detail.domain, detail.port, detail.host, detail.port, [nf stringFromNumber:[NSNumber numberWithDouble:detail.speed]]] to:OutputTypeStandard];
        }
    }
}
@end
