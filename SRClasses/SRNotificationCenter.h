#import "NSDistributedNotificationCenter.h"

@interface SRNotificationCenter : NSDistributedNotificationCenter
-(void)postRemoveMailAppHead;
-(void)postAddMailAppHead;
-(void)postHideAllAppHeadsFromSource:(SRAHVisibilitySource)source;
-(void)postShowAllAppHeadsFromSource:(SRAHVisibilitySource)source;
-(void)postSnappingEdgeChanged:(CHSnappingEdge)edge;
-(void)postActivateAppWithPid:(NSInteger)pid;
-(void)postDeactivateAppWithPid:(NSInteger)pid;
-(void)postCloseAppWithPid:(NSInteger)pid;
-(void)postDeviceOrientationChanged:(NSInteger)orientation;
-(void)postTouchIDConfirmationRequiredWithSuccessHandler:(void(^)())successBlock andFailureBlock:(void(^)())failuredBlock;
@end