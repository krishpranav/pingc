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

@end
