#import <CommonCrypto/CommonCrypto.h>
#import <Security/Security.h>
#import <SRClasses/SRAppHeadsManager.h>
#import <SRClasses/SRNotificationCenter.h>
#import <SRClasses/SRSettings.h>
#import <SRClasses/SRNotificationObserver.h>
#import <SRClasses/SRAppHeadsViewController.h>
#import <SRClasses/SRLicenseDownloadController.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <execinfo.h>
#include <sys/stat.h>
#include <dlfcn.h>
#import "MobileGestalt.h"

@interface UIDevice (Orientation)
@property (assign,nonatomic) long long orientation;
@end

int willrotate = 0, didrotate = 0;

#if __cplusplus
extern "C" {
#endif

typedef enum {
        kCTCallStatusUnknown = 0,
        kCTCallStatusAnswered,
        kCTCallStatusDroppedInterrupted,
        kCTCallStatusOutgoingInitiated,
        kCTCallStatusIncomingCall,
   	    kCTCallStatusIncomingCallEnded
} CTCallStatus;

extern CFStringRef kCTCallStatusChangeNotification;

CFNotificationCenterRef CTTelephonyCenterGetDefault();
void CTTelephonyCenterAddObserver(CFNotificationCenterRef center, const void *observer, CFNotificationCallback callBack, CFStringRef name, const void *object, CFNotificationSuspensionBehavior suspensionBehavior);
void CTTelephonyCenterRemoveObserver(CFNotificationCenterRef center, const void *observer, CFStringRef name, const void *object);
void CTTelephonyCenterRemoveEveryObserver(CFNotificationCenterRef center, const void *observer);

#if __cplusplus
}
#endif

__attribute__((visibility("hidden"))) NSArray *hiddenDisplayIdentifiers() {
	return [[NSArray alloc] initWithObjects:
		                            @"com.apple.AdSheet",
		                            @"com.apple.AdSheetPhone",
		                            @"com.apple.AdSheetPad",
		                            @"com.apple.DataActivation",
		                            @"com.apple.DemoApp",
		                            @"com.apple.fieldtest",
		                            @"com.apple.iosdiagnostics",
		                            @"com.apple.iphoneos.iPodOut",
		                            @"com.apple.TrustMe",
		                            @"com.apple.WebSheet",
		                            @"com.apple.springboard",
                                    @"com.apple.purplebuddy",
                                    @"com.apple.datadetectors.DDActionsService",
                                    @"com.apple.FacebookAccountMigrationDialog",
                                    @"com.apple.iad.iAdOptOut",
                                    @"com.apple.ios.StoreKitUIService",
                                    @"com.apple.TextInput.kbd",
                                    @"com.apple.MailCompositionService",
                                    @"com.apple.mobilesms.compose",
                                    @"com.apple.quicklook.quicklookd",
                                    @"com.apple.ShoeboxUIService",
                                    @"com.apple.social.remoteui.SocialUIService",
                                    @"com.apple.WebViewService",
                                    @"com.apple.gamecenter.GameCenterUIService",
									@"com.apple.appleaccount.AACredentialRecoveryDialog",
									@"com.apple.CompassCalibrationViewService",
									@"com.apple.WebContentFilter.remoteUI.WebContentAnalysisUI",
									@"com.apple.PassbookUIService",
									@"com.apple.uikit.PrintStatus",
									@"com.apple.Copilot",
									@"com.apple.MusicUIService",
									@"com.apple.AccountAuthenticationDialog",
									@"com.apple.MobileReplayer",
									@"com.apple.SiriViewService",
									@"com.apple.mobilesms.notification",
									@"com.apple.InCallService",
									@"com.apple.PrintKit.Print-Center",
									@"com.apple.TencentWeiboAccountMigrationDialog",
									@"com.apple.CoreAuthUI",
									@"com.apple.Diagnostics",
									@"com.apple.PreBoard",
									@"com.apple.AskPermissionUI",
									@"com.apple.share",
									@"com.apple.SharedWebCredentialViewService",
									@"com.apple.HealthPrivacyService",		
		                            nil];
}

__attribute__((visibility("hidden"))) NSArray *disabledViewControllers() {
	return [[NSArray alloc] initWithObjects:
		                            @"SBControlCenterController",
									@"AVFullScreenPlaybackControlsViewController",		
		                            nil];
}

static void initializeAppHead(NSString *displayIdentifier, NSInteger pid) {
	if (![SRSettings sharedSettings].isTweakEnabled) {
		return;
	}

	if ([SRSettings sharedSettings].excludeMailApp && [displayIdentifier isEqualToString:@"com.apple.mobilemail"]) {
		return;
	}

	if ([hiddenDisplayIdentifiers() containsObject:displayIdentifier]) {
		return;
	}

	if ([SRSettings sharedSettings].enabledForAllApps || [[SRSettings sharedSettings].enabledApps containsObject:displayIdentifier]) {
		NSInteger displayMode = [SRSettings sharedSettings].displayMode;
		[[SRAppHeadsManager sharedManager] addAppHeadForPid:pid inMode:displayMode];
	}
}

%group SRSharedSBHooks

%hook SBUserAgent

-(BOOL)launchFromBulletinWithURL:(NSURL *)url bundleID:(NSString *)bundleID allowUnlock:(BOOL)arg3 animate:(BOOL)arg4 launchOrigin:(int)arg5 {
	[[SRAppHeadsManager sharedManager] suspendActiveDraggableView];
	return %orig;
}

%end

%hook SBBulletinBannerController

-(void)observer:(id)arg1 addBulletin:(BBBulletin *)bulletin forFeed:(unsigned long long)arg3 {
	[[SRAppHeadsManager sharedManager] pushDraggableViewToFrontWithIdentifier:bulletin.sectionID];
	%orig;
}

%end

%hook SBLockScreenViewController
-(void)finishUIUnlockFromSource:(int)arg1 {

	if (![SRSettings sharedSettings].isInHiddenMode) 
		[[SRAppHeadsManager sharedManager] showExistingAppHeads:SRAHVisibilitySourceSpringBoard];

	static dispatch_once_t p = 0;
	dispatch_once(&p,^{
		if ([SRSettings sharedSettings].displayMode != SRAppHeadsDisplayModeFree) {
			[[SRAppHeadsManager sharedManager].mainViewController addMenuButton];
		}
	});

	%orig;
}

%end
%end

%group SRSBHooks8
%hook SBApplication

-(void)didExitWithType:(int)arg1 terminationReason:(int)arg2 {
	[[SRAppHeadsManager sharedManager] removeAppHeadForDisplayIdentifier:[self bundleIdentifier]];
	%orig;
}


-(void)processDidLaunch:(id)arg1 {
	initializeAppHead([self bundleIdentifier],self.pid);
	%orig;
}

%new //fixes not for public release
-(id)displayIdentifier {
	return [self bundleIdentifier];
}

%end

%hook SBAppSwitcherController
-(void)animatePresentationFromDisplayLayout:(id)arg1 withViews:(id)arg2 withCompletion:(/*^block*/ id)arg3 {
	[[SRAppHeadsManager sharedManager] suspendActiveDraggableView];
	%orig;
}
%end

static NSArray *removeRecentlyKilledAppsiOS8(NSArray *array) {
	NSMutableArray *identifiers = [array mutableCopy];
	if (array != nil && [array count] > 0) {
		SBApplicationController *appController = [%c(SBApplicationController) sharedInstance];
		for (SBDisplayLayout *displayLayout in array) {
			SBDisplayItem *displayItem = [displayLayout.displayItems firstObject];
			SBApplication *app = [appController applicationWithDisplayIdentifier:displayItem.displayIdentifier];
			if (app && ![app isRunning]) {
				[identifiers removeObject:displayLayout];
			}
		}
		return (NSArray *)[identifiers copy];
	} else {
		return nil;
	}
}

%hook SBAppSwitcherModel
- (NSArray *)snapshot {
	id appList = %orig;
   return [SRSettings sharedSettings].suppressKilledApps ? removeRecentlyKilledAppsiOS8(appList) : appList;
}
%end
%end

%group SRSBHooks7
%hook SBApplication

-(void)didExitWithInfo:(id)info type:(int)type {
	[[SRAppHeadsManager sharedManager] removeAppHeadForDisplayIdentifier:self.displayIdentifier];
	%orig;
}

-(void)didLaunch:(BKSApplicationProcessInfo *)processInfo {
	initializeAppHead(self.displayIdentifier,self.pid);
	%orig;
}
%end

%hook SBAppSliderController
-(void)animatePresentationFromDisplayIdentifier:(id)arg1 withViews:(id)arg2 fromSide:(int)arg3 withCompletion:(/*^block*/ id)arg4 {
	[[SRAppHeadsManager sharedManager] suspendActiveDraggableView];
	%orig;
}
%end

static NSArray *removeRecentlyKilledAppsiOS7(NSArray *array) {
	NSMutableArray *identifiers = [array mutableCopy];
	if (array != nil && [array count] > 0) {
		SBApplicationController *appController = [%c(SBApplicationController) sharedInstance];
		for (NSString *bundleID in array) {
			SBApplication *app = [appController applicationWithDisplayIdentifier:bundleID];
			if (app && ![app isRunning]) {
				[identifiers removeObject:bundleID];
			}
		}
		return (NSArray *)[identifiers copy];
	} else {
		return nil;
	}
}

%hook SBAppSwitcherModel
- (NSArray *)snapshot {
	id appList = %orig;
    return [SRSettings sharedSettings].suppressKilledApps ? removeRecentlyKilledAppsiOS7(appList) : appList;
}
%end
%end

%group AVPlayerLayer7Hooks
%hook AVPlayerLayer

-(void)_connectContentLayerToPlayer {
	if ([SRSettings sharedSettings].hideDuringVideos && ![SRSettings sharedSettings].isInHiddenMode) {
		[[SRNotificationCenter defaultCenter] postHideAllAppHeadsFromSource:SRAHVisibilitySourceSpringBoard];
	} 

	%orig;
}

-(void)_disconnectContentLayerFromPlayer {
	if ([SRSettings sharedSettings].hideDuringVideos && ![SRSettings sharedSettings].isInHiddenMode) {
		[[SRNotificationCenter defaultCenter] postShowAllAppHeadsFromSource:SRAHVisibilitySourceSpringBoard];
	} 

	%orig;
}

%end
%end

%group AVPlayerLayer8Hooks
%hook AVPlayerLayer

-(void)setPlayer:(id)p {

	if ([SRSettings sharedSettings].hideDuringVideos && ![SRSettings sharedSettings].isInHiddenMode) {
		if (p == nil) {
			[[SRNotificationCenter defaultCenter] postShowAllAppHeadsFromSource:SRAHVisibilitySourceSpringBoard];
		} else {
			[[SRNotificationCenter defaultCenter] postHideAllAppHeadsFromSource:SRAHVisibilitySourceSpringBoard];
		}
	}

	%orig;
}

%end
%end

%group UIKitHooks
%hook UIViewController

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    %orig;
    if (![disabledViewControllers() containsObject:NSStringFromClass(self.class)]) {
    	notify_set_state(willrotate,toInterfaceOrientation);
		notify_post("com.sharedroutine.appheads.willrotate");
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	%orig;
	if (![disabledViewControllers() containsObject:NSStringFromClass(self.class)]) {
		notify_set_state(didrotate,fromInterfaceOrientation);
		notify_post("com.sharedroutine.appheads.didrotate");
	}
}

%end
%hook UIApplication

-(id)init {

	self = %orig;

	if (self) {
		[self listenForNotifications];
	}

	return self;
}

%new

-(void)listenForNotifications {
		void (^updateStatusbarAndContexts)(BOOL hidden, BOOL keep, NSInteger processID) = ^(BOOL hidden, BOOL keep, NSInteger processID) {
			NSInteger currentPid = [[NSProcessInfo processInfo] processIdentifier];
			if (currentPid == processID) {
				[self setStatusBarHidden:hidden];
			}
		};

		[SRNotificationObserver observeWithActivationBlock:^(NSInteger processID) {
			updateStatusbarAndContexts(YES,YES,processID);
		} deactivationBlock:^(NSInteger processID) {
			updateStatusbarAndContexts(NO,NO,processID);
		} terminationBlock:^(NSInteger pid) {
			NSInteger currentPid = [[NSProcessInfo processInfo] processIdentifier];
			if (currentPid == pid) {
				[self _saveApplicationPreservationStateIfSupported];
				[self terminateWithSuccess];
			}
		}];

		static int orientationToken = 0;
		notify_register_dispatch("com.sharedroutine.appheads.willrotate", &orientationToken, dispatch_get_main_queue(), ^(int token) {
			uint64_t orientation = -1;
			notify_get_state(token,&orientation);
			[[UIDevice currentDevice] setOrientation:orientation];
        });

}

-(BOOL)openURL:(NSURL *)url {
	notify_post("com.sharedroutine.appheads.suspendactivedraggableview");
	return %orig;
}

%end
%end

void sr_initializebackboardd7() {

	void (^activateAppWithPid)(NSInteger pid) = ^(NSInteger pid) {
		BKApplication *app = [[%c(BKWorkspaceServerManager) sharedInstance] applicationForPID:pid];
		if (app) {
			[app _addActivationAssertionNamed:@"com.sharedroutine.appheads"];
		}
	};

	void (^deactivateAppWithPid)(NSInteger pid) = ^(NSInteger pid) {
		BKApplication *app = [[%c(BKWorkspaceServerManager) sharedInstance] applicationForPID:pid];
		if (app) {
			[app _removeActivationAssertionNamed:@"com.sharedroutine.appheads"];
		}
	};

	[SRNotificationObserver observeWithActivationBlock:activateAppWithPid deactivationBlock:deactivateAppWithPid terminationBlock:nil];

	static int killallToken = 0;
		notify_register_dispatch("com.sharedroutine.appheads.killall", &killallToken, dispatch_get_main_queue(), ^(int token) {
				if ([SRSettings sharedSettings].killallWhiteList.count == 0) {
                    [objc_getClass("BKProcess") deleteAllJobs];
                } else {
                    NSArray *allJobs = [objc_getClass("BKLaunchdUtilities") allJobLabels];
                    NSArray *appJobs = [allJobs filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH %@",@"UIKitApplication:"]];
                    for (NSString *label in appJobs) {
                        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@":(\\w*[.])*\\w*" options:NSRegularExpressionCaseInsensitive error:NULL];
                        NSTextCheckingResult *result = [expression firstMatchInString:label options:0 range:NSMakeRange(0, [label length])];
                        NSString *bundleID = [[label substringWithRange:result.range] stringByReplacingOccurrencesOfString:@":" withString:@""];
                        if (![[SRSettings sharedSettings].killallWhiteList containsObject:bundleID]) {
                            [objc_getClass("BKLaunchdUtilities") deleteJobWithLabel:label];
                        }
                    }
                }
    	});
}

static void lockedDevice(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	[[SRAppHeadsManager sharedManager] suspendActiveDraggableView];
	if (![SRSettings sharedSettings].allowInLockscreen) {
		[[SRAppHeadsManager sharedManager] hideExistingAppHeads:SRAHVisibilitySourceSpringBoard];
	} 
}

static void callStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {

	NSNumber *callStatus = (__bridge NSNumber *)CFDictionaryGetValue(userInfo,CFSTR("kCTCallStatus"));

	if ([callStatus integerValue] == kCTCallStatusIncomingCall) {
		[[SRAppHeadsManager sharedManager] suspendActiveDraggableView];
	}
}

void sr_initializeAssertionD() {

	[SRNotificationObserver observeWithActivationBlock:nil deactivationBlock:nil terminationBlock:^(NSInteger processID) {
		BKNewProcess *process = [[%c(BKProcessInfoServer) sharedInstance] processForPID:processID];
		if (process) {
			NSSet *assertions = [process assertions];
			if (assertions) {
				for (BKProcessAssertion *assertion in [assertions allObjects]) {
					[process removeAssertion:assertion];
				}
			}
		}
	}];
}

void sr_initializeSpringBoard8() {
	[SRNotificationObserver observeWithActivationBlock:nil deactivationBlock:nil terminationBlock:^(NSInteger processID) {
		SBApplication *app = [[%c(SBApplicationController) sharedInstance] applicationWithPid:processID];
		FBApplicationProcess *process = [app valueForKey:@"_process"];
		if (process) {
			[process stop];
		}
	}];
}

%ctor {
	
	NSString *bundleID = [NSBundle mainBundle].bundleIdentifier;
	NSString *processName = [[NSProcessInfo processInfo] processName];
	NSRange widgetRange = [processName rangeOfString:@"widget" options:NSCaseInsensitiveSearch];
	if (widgetRange.location != NSNotFound) {
		return;
	}

	NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
	widgetRange = [bundlePath rangeOfString:@"plugins" options:NSCaseInsensitiveSearch];
	if ([bundlePath hasSuffix:@"appex"] || widgetRange.location != NSNotFound) {
		return;
	}

	if ([bundleID isEqualToString:@"com.apple.WebKit.WebContent"]) {
		return;
	}

	if (![SRSettings sharedSettings].isTweakEnabled) return;
	
	if ([bundleID isEqualToString:@"com.apple.springboard"]) {

		%init(SRSharedSBHooks);
		if (iOS8) {
			%init(SRSBHooks8);
			sr_initializeSpringBoard8();
		} else if (iOS7) {
			%init(SRSBHooks7);
		}
		CTTelephonyCenterAddObserver(CTTelephonyCenterGetDefault(), NULL, callStatusChanged, kCTCallStatusChangeNotification, NULL, CFNotificationSuspensionBehaviorCoalesce);
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, lockedDevice, CFSTR("com.apple.springboard.lockcomplete"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	} else if ([bundleID isEqualToString:@"com.apple.backboardd"]) {
		 if (iOS7) {
			sr_initializebackboardd7();
		}
	} else if ([processName isEqualToString:@"assertiond"]) {
		if (iOS8) {
			sr_initializeAssertionD();
		}
	}

	if (![bundleID isEqualToString:@"com.apple.accessibility.AccessibilityUIServer"]) {
		notify_register_check("com.sharedroutine.appheads.willrotate",&willrotate);
		notify_register_check("com.sharedroutine.appheads.didrotate",&didrotate);
		%init(UIKitHooks);
	}
	
	if (iOS8) {
		%init(AVPlayerLayer8Hooks);
	} else if (iOS7) {
		%init(AVPlayerLayer7Hooks);
	}
}