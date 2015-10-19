#include <mach/mach.h>
#include <libkern/OSCacheControl.h>
#include <stdbool.h>
#include <dlfcn.h>
#include <sys/sysctl.h>

//BioLockDown
 
@class SBApplication;
__attribute__((visibility("hidden")))
@interface BioLockdownController : NSObject
+ (BioLockdownController *)sharedController;
- (BOOL)requiresAuthenticationForApplication:(SBApplication *)application;
- (BOOL)authenticateForApplication:(SBApplication *)application actionText:(NSString *)actionText completion:(dispatch_block_t)completion failure:(dispatch_block_t)failure;
@end

#if __cplusplus
extern "C" {
#endif
void BKSDisplaySetSecureMode(bool onOff);
#if __cplusplus
}
#endif

typedef struct {
	int field1;
	int field2;
	unsigned long long field3;
	unsigned long long field4;
	CGPoint field5;
	CGPoint field6;
	CGPoint field7;
	CGPoint field8;
	double field9;
	long long field10;
	long long field11;
	double field12;
	BOOL field13;
} SCD_Struct_SB32;

@interface SBSecureWindow : UIWindow
+(BOOL)_isSecure;
@end
//UIKit

@interface UITapGestureRecognizer(PrivateAPI)
-(void)setMaximumIntervalBetweenSuccessiveTaps:(CGFloat)interval;
@end

@interface UIWindow (SBSecureWindow)
-(void)_setSecure:(BOOL)s;
+(id)allWindowsIncludingInternalWindows:(BOOL)arg1 onlyVisibleWindows:(BOOL)arg2 ;
-(BOOL)_isSecure;
@end

@class SBApplication;
@interface UIApplication (PrivateAPI)
-(id)displayIdentifier;
-(void)_deactivateForReason:(int)arg1 notify:(BOOL)arg2 ;
-(void)_saveApplicationPreservationStateIfSupported;
-(void)_terminateWithStatus:(int)arg;
-(void)terminateWithSuccess;
-(void)suspend;
-(void)_deactivateForReason:(int)arg1;
-(id)_mainScene;
-(SBApplication *)_accessibilityFrontMostApplication;
-(void)listenForNotifications; //appheads
-(long long)activeInterfaceOrientation;
-(void)setStatusBarOrientation:(long long)arg1 animated:(BOOL)arg2 ;
@end

@interface UIAlertView (PrivateAPI)
-(void)_setAccessoryView:(id)arg1 ;
@end

@interface UITextEffectsWindow : UIWindow
-(void)setNonServiceHosted:(BOOL)arg1;
+(id)sharedTextEffectsWindow;
@end

@interface UIWindow(PrivateAPI)
+(void)setAllWindowsKeepContextInBackground:(BOOL)arg1 ;
@end

@interface _UIScreenEdgePanRecognizer : NSObject
-(void)incorporateTouchSampleAtLocation:(CGPoint)arg1 timestamp:(double)arg2 modifier:(long long)arg3 interfaceOrientation:(long long)arg4 ;
-(void)setTargetEdges:(unsigned long long)arg1 ;
-(void)setScreenBounds:(CGRect)arg1 ;
@property (nonatomic,readonly) long long state;
@property (assign,nonatomic) unsigned long long targetEdges; 
-(id)initWithType:(long long)arg1 ;
-(void)reset;
-(void)setDelegate:(id)d;
-(CGPoint)_velocity;
@end

@protocol _UIScreenEdgePanRecognizerDelegate <NSObject>
@optional
-(void)screenEdgePanRecognizerStateDidChange:(id)arg1;

@end

//SpringBoard

@protocol SBReachabilityObserver
@required
-(void)handleReachabilityModeDeactivated;
-(void)handleReachabilityModeActivated;
@end

@interface SBReachabilityManager : NSObject
+(BOOL)reachabilitySupported;
+(id)sharedInstance;
-(void)removeObserver:(id)arg1 ;
-(void)addObserver:(id)arg1 ;
@end


@interface SBOrientationLockManager : NSObject
+(id)sharedInstance;
-(BOOL)isLocked;
@end

@interface SBOffscreenSwipeGestureRecognizer : NSObject
-(id)initForOffscreenEdge:(unsigned long long)arg1;
-(void)setMinTouches:(unsigned long long)arg1 ;
@end

typedef struct {
    int type;
    int modifier;
    NSUInteger pathIndex;
    NSUInteger pathIdentity;
    CGPoint location;
    CGPoint previousLocation;
    CGPoint unrotatedLocation;
    CGPoint previousUnrotatedLocation;
    double totalDistanceTraveled;
    UIInterfaceOrientation interfaceOrientation;
    UIInterfaceOrientation previousInterfaceOrientation;
    double timestamp;
    BOOL isValid;
} SBActiveTouch;

@class SBWindowContextHostManager;
@class FBScene;
@interface SBApplication : NSObject
@property (readonly) unsigned long long hash; 
@property (copy) NSString *displayIdentifier;
@property (nonatomic,readonly) int pid; 
-(BOOL)isAnyTerminationAssertionHeld;
-(void)deactivate;
-(id)_snapshotImageInfoForScreen:(id)arg1 launchingOrientation:(int)arg2 ;
-(void)resumeToQuit;
-(id)displayName;
-(id)bundleIdentifier;
-(BOOL)isSystemApplication;
-(BOOL)isWebApplication;
-(BOOL)isInternalApplication;
-(SBWindowContextHostManager *)mainScreenContextHostManager;
-(Class)iconClass;
-(BOOL)isRunning;
-(void)didExitWithInfo:(id)arg1 type:(int)arg2;
-(void)setApplicationState:(unsigned)arg1 ;
-(void)_setActivationState:(unsigned)arg1;
-(void)resumeForContentAvailable;
-(void)setDeactivationSetting:(unsigned)arg1 flag:(BOOL)arg2;
-(void)setActivationSetting:(unsigned)arg1 flag:(BOOL)arg2;
-(void)hostContextsOnScreen:(id)arg1 forRequester:(id)arg2;
-(void)didSuspend;
-(FBScene *)mainScene;
-(BOOL)isRunning;
@end

@interface SBWindowContext : NSObject
@property (nonatomic,readonly) unsigned identifier;
@property (nonatomic,readonly) float level;
@property (nonatomic,readonly) UIScreen * screen;
@property (assign,getter=isOrderOutPending,nonatomic) BOOL orderOutPending;
-(id)initWithIdentifier:(unsigned)arg1 level:(float)arg2 screen:(id)arg3 ;
@end

@interface SBWindowContextManager : NSObject 
@property (nonatomic,copy) NSString * identifier;
-(unsigned)numberOfContextsForScreen:(id)arg1 ;
-(void)addContext:(id)arg1 ;
-(id)contextWithIdentifier:(unsigned)arg1 screen:(id)arg2 ;
-(void)removeContext:(id)arg1 ;
-(id)contextsForScreen:(id)arg1 ;
@end

@interface SBIcon : NSObject
-(UIImage *)generateIconImage:(int)format;
@end

@interface SBLeafIcon : SBIcon
@end

@interface SBApplicationIcon : SBLeafIcon 
-(SBApplication *)application;
-(id)initWithApplication:(SBApplication *)app;
@end

@interface SBAppSliderSnapshotView : UIView
@property (assign,nonatomic) NSInteger orientation;                           
@property (nonatomic,retain) SBApplication *application;
-(UIImage *)_snapshotImage;
-(id)initWithApplication:(id)arg1 orientation:(int)arg2 async:(BOOL)arg3 withQueue:(id)arg4 statusBarCache:(id)arg5 ;
@end

@protocol SBAppSwitcherPageContentView <NSObject>
@optional
-(void)prepareToBecomeVisibleIfNecessary;
-(void)respondToBecomingInvisibleIfNecessary;

@required
-(int)orientation;
-(void)setOrientation:(int)arg1;
@end

@interface SBDefaultImageInfo : NSObject
@property (assign,nonatomic) BOOL hasSnapshot;
@property (nonatomic,retain) UIImage * image;
@end

@interface SBAppSwitcherPageView : UIView
@property (nonatomic,retain) UIView<SBAppSwitcherPageContentView> *view;
@end

@interface SBAppSliderScrollingViewController : UIViewController
@end

@interface SBAppSliderController : UIViewController
@property (nonatomic,readonly) NSArray * applicationList; 
-(void)sliderScroller:(id)arg1 itemWantsToBeRemoved:(unsigned)arg2;
-(SBAppSliderScrollingViewController *)pageController;
-(SBAppSwitcherPageView *)pageForDisplayIdentifier:(id)arg1;
-(void)_quitAppAtIndex:(unsigned)arg1;
-(void)_updateSnapshots;
-(id)_beginAppListAccess;
-(void)_endAppListAccess;
-(void)_temporarilyHostAppForQuitting:(id)arg1;
-(void)switcherWasPresented:(BOOL)arg1;
-(void)_disableContextHostingForApp:(id)arg1 ;
@end

@interface BKSSystemServiceClient : NSObject
-(void)terminateApplication:(id)arg1 forReason:(int)arg2 andReport:(BOOL)arg3 withDescription:(id)arg4 withResult:(/*^block*/ id)arg5 ;
-(void)terminateApplicationGroup:(int)arg1 forReason:(int)arg2 andReport:(BOOL)arg3 withDescription:(id)arg4 withResult:(/*^block*/ id)arg5 ;
@end

@class SBAppSwitcherController;
@interface SBUIController : NSObject
+(id)sharedInstance;
-(SBAppSliderController *)_appSliderController; //iOS 7
-(void)activateApplicationAnimated:(id)arg1;
-(void)getRidOfAppSwitcher;
-(BOOL)_activateAppSwitcherFromSide:(int)arg1 ;
-(void)_runAppSliderBringupTest;
-(void)removeAppFromSwitchAppList:(id)arg1;
-(void)_toggleSwitcher;
-(BOOL)isAppSwitcherShowing;
-(id)switcherController; //iOS 7
-(void)_removeDisplayLayout:(id)arg1 completion:(/*^block*/id)arg2 ;
-(SBAppSwitcherController *)_appSwitcherController; //iOS 8
-(id)systemGestureSnapshotWithIOSurfaceSnapshotOfApp:(id)arg1 includeStatusBar:(BOOL)arg2 ;
-(BOOL)clickedMenuButton;
@end

@interface SBWindowContextHostWrapperView : UIView
@property (nonatomic,retain) UIColor * backgroundColorWhileHosting; 
@property (nonatomic,retain) UIColor * backgroundColorWhileNotHosting; 
@end

@interface SBWindowContextHostView : UIView
@end

@interface SBWindowContextHostManager : NSObject
@property (nonatomic,readonly) UIScreen * screen;
-(void)resumeContextHosting;
-(id)_infoForRequester:(id)arg1 ;
-(void)orderRequesterFront:(id)arg1;
-(void)disableHostingForRequester:(id)arg1;
-(void)unhideHostViewOnDefaultWindowForRequester:(id)arg1 ;
-(void)enableHostingForRequester:(id)arg1 priority:(int)arg2 ;
-(void)enableHostingForRequester:(id)arg1 orderFront:(BOOL)arg2 ;
-(SBWindowContextHostWrapperView *)hostViewForRequester:(id)arg1;
-(SBWindowContextHostWrapperView *)hostViewForRequester:(id)arg1 enableAndOrderFront:(BOOL)front;
-(void)setContextId:(unsigned)arg1 hidden:(BOOL)arg2 forRequester:(id)arg3;
-(void)suspendContextHosting;
-(void*)createIOSurfaceForFrame:(CGRect)arg1 ; //ios 7
@end

@interface SBWindowContextHostInfo : NSObject
@property (nonatomic,readonly) SBWindowContextHostWrapperView * wrapperView;
@property (nonatomic,readonly) NSMutableSet * hiddenContexts;
@property (nonatomic,retain) NSDictionary * realContextHostViewChangedProperties;
@property (nonatomic,retain) NSDictionary * realContextHostViewOriginalProperties;
-(void)windowContextManager:(id)arg1 didRepositionContext:(id)arg2 from:(unsigned)arg3 to:(unsigned)arg4 forScreen:(id)arg5 ;
-(id)initWithContextManager:(id)arg1 hostManager:(id)arg2 screen:(id)arg3 jailBehavior:(int)arg4 ;
-(void)dealloc;
@end

@interface SBAppSwitcherModel : NSObject
+(id)sharedInstance;
-(void)addToFront:(id)arg1 ;
-(id)_recentsFromPrefs;
-(void)_invalidateSaveTimer;
-(void)_saveRecents;
-(void)_saveRecentsDelayed;
-(void)appsRemoved:(id)arg1 added:(id)arg2 ;
-(void)dealloc;
-(id)init;
-(id)snapshot;
-(id)identifiers;
-(void)remove:(id)arg1 ;
-(void)removeDisplayItem:(id)arg1 ;
@end

@interface SBBackgroundMultitaskingManager : NSObject 
@property (nonatomic,readonly) double watchdogTimeout;
+(id)sharedInstance;
-(int)nextSequenceNumber;
-(void)application:(id)arg1 didSetMinimumFetchInterval:(double)arg2 ;
-(void)_appStateDidChange:(id)arg1 ;
-(void)handlePushNotificationFromApplication:(id)arg1 userInfo:(id)arg2 priority:(int)arg3 completion:(/*^block*/ id)arg4 ;
-(void)workDidChange:(id)arg1 ;
-(id)_opportunisticallyUpdateApplications:(id)arg1 trigger:(unsigned)arg2 ;
-(void)_performPendingWorkForBundleID:(id)arg1 ;
-(void)_appFinishedBackgroundUpdating:(id)arg1 ;
-(void)_startBackgroundFetchForNotification:(id)arg1 ;
-(void)queue_appFinishedBackgroundUpdating:(id)arg1 userInfo:(id)arg2 ;
-(void)queue_startBackgroundFetchTaskForApplication:(id)arg1 trigger:(unsigned)arg2 sequenceNumber:(int)arg3 withWatchdoggableCompletion:(/*^block*/ id)arg4 ;
-(void)_invalidateBackgroundTasksForApplication:(id)arg1 ;
-(void)queue_bearTrap_AppWasSuspended:(id)arg1 ;
-(void)_watchdogCompletionForBackgroundFetchTaskValue:(id)arg1 ;
-(void)queue_fireWatchdoggableCompletionForBackgroundFetchTaskValue:(id)arg1 ;
-(void)queue_invalidateBackgroundTasksForApplication:(id)arg1 ;
-(void)queue_backgroundTaskFinished:(id)arg1 forApplication:(id)arg2 ;
-(void)_backgroundTaskFinished:(id)arg1 forApplication:(id)arg2 ;
-(double)watchdogTimeout;
-(void)_startBackgroundFetchTaskForApplication:(id)arg1 trigger:(unsigned)arg2 sequenceNumber:(int)arg3 withWatchdoggableCompletion:(/*^block*/ id)arg4 ;
-(BOOL)_launchAppForUpdating:(id)arg1 trigger:(unsigned)arg2 pushNotificationUserInfo:(id)arg3 withWatchdoggableCompletion:(/*^block*/ id)arg4 ;
-(id)init;
@end

@interface SBApplicationController : NSObject
+(id)sharedInstance;
-(SBApplication *)applicationsWithBundleIdentifier:(id)arg1;
-(SBApplication *)applicationWithDisplayIdentifier:(id)arg1;
-(SBApplication *)applicationWithPid:(int)arg1 ;
@end

@interface SBFWallpaperView : UIView
@property (readonly) UIImage * wallpaperImage;
@property (nonatomic,retain) UIView * contentView;  
-(id)initWithFrame:(CGRect)arg1; 
-(void)setParallaxEnabled:(BOOL)arg1;
@end

typedef struct {
	int startStyle;
	int endStyle;
	float transitionFraction;
} SCD_Struct_SB29;

@interface _SBFakeBlurView : UIView {
	SBFWallpaperView* _wallpaperView;
	UIImageView* _imageView;
}
@end

@interface SBFStaticWallpaperView : SBFWallpaperView
-(id)wallpaperImage;
@end

@interface SBWallpaperController : NSObject {
	SBFWallpaperView* _lockscreenWallpaperView;
	SBFWallpaperView* _homescreenWallpaperView;
	SBFWallpaperView* _sharedWallpaperView;
}
+(id)sharedInstance;
-(id)_newWallpaperViewForProcedural:(id)arg1 orImage:(id)arg2; 
-(SCD_Struct_SB29)currentHomescreenStyleTransitionState;
-(id)_newWallpaperEffectViewForVariant:(int)arg1 transitionState:(SCD_Struct_SB29)arg2;
-(_SBFakeBlurView *)_newFakeBlurViewForVariant:(int)arg1;
-(SBFStaticWallpaperView *)_wallpaperViewForVariant:(long long)arg1 ;
@end

@class SBSAccelerometer;
@protocol SBSAccelerometerDelegate <NSObject>
@optional
-(void)accelerometer:(SBSAccelerometer *)arg1 didChangeDeviceOrientation:(int)arg2;

@required
-(void)accelerometer:(SBSAccelerometer *)arg1 didAccelerateWithTimeStamp:(double)arg2 x:(float)arg3 y:(float)arg4 z:(float)arg5 eventType:(int)arg6;
@end

@interface SBSAccelerometer : NSObject
@property (assign,nonatomic) double updateInterval; 
@property (assign,nonatomic) BOOL accelerometerEventsEnabled; 
@property (assign,nonatomic) BOOL orientationEventsEnabled; 
@property (assign,nonatomic) id<SBSAccelerometerDelegate> delegate; 
@end

@interface SBLaunchAppListener : NSObject
-(void)_didLaunch;
-(void)_didFailToLaunch;
-(id)initWithDisplayIdentifier:(id)arg1 handlerBlock:(id)arg2 ;
@end

@interface BKSApplicationExitInfo : NSObject <NSCopying>
@property (assign,nonatomic) long long status;
@property (assign,nonatomic) int terminationReason;
@property (assign,nonatomic) BOOL wasReceiver;
-(id)initWithXPCDictionary:(id)arg1;
@end

@interface SBProxyRemoteView : UIView 
@property (nonatomic,retain) NSString * remoteViewIdentifier;              //@synthesize remoteViewIdentifier=_remoteViewIdentifier - In the implementation block
@property (assign,nonatomic) BOOL remoteViewOpaque;                        //@synthesize remoteViewOpaque=_remoteViewOpaque - In the implementation block
@property (assign,nonatomic) id delegate;                                  //@synthesize delegate=_delegate - In the implementation block
+(Class)layerClass;
-(void)setRemoteViewIdentifier:(NSString *)arg1 ;
-(void)_setIsConnected:(BOOL)arg1 ;
-(void)connectToContextID:(unsigned)arg1 forIdentifier:(NSString *)arg2 application:(id)arg3 ;
-(void)noteConnectionLost;
-(BOOL)remoteViewOpaque;
-(void)dealloc;
-(void)setDelegate:(id)arg1 ;
-(id)init;
-(id)delegate;
-(void)didMoveToSuperview;
-(void)setRemoteViewOpaque:(BOOL)arg1 ;
-(id)remoteViewIdentifier;
-(void)disconnect;
@end

@interface SBRemoteViewsController : NSObject 
-(id)sharedInstance;
-(void)unregisterRemoteViewsForApplication:(id)arg1 ;
-(void)registerRemoteContextID:(unsigned)arg1 forIdentifier:(id)arg2 opaque:(BOOL)arg3 size:(CGSize)arg4 application:(id)arg5 ;
-(void)unregisterRemoteIdentifier:(id)arg1 application:(id)arg2 ;
-(void)unregisterProxyRemoteView:(id)arg1 ;
-(void)_sequesterProxyRemoteView:(id)arg1 ;
-(id)_newProxyRemoteViewForIdentifier:(id)arg1 ;
-(id)proxyRemoteViewForIdentifier:(id)arg1 ;
-(void)dealloc;
-(id)init;
@end

@class BKSWorkspace;
@interface SBWorkspace : NSObject
@property (nonatomic,readonly) BKSWorkspace * bksWorkspace;
-(void)workspace:(id)arg1 applicationActivated:(id)arg2 ;
@end

@interface BKSWorkspace : NSObject
-(void)_sendResume:(id)arg1 ;
-(void)killall:(BOOL)arg1 ;
-(void)kill:(id)arg1 ;
-(void)kill:(id)arg1 withReason:(int)arg2 description:(id)arg3 ;
-(void)suspend:(id)arg1 ;
-(void)shutdown:(BOOL)arg1 ;
-(void)resume:(id)arg1 ;
-(void)activate:(id)arg1 withActivation:(id)arg2 ;
@end

@interface _UIBackdropViewSettings : NSObject
-(id)initWithDefaultValues;
+(id)settingsForStyle:(int)arg1 ;
@end

@interface _UIBackdropView : UIView
-(id)initWithSettings:(_UIBackdropViewSettings *)arg1 ;
-(id)initWithFrame:(CGRect)arg1 style:(int)arg2;
-(id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3 ;
@end

@interface _UIBackdropViewSettingsBlur : _UIBackdropViewSettings
-(void)setDefaultValues;
@end

@interface SBWorkspaceTransaction : NSObject
@end

@interface SBAppToAppWorkspaceTransaction : SBWorkspaceTransaction
-(id)initWithWorkspace:(id)arg1 alertManager:(id)arg2 exitedApp:(id)arg3 ;
-(id)initWithWorkspace:(id)arg1 alertManager:(id)arg2 from:(id)arg3 to:(id)arg4 activationHandler:(/*^block*/ id)arg5 ;
-(void)_commit;
-(SBApplication *)fromApp;
@end

@protocol SBWorkspaceTransactionDelegate <NSObject>
@required
-(void)transactionDidFinish:(id)arg1 success:(BOOL)arg2;
@end

@interface BKSApplicationSuspensionSettings : NSObject
@end

@class BKSApplicationDeactivationSettings,BKProcess;
@interface BKApplication : NSObject {
	BKSApplicationDeactivationSettings *_deactivationSettings;
}
-(void)_takeResumeProcessAssertionWithThrottledCPU:(BOOL)a;
-(BKProcess *)process;
-(id)bundleIdentifier;
-(void)_activate:(id)a;
-(void)_deactivate:(id)d;
-(void)setFrontmost:(BOOL)f;
-(void)_takeSuspendingProcessAssertion;
-(void)_removeActivationAssertionNamed:(id)name;
-(void)notifyOfTaskResume;
-(void)killForReason:(int)reason andReport:(BOOL)report withDescription:(id)description;
- (void)_addActivationAssertionNamed:(id)a;
- (void)_removeActivationAssertionNamed:(id)a;
@end

@interface BKWorkspaceServerManager : NSObject
+(id)sharedInstance;
-(id)applicationForPID:(int)pid;
-(id)workspaceForApplication:(id)app;
@end

@interface BKWorkspaceServer : NSObject
-(id)frontApplication;
-(void)suspend:(id)app;
-(void)resume:(id)arg1 ;
-(void)_sendApplicationDidBecomeReceiver:(id)arg1 fromApplication:(id)arg2 workspaceWillResume:(BOOL)arg3 ;
-(void)_sendApplicationSuspended:(id)arg1 withSettings:(id)arg2 ;
-(void)_activate:(id)app activationSettings:(id)settings deactivationSettings:(id)dSettings token:(id)token completion:(id)completion;
-(void)_activate:(id)arg1 withActivation:(id)arg2 withDeactivation:(id)arg3 token:(id)arg4 completion:(/*^block*/ id)arg5 ;
-(void)applicationDidSuspend:(id)app withSettings:(id)settings;
@end

@interface BKProcessAssertion : NSObject
- (instancetype)initWithReason:(unsigned int)arg1 identifier:(id)arg2;
- (void)setWantsForegroundResourcePriority:(BOOL)arg1;
- (void)setPreventThrottleDownCPU:(BOOL)arg1;
- (void)setPreventThrottleDownUI:(BOOL)arg1;
- (void)setPreventSuspend:(BOOL)arg1;
- (void)setAllowIdleSleepOverrideEnabled:(BOOL)arg1;
- (void)setPreventIdleSleep:(BOOL)arg1;
- (void)setFlags:(unsigned int)arg1;
- (void)invalidate;
- (id)identifier;
-(void)setDelegate:(id)delegate;
//ios 8
-(instancetype)initWithIdentifier:(id)arg1 ownerPid:(int)pid reason:(unsigned)r name:(id)name flags:(unsigned)f;
-(instancetype)initWithIdentifier:(id)arg1 reason:(unsigned)arg2 name:(id)name;
@end

@protocol BKProcessAssertionDelegate
-(void)processAssertionInvalidated:(BKProcessAssertion *)assertion;
@end

@interface BKProcess : NSObject
@property (assign) BOOL isViewService;
@property (getter=isFrontmost) BOOL frontmost;
+(void)deleteAllJobs;
-(BKProcess *)processForPid:(int)pid;
-(BOOL)hasAssertionForReason:(unsigned int)fp8;
-(void)addAssertion:(BKProcessAssertion *)assertion;
-(void)removeAssertion:(BKProcessAssertion *)assertion;
-(BOOL)_resumeForReason:(unsigned int)reason;
-(BOOL)_suspend;
-(BOOL)_taskSuspend;
-(BOOL)_taskResumeForReason:(unsigned int)reason;
-(BOOL)_setPriority:(int)arg1 ofResource:(int)arg2;
-(BOOL)_taskShutdownSockets:(int)arg1 ;
-(void)killWithSignal:(int)sig;
-(NSInteger)pid;
-(NSSet *)assertions;
-(void)_resumeIfSuspendedForSleep;
@end

@interface BKNewProcess : BKProcess
@end

@interface BKProcessInfoServer : NSObject
+(id)sharedInstance;
-(BKNewProcess *)processForPID:(NSInteger)pid;
@end

@interface BKSWorkspaceActivationTokenFactory : NSObject
+(id)sharedInstance;
-(id)generateToken;
@end

@interface BKSApplicationDeactivationSettings : NSObject
-(void)setAnimated:(BOOL)arg1 ;
-(id)initWithSettings:(id)arg1 zone:(id)arg2 ;
@end

@interface BKSApplicationActivationSettings : NSObject 
@property (assign,nonatomic) BOOL animated;
@property (assign,nonatomic) BOOL suspended;
@property (assign,nonatomic) BOOL suspendedEventsOnly;
@property (nonatomic,retain) NSURL * openURL;
@property (nonatomic,retain) NSData * payload;
@property (assign,nonatomic) BOOL safe;
@property (assign,nonatomic) BOOL firstLaunchAfterBoot;
@property (assign,nonatomic) BOOL enableTests;
@property (assign,nonatomic) double userLaunchEventTime;
@property (assign,nonatomic) double watchdogExtension;
@property (assign,nonatomic) BOOL forRemoteNotification;
@property (assign,nonatomic) BOOL forLocalNotification;
@property (assign,nonatomic) BOOL flip;
@property (assign,nonatomic) int interfaceOrientation;
@property (assign,nonatomic) int statusBarStyle;
@property (assign,nonatomic) BOOL statusBarHidden;
@property (assign,nonatomic) BOOL classic;
@property (assign,nonatomic) BOOL zoomInClassic;
@property (assign,nonatomic) BOOL forBackgroundContentFetching;
@property (assign,nonatomic) BOOL forBackgroundURLSession;
@end

@interface BKSApplicationProcessInfo : NSObject <NSCopying> 
@property (nonatomic,retain) NSNumber * pidNumber; 
@property (assign,nonatomic) BOOL suspended;
@end

@interface SBAlertItemsController : NSObject
+(id)sharedInstance;
-(void)activateAlertItem:(id)arg1;
-(void)deactivateAlertItem:(id)arg1 ;
@end

//#########IOS8#########

@interface SBBacklightController : NSObject
+(id)sharedInstance;
-(void)setIdleTimerDisabled:(BOOL)arg1 forReason:(id)arg2 ;
@end

@interface SBLockScreenManager : NSObject
@property (readonly) BOOL isUILocked;  
+(id)sharedInstance;
-(void)startUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 ;
@end

@interface SBDisplayItem : NSObject
@property (nonatomic,readonly) NSString * displayIdentifier; 
-(id)initWithType:(NSString*)arg1 displayIdentifier:(id)arg2 ;
@end

@interface SBAppSwitcherController : UIViewController
-(void)_quitAppWithDisplayItem:(SBDisplayItem *)arg1 ;
-(id)pageForDisplayLayout:(id)arg1;
-(void)_rebuildAppListCache;
-(void)_destroyAppListCache;
@end

@class FBScene;
@interface FBWindowContextHostManager : SBWindowContextHostManager //just a trick to avoid writing all the methods again
-(id)hostViewForRequester:(id)arg1 appearanceStyle:(unsigned long long)arg2 ;
-(id)snapshotViewWithFrame:(CGRect)arg1 excludingContexts:(id)arg2 opaque:(BOOL)arg3 ;
@end

@interface FBLayerHostContainer : CALayer 
@property (assign,nonatomic) double scale;                     //@synthesize scale=_scale - In the implementation block
@property (assign,nonatomic) double rotation;                  //@synthesize rotation=_rotation - In the implementation block
@property (assign,nonatomic) CGPoint translation;              //@synthesize translation=_translation - In the implementation block
-(void)setDebug:(BOOL)arg1 ;
@end

@interface FBWindowContextHostWrapperView : UIView
-(void)updateFrame;
@property (nonatomic,retain) UIColor * backgroundColorWhileHosting; 
@property (nonatomic,retain) UIColor * backgroundColorWhileNotHosting; 
@property (nonatomic,readonly) FBWindowContextHostManager * manager;
-(id)initWithHostManager:(id)arg1 ;
@end

@interface FBWindowContextHostView : UIView
@property (nonatomic,retain,readonly) FBScene * scene;
-(id)initWithScene:(id)arg1 ;
-(void)setDebug:(BOOL)arg1 ;
-(BOOL)isHosting;
-(void)sceneDidChangeBounds:(id)arg1 ;
-(void)_adjustLayerFrameAndTransform:(id)arg1 ;
@end

@interface BSAuditToken : NSObject
@end

@class FBWorkspace;
@interface FBProcess : NSObject
@property (nonatomic,retain,readonly) FBWorkspace* workspace;
@end

@interface FBProcessState : NSObject
@property (assign,getter=isForeground,nonatomic) BOOL foreground;
@property (assign,nonatomic) int pid; 
@end

@interface BSMachSendRight : NSObject
-(unsigned)sendRight;
@end

@interface FBApplicationProcess : FBProcess
-(BSMachSendRight *)GSEventPort;
+(void)deleteAllJobs;
-(void)stop;
@end

@interface UIMutableApplicationSceneClientSettings : NSObject
@property (assign,nonatomic) bool statusBarHidden;
@property (assign,nonatomic) bool idleTimerDisabled;
@end

@class BSAuditToken;
@interface FBWorkspace : NSObject
@property (nonatomic,retain,readonly) BSAuditToken* auditToken;
-(id)initWithParentProcess:(FBProcess *)arg1 queue:(id)arg2 callOutQueue:(id)arg3 ;
@end

@interface FBUIApplicationWorkspace : FBWorkspace
@end

@interface FBSMutableSceneSettings : NSObject
@property (assign,nonatomic) CGRect frame;
@property (assign,nonatomic) long long interfaceOrientation; 
@property (assign,getter=isBackgrounded,nonatomic) BOOL backgrounded; 
@end

@interface FBSSystemAppProxy : NSObject
+(id)sharedInstance;
-(void)openURL:(id)arg1 application:(id)arg2 options:(id)arg3 clientPort:(unsigned)arg4 withResult:(/*^block*/id)arg5 ;
@end

@interface FBSSystemService : NSObject
+(id)sharedService;
-(unsigned)createClientPort;
- (void)cleanupClientPort:(unsigned int)cp;
-(void)openURL:(id)arg1 application:(id)arg2 options:(id)arg3 clientPort:(unsigned)arg4 withResult:(/*^block*/id)arg5 ;
-(void)openApplication:(id)arg1 options:(id)arg2 clientPort:(unsigned)arg3 withResult:(/*^block*/id)arg4 ;
@end


@interface FBScene : NSObject
@property (nonatomic,retain,readonly) id display; 
@property (nonatomic,retain,readonly) FBSMutableSceneSettings * mutableSettings;
@property (nonatomic,retain,readonly) FBProcess* clientProcess;
@property (nonatomic,retain,readonly) FBWindowContextHostManager* contextHostManager; 
-(void)updateSettings:(id)arg1 withTransitionContext:(id)arg2 ;
-(void)_applyMutableSettings:(id)arg1 withTransitionContext:(id)arg2 completion:(/*^block*/id)arg3 ;
@end


@interface FBSceneManager : NSObject
+(id)sharedInstance;
-(id)sceneWithIdentifier:(id)arg1 ;
-(void)_orientationChanged:(long long)arg1 ;
-(void)_startContextHostingForScene:(id)arg1 ;
-(void)_stopContextHostingForScene:(id)arg1 ;
-(void)_updateScene:(id)arg1 withSettings:(id)arg2 transitionContext:(id)arg3 ;
-(void)_applyMutableSettings:(id)arg1 toScene:(id)arg2 asUpdate:(BOOL)arg3 withTransitionContext:(id)arg4 ;
-(void)_enqueueEventForScene:(id)arg1 withName:(id)arg2 block:(/*^block*/id)arg3 ;
-(void)_positionWrapperViewInRootViewOrderedCorrectly:(id)arg1 rootWindow:(id)arg2 ;
-(id)_rootWindowForDisplay:(id)arg1 ;
@end

@interface BSAnimationSettings : NSObject
+(id)settingsWithDuration:(double)arg1 delay:(double)arg2 timingFunction:(id)arg3 ;
@end

@interface FBSSceneTransitionContext : NSObject
@property (nonatomic,copy) BSAnimationSettings * animationSettings;
+(id)transitionContext;
@end

@interface UIApplicationSceneTransitionContext : FBSSceneTransitionContext
@end

@interface SBDisplayLayout : NSObject
@property (nonatomic,readonly) NSArray * displayItems; 
+(id)fullScreenDisplayLayoutForApplication:(SBApplication *)arg1 ;
@end

@interface FBSystemService : NSObject
-(void)_terminateProcess:(id)arg1 forReason:(long long)arg2 andReport:(bool)arg3 withDescription:(id)arg4 ;
-(void)_activateApplication:(id)arg1 options:(id)arg2 source:(id)arg3 originalSource:(id)arg4 withResult:(/*^block*/ id)arg5 ;
-(bool)_requiresOpenApplicationEntitlement:(id)arg1 options:(id)arg2 originalSource:(id)arg3 ;
-(void)_reallyActivateApplication:(id)arg1 options:(id)arg2 source:(id)arg3 originalSource:(id)arg4 withResult:(/*^block*/ id)arg5 ;
-(void)_activateURL:(id)arg1 application:(id)arg2 options:(id)arg3 source:(id)arg4 originalSource:(id)arg5 withResult:(/*^block*/ id)arg6 ;
-(void)terminateApplication:(id)arg1 forReason:(long long)arg2 andReport:(bool)arg3 withDescription:(id)arg4 source:(id)arg5 ;
-(void)terminateApplicationGroup:(long long)arg1 forReason:(long long)arg2 andReport:(bool)arg3 withDescription:(id)arg4 source:(id)arg5 ;
-(void)canActivateApplication:(id)arg1 withResult:(/*^block*/ id)arg2 ;
-(void)activateApplication:(id)arg1 options:(id)arg2 source:(id)arg3 originalSource:(id)arg4 withResult:(/*^block*/ id)arg5 ;
-(void)activateURL:(id)arg1 application:(id)arg2 options:(id)arg3 source:(id)arg4 originalSource:(id)arg5 withResult:(/*^block*/ id)arg6 ;
@end

@class BBBulletin,SBBulletinBannerItem;

@interface SBNotificationVibrantButton : UIButton
-(UILabel *)titleLabel;
@end

@protocol SBBannerButtonViewControllerDelegate
@required
-(void)buttonViewController:(id)arg1 didSelectButtonAtIndex:(unsigned long long)arg2;
@end

@interface SBBannerButtonView : UIView 
@property (nonatomic,retain) NSArray * buttons; 
@end

@interface SBBannerButtonViewController : UIViewController {
	NSArray* _buttons;
}
@property (nonatomic, copy, setter=sr_setBundleID:,getter=sr_getBundleID) NSString *sr_bundleID;
-(void)setButtonTitles:(id)arg1 ;
-(void)_buttonPressed:(id)arg1 ;
-(SBNotificationVibrantButton *)_buttonForActionTitle:(id)arg1 ;
-(SBBannerButtonView *)_buttonView;
-(void)setDelegate:(id<SBBannerButtonViewControllerDelegate>)arg1 ;
-(id<SBBannerButtonViewControllerDelegate>)delegate;
@end

@interface SBBannerContainerViewController : UIViewController
-(SBBulletinBannerItem *)_bannerItem;
- (void)_addChildPullDownViewController:(UIViewController *)viewCtrl;
-(SBBannerButtonViewController *)_newbuttonViewController;
-(void)_setButtonViewController:(id)arg1 ;
-(void)_removeButtonViewController;
-(void)_removeChildPullDownViewController:(id)arg1 ;
-(void)_setSecondaryContentViewController:(id)arg1 ;
@end

@interface SBUIBannerItem : NSObject
-(BBBulletin *)pullDownNotification;
-(NSArray *)subActions; //SBUIBannerAction objects
@end

@interface SBBulletinBannerItem : SBUIBannerItem
-(BBBulletin *)seedBulletin;
@end

@interface SBBannerContextView : UIView
@property (assign,nonatomic) CGFloat maximumHeight;
@property (nonatomic,retain) UIView * pullDownView;
@property (assign,nonatomic) CGFloat pullDownViewHeight; 
@property (nonatomic,retain) UIView * secondaryContentView;
@end

@interface SBBulletinBannerController : NSObject
+(id)sharedInstance;
-(void)_removeBulletin:(id)arg1 ;
-(BOOL)_replaceBulletin:(id)arg1 ;
-(void)_queueBulletin:(id)arg1 ;
-(void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned long long)arg3 ;
-(void)observer:(id)arg1 modifyBulletin:(id)arg2 ;
-(void)observer:(id)arg1 removeBulletin:(id)arg2 ;
@end

@class SBUIBannerContext;
@interface SBBannerController : NSObject <SBBannerButtonViewControllerDelegate> {
	SBBannerContainerViewController* _bannerViewController;
}
+(id)sharedInstance;
-(SBBulletinBannerItem *)_bannerItem;
-(SBBannerContextView *)_bannerView;
-(void)bannerViewController:(id)arg1 willSelectActionWithContext:(id)arg2 ;
-(void)bannerViewControllerDidSelectAction:(id)arg1 ;
-(SBUIBannerContext *)_bannerContext;
@end

@interface SBUIBannerContext : NSObject
@property (nonatomic,retain,readonly) SBUIBannerItem * item; 
@end

//BulletinBoard

@interface BBAction : NSObject
+(id)actionWithIdentifier:(id)arg1 ;
+(id)actionWithLaunchURL:(id)arg1 callblock:(/*^block*/id)arg2 ;
+(id)actionWithLaunchBundleID:(id)arg1 callblock:(/*^block*/id)arg2 ;
+(id)actionWithCallblock:(/*^block*/id)arg1 ;
+(id)actionWithAppearance:(id)arg1 ;
+(id)actionWithIdentifier:(id)arg1 title:(id)arg2 ;
+(id)actionWithLaunchURL:(id)arg1 ;
+(id)actionWithLaunchBundleID:(id)arg1 ;
+(id)actionWithActivatePluginName:(id)arg1 activationContext:(id)arg2 ;
@property (nonatomic,copy) NSString * launchBundleID; 
@end

@interface BBBulletin : NSObject
@property (nonatomic,retain) NSMutableDictionary * supplementaryActionsByLayout;
@property (nonatomic,copy) NSString * sectionID;
@property (nonatomic,copy) NSArray *buttons;
@property (nonatomic,copy) BBAction * defaultAction; 
@property (nonatomic,copy) BBAction * alternateAction; 
@property (nonatomic,copy) NSMutableDictionary * actions;
@end

@interface BBSound : NSObject
+(id)alertSoundWithSystemSoundID:(unsigned)arg1 ;
@end

@interface BBButton : NSObject
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) BBAction * action;
+(id)buttonWithTitle:(id)arg1 action:(id)arg2 identifier:(id)arg3 ;
+(id)buttonWithTitle:(id)arg1 action:(id)arg2 ;
@end

@interface BBBulletinRequest : BBBulletin
@property (nonatomic,copy) NSString * bulletinID;
@property (nonatomic,copy) NSString * sectionID; 
@property (nonatomic,copy) NSString * publisherBulletinID;
@property (nonatomic,copy) NSString * recordID;
@property (nonatomic,copy) NSString * title; 
@property (nonatomic,copy) NSString * subtitle; 
@property (nonatomic,copy) NSString * message;
@property (nonatomic,retain) NSDate * date; 
@property (nonatomic,copy) BBAction * defaultAction; 
@property (nonatomic,retain) BBSound * sound; 
-(void)generateNewBulletinID;
-(void)addButton:(BBButton *)arg1;
@end

//baseboard

@interface BSLaunchdUtilities : NSObject
+(id)allJobLabels;
+(BOOL)stopJobWithLabel:(id)arg1 ;
+(BOOL)startJobWithLabel:(id)arg1 ;
+(id)labelForPID:(int)arg1 ;
+(id)currentJobLabel;
+(unsigned long long)lastExitReasonForLabel:(id)arg1 ;
+(void)deleteJobWithLabel:(id)arg1 ;
+(void)deleteAllJobsWithLabelPrefix:(id)arg1 ;
+(BOOL)createJobWithLabel:(id)arg1 bundleIdentifier:(id)arg2 path:(id)arg3 containerPath:(id)arg4 arguments:(id)arg5 environment:(id)arg6 standardOutputPath:(id)arg7 standardErrorPath:(id)arg8 machServices:(id)arg9 threadPriority:(long long)arg10 waitForDebugger:(BOOL)arg11 denyCreatingOtherJobs:(BOOL)arg12 runAtLoad:(BOOL)arg13 disableASLR:(BOOL)arg14 systemApp:(BOOL)arg15 ;
+(int)pidForLabel:(id)arg1 ;
@end

@interface BKLaunchdUtilities : BSLaunchdUtilities //just a trick to avoid writing all the methods again
@end

//backboardservices

@interface BKSProcessAssertion : NSObject
@property (nonatomic,copy) NSString * name; 
@property (assign,nonatomic) unsigned flags; 
@property (nonatomic,readonly) unsigned reason; 
@property (nonatomic,readonly) BOOL valid; 
@property (nonatomic,copy) id invalidationHandler; 
@property (readonly) unsigned long long hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
+(id)NameForReason:(unsigned)arg1 ;
-(id)initWithPID:(int)arg1 flags:(unsigned)arg2 reason:(unsigned)arg3 name:(id)arg4 withHandler:(/*^block*/id)arg5 ;
-(id)initWithBundleIdentifier:(id)arg1 flags:(unsigned)arg2 reason:(unsigned)arg3 name:(id)arg4 withHandler:(/*^block*/id)arg5 ;
-(void)invalidate;
@end