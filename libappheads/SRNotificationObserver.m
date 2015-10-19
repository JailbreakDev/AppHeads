#import <SRClasses/SRNotificationObserver.h>

@implementation SRNotificationObserver

-(void)startListeningWithActivationBlock:(void(^)(NSInteger pid))activationBlock 
										withDeactivationBlock:(void(^)(NSInteger pid))deactivationBlock 
										andTerminationBlock:(void(^)(NSInteger pid))terminationBlock {
		static int activateToken = 0;
		notify_register_dispatch("com.sharedroutine.appheads.activateapp", &activateToken, dispatch_get_main_queue(), ^(int token) {
			uint64_t pid = -1;
			notify_get_state(token,&pid);
 			if (activationBlock) {
 				activationBlock(pid);
 			}
		});

        static int suspendToken = 0;
		notify_register_dispatch("com.sharedroutine.appheads.suspendapp", &suspendToken, dispatch_get_main_queue(), ^(int token) {
			uint64_t pid = -1;
			notify_get_state(token,&pid);
			if (deactivationBlock) {
 				deactivationBlock(pid);
 			}
        });

        static int closeToken = 0;
		notify_register_dispatch("com.sharedroutine.appheads.closeapp", &closeToken, dispatch_get_main_queue(), ^(int token) {
			uint64_t pid = -1;
			notify_get_state(token,&pid);
			if (terminationBlock) {
				terminationBlock(pid);
			}
        });
}

+(void)observeWithActivationBlock:(void(^)(NSInteger pid))blockx deactivationBlock:(void(^)(NSInteger pid))blocky terminationBlock:(void(^)(NSInteger pid))blockz {
	[[self new] startListeningWithActivationBlock:blockx withDeactivationBlock:blocky andTerminationBlock:blockz];
}

@end
