#import <SRClasses/SRNotificationCenter.h>

@interface SRNotificationCenter()
@property (nonatomic) int activateToken;
@property (nonatomic) int suspendToken;
@property (nonatomic) int closeToken;
@property (nonatomic) int hideToken;
@property (nonatomic) int showToken;
@property (nonatomic) int snappingToken;
@property (nonatomic) int orientationToken;
@end

@implementation SRNotificationCenter
@synthesize activateToken,suspendToken,closeToken,hideToken,showToken,snappingToken;

+(SRNotificationCenter *)defaultCenter {
	 static dispatch_once_t p = 0;

    __strong static SRNotificationCenter *_sharedSelf = nil;

    dispatch_once(&p, ^{
        _sharedSelf = [[self alloc] init];
        int suspend = 0,activate = 0,close = 0,hide = 0,show = 0,snap = 0,orientation = 0;
        notify_register_check("com.sharedroutine.appheads.suspendapp",&suspend);
        notify_register_check("com.sharedroutine.appheads.activateapp",&activate);
        notify_register_check("com.sharedroutine.appheads.closeapp",&close);
        notify_register_check("com.sharedroutine.appheads.hideAll",&hide);
        notify_register_check("com.sharedroutine.appheads.showAll",&show);
        notify_register_check("com.sharedroutine.appheads.snappingedge",&snap);
        notify_register_check("com.sharedroutine.appheads.orientation-changed",&orientation);
        [_sharedSelf setActivateToken:activate];
        [_sharedSelf setSuspendToken:suspend];
        [_sharedSelf setCloseToken:close];
        [_sharedSelf setHideToken:hide];
        [_sharedSelf setShowToken:show];
        [_sharedSelf setSnappingToken:snap];
        [_sharedSelf setOrientationToken:orientation];
    });

    return _sharedSelf;
}

-(void)postHideAllAppHeadsFromSource:(SRAHVisibilitySource)source {
    notify_set_state(self.hideToken, (uint64_t)source);
    notify_post("com.sharedroutine.appheads.hideAll");
}

-(void)postShowAllAppHeadsFromSource:(SRAHVisibilitySource)source {
	notify_set_state(self.showToken, (uint64_t)source);
    notify_post("com.sharedroutine.appheads.showAll");
}

-(void)postRemoveMailAppHead {
    notify_post("com.sharedroutine.appheads.removemail");
}

-(void)postAddMailAppHead {
    notify_post("com.sharedroutine.appheads.addmail");
}

-(void)postSnappingEdgeChanged:(CHSnappingEdge)edge {
    notify_set_state(self.snappingToken, (uint64_t)edge);
    notify_post("com.sharedroutine.appheads.snappingedge");
}

-(void)postActivateAppWithPid:(NSInteger)pid {
	notify_set_state(self.activateToken, (uint64_t)pid);
    notify_post("com.sharedroutine.appheads.activateapp");
}

-(void)postDeactivateAppWithPid:(NSInteger)pid {
	notify_set_state(self.suspendToken, (uint64_t)pid);
    notify_post("com.sharedroutine.appheads.suspendapp");
}

-(void)postCloseAppWithPid:(NSInteger)pid {
	notify_set_state(self.closeToken, (uint64_t)pid);
    notify_post("com.sharedroutine.appheads.closeapp");
}

-(void)postDeviceOrientationChanged:(NSInteger)orientation {
    notify_set_state(self.orientationToken, (uint64_t)orientation);
    notify_post("com.sharedroutine.appheads.orientation-changed");
}

-(void)postTouchIDConfirmationRequiredWithSuccessHandler:(void(^)())successBlock andFailureBlock:(void(^)())failuredBlock {
    notify_post("com.sharedroutine.appheads.touchid-confirmation");

    static int replyToken = 0;
    notify_register_dispatch("com.sharedroutine.appheads.touchid-reply", &replyToken, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(int token) {
        uint64_t resultCode = -1;
        notify_get_state(token,&resultCode);
          if (resultCode == 1) { //success
            if (successBlock) {
                successBlock();
            }
          } else { //failure
            if (failuredBlock) {
                failuredBlock();
            }
          }
    });
}

@end