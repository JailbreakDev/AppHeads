#import <SRClasses/SRNotificationObserver.h>
#import <SRClasses/SRAppHeadsViewController.h>
#import <SRClasses/SRTouchIDController.h>
#import <SRClasses/SRNotificationCenter.h>
#import <SRClasses/SRLocalizer.h>
#import <SRClasses/SRAppHeadsWindow.h>
#import <Classes/CHDraggableView.h>
#import <libactivator/libactivator.h>

@protocol SRAppHeadsViewControllerDelegate;
@class CHDraggableView,SRAppHeadsViewController,SRAppHeadsWindow;

@interface SRAppHeadsManager : NSObject
@property (nonatomic,readonly) NSInteger numberOfAppHeads;
@property (nonatomic,readonly) SRAppHeadsViewController *mainViewController;
@property (nonatomic,strong) SRAppHeadsWindow *mainWindow;
+(instancetype)sharedManager;
-(CHDraggableView *)draggableViewForIdentifier:(NSString *)displayIdentifier;
-(void)addAppHeadForPid:(NSInteger)pid inMode:(SRAppHeadsDisplayMode)mode;
-(void)removeAppHeadForPid:(NSInteger)pid;
-(void)removeAppHeadForDisplayIdentifier:(NSString *)displayIdentifier;
-(void)showExistingAppHeads:(SRAHVisibilitySource)source;
-(void)hideExistingAppHeads:(SRAHVisibilitySource)source;
-(void)pushDraggableViewToFrontWithIdentifier:(NSString *)identifier;
-(void)closeApplication:(SBApplication *)aApplication;
-(void)openApplication:(SBApplication *)aApplication;
-(void)activateApplication:(NSString *)app inBackground:(BOOL)background withCompletionBlock:(void(^)())completionBlock;
-(void)killAllApplications;
-(BOOL)suspendActiveDraggableView;
-(void)showLiveViewForBundleID:(NSString *)bundleID;
-(void)addAssertionToApp:(SBApplication *)app;
-(void)removeAssertionFromApp:(SBApplication *)app;
@end