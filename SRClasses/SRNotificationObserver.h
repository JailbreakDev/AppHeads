@interface SRNotificationObserver : NSObject
+(void)observeWithActivationBlock:(void(^)(NSInteger pid))blockx deactivationBlock:(void(^)(NSInteger pid))blocky terminationBlock:(void(^)(NSInteger pid))blockz;
@end