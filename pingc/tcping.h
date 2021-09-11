#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tcping : NSObject

@property (nonatomic, strong) NSDate * startTime;

- (instancetype)initWith:(dispatch_group_t)group queue:(dispatch_queue_t)queue;

- (void)connectSocket:(NSString *)domain port:(UInt16)port;

@end


NS_ASSUME_NONNULL_END
