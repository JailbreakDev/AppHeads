#import "SRAppHeadsManager.h"

@interface SRAppHeadsManager () <LAListener>
@property (nonatomic,strong) NSMutableDictionary *appHeads;
@property (nonatomic,strong) NSMutableDictionary *assertions;
-(BOOL)hasAppHeadForDisplayIdentifier:(NSString *)displayIdentifier;
@end

@implementation SRAppHeadsManager
@synthesize appHeads = _appHeads;
@synthesize mainWindow = _mainWindow;
@synthesize mainViewController = _mainViewController;
@synthesize assertions = _assertions;
@dynamic numberOfAppHeads;

+(instancetype)sharedManager {
    static dispatch_once_t p = 0;

    __strong static id _sharedSelf = nil;

    dispatch_once(&p, ^{
        _sharedSelf = [[self alloc] init];
    });

    return _sharedSelf;
}

-(SRAppHeadsViewController *)mainViewController {
	_mainViewController = (SRAppHeadsViewController *)[_mainWindow rootViewController];
	return _mainViewController;
}

-(id)init {

	self = [super init];	

	if (self) {

		_assertions = [[NSMutableDictionary alloc] init];
		_appHeads = [[NSMutableDictionary alloc] init];

		if ([[objc_getClass("LAActivator") sharedInstance] isRunningInsideSpringBoard]) {
			[[objc_getClass("LAActivator") sharedInstance] registerListener:self forName:@"com.sharedroutine.appheads.homebutton"];
		}
		
		_mainWindow = [[SRAppHeadsWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		[_mainWindow setWindowLevel:1053.0f];
		[_mainWindow makeKeyAndVisible];

		[self registerForNotifications];

		if ([objc_getClass("SBReachabilityManager") reachabilitySupported]) {
			[[objc_getClass("SBReachabilityManager") sharedInstance] addObserver:self.mainViewController];
		}	
	}

	return self;
}

-(void)registerForNotifications {
	static int removeToken = 0;
	notify_register_dispatch("com.sharedroutine.appheads.removemail", &removeToken, dispatch_get_main_queue(), ^(int token) {
		NSInteger pid = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithDisplayIdentifier:@"com.apple.mobilemail"].pid;
		[self removeAppHeadForPid:pid];
	});

	static int addToken = 0;
	notify_register_dispatch("com.sharedroutine.appheads.addmail", &addToken, dispatch_get_main_queue(), ^(int token) {
		NSInteger pid = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithDisplayIdentifier:@"com.apple.mobilemail"].pid;
		[self addAppHeadForPid:pid inMode:[SRSettings sharedSettings].displayMode];
	});

	static int snappingToken = 0;
		notify_register_dispatch("com.sharedroutine.appheads.snappingedge", &snappingToken, dispatch_get_main_queue(), ^(int token) {
		uint64_t snappingedge = -1;
		notify_get_state(token,&snappingedge);
		[self snappingEdgeChanged:snappingedge];
	});

	static int hideToken = 0;
	notify_register_dispatch("com.sharedroutine.appheads.hideAll", &hideToken, dispatch_get_main_queue(), ^(int token) {
		uint64_t source = -1;
		notify_get_state(token,&source);
		[self hideExistingAppHeads:source];
	});

	static int showToken = 0;
	notify_register_dispatch("com.sharedroutine.appheads.showAll", &showToken, dispatch_get_main_queue(), ^(int token) {
		uint64_t source = -1;
		notify_get_state(token,&source);
		[self showExistingAppHeads:source];
	});

	//handle touch id confirmation outside of SpringBoard
	int replyToken = 0;
	notify_register_check("com.sharedroutine.appheads.touchid-reply",&replyToken);

	static int touchIDToken = 0;
	notify_register_dispatch("com.sharedroutine.appheads.touchid-confirmation", &touchIDToken, dispatch_get_main_queue(), ^(int token) {
        [[SRTouchIDController sharedController] startMonitoringWithResultBlock:^(SRTouchIDController *controller,SRTouchIDEvent event){
            if (event == SRTouchIDEventMatched) {
                notify_set_state(replyToken,(uint64_t)1);
                notify_post("com.sharedroutine.appheads.touchid-reply");
                [controller stopMonitoring];
            } else if (event == SRTouchIDEventCancelled) {
            	notify_set_state(replyToken,(uint64_t)0);
                notify_post("com.sharedroutine.appheads.touchid-reply");
                [controller stopMonitoring];
            }
        }];
	});

	static int headSizeToken = 0;
	notify_register_dispatch("com.sharedroutine.appheads.headsize-changed", &headSizeToken, dispatch_get_main_queue(), ^(int token) {
		[self updateHeadSizeForExistingAppHeads];
	});

	static int doubleTapToken = 0;
    notify_register_dispatch("com.sharedroutine.appheads.doubletapinterval-changed", &doubleTapToken, dispatch_get_main_queue(), ^(int token) {
        [self updateDoubleTapIntervalForExistingAppHeads];
    });
    
    void (^disableHostingForPid)(NSInteger pid) = ^(NSInteger pid) {
            SBApplication *app = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithPid:pid];
			if (app) {
				if (iOS8) {
                    [[app mainScene].contextHostManager disableHostingForRequester:@"appheads"];
                } else if (iOS7) {
                    [[app mainScreenContextHostManager] disableHostingForRequester:@"appheads"];
                }
			}
        };

    void (^enableHostingForPid)(NSInteger pid) = ^(NSInteger pid) {
       	SBApplication *app = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithPid:pid];
		if (app) {
			dispatch_async(dispatch_get_main_queue(),^{
				if (iOS8) {
                	[[app mainScene].contextHostManager enableHostingForRequester:@"appheads" orderFront:YES];
            	} else if (iOS7) {
              		[[app mainScreenContextHostManager] enableHostingForRequester:@"appheads" orderFront:YES];
            	}
			});
		}
    };

    [SRNotificationObserver observeWithActivationBlock:enableHostingForPid deactivationBlock:disableHostingForPid terminationBlock:disableHostingForPid];

    static int suspendActiveToken = 0;
	notify_register_dispatch("com.sharedroutine.appheads.suspendactivedraggableview", &suspendActiveToken, dispatch_get_main_queue(), ^(int token) {
		[self suspendActiveDraggableView];
    });
}

-(NSInteger)numberOfAppHeads {
	return [_appHeads allKeys].count;
}

-(CHDraggableView *)draggableViewForIdentifier:(NSString *)displayIdentifier {
	return [_appHeads objectForKey:displayIdentifier];
}

-(BOOL)hasAppHeadForDisplayIdentifier:(NSString *)displayIdentifier {
	return [[_appHeads allKeys] containsObject:displayIdentifier];
}

-(void)updateHeadSizeForExistingAppHeads {
	if ([SRSettings sharedSettings].displayMode == SRAppHeadsDisplayModeFree) {
		CGFloat size = [SRSettings sharedSettings].headSize;
		for (UIView *view in self.mainViewController.view.subviews) {
			if ([view isKindOfClass:[CHDraggableView class]]) {
				[((CHDraggableView *)view) updateToSize:CGSizeMake(size,size)];
			}
		}
	}
}

-(void)updateDoubleTapIntervalForExistingAppHeads {
	for (CHDraggableView *view in _appHeads.allValues) {
		[view.doubleTapGesture setMaximumIntervalBetweenSuccessiveTaps:[[SRSettings sharedSettings] doubleTapInterval]];
	}
}

-(void)hideExistingAppHeads:(SRAHVisibilitySource)source {
	if (source == SRAHVisibilitySourceActivator || source == SRAHVisibilitySourceFlipswitch) {
		[[SRSettings sharedSettings] setIsInHiddenMode:TRUE];
	}
	[self.mainViewController showAllAppHeads:FALSE];
}

-(void)showExistingAppHeads:(SRAHVisibilitySource)source {
	if (source == SRAHVisibilitySourceActivator || source == SRAHVisibilitySourceFlipswitch) {
		[[SRSettings sharedSettings] setIsInHiddenMode:FALSE];
	}
	[self.mainViewController showAllAppHeads:TRUE];
}

-(void)snappingEdgeChanged:(CHSnappingEdge)edge {
	if (!self.mainViewController) return;

	for (CHDraggableView *view in _appHeads.allValues) {
		[self.mainViewController draggableViewNeedsAlignment:view];
	}
}

-(void)removeAppHeadForPid:(NSInteger)pid {
	SBApplication *app = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithPid:pid];
	if (app) {
		[self removeAppHeadForDisplayIdentifier:app.displayIdentifier];
	}
}

-(void)pushDraggableViewToFrontWithIdentifier:(NSString *)identifier {
	if ([self hasAppHeadForDisplayIdentifier:identifier]) {
		CHDraggableView *draggableView = [self draggableViewForIdentifier:identifier];
		[draggableView updateAlpha];
		[self.mainViewController.view bringSubviewToFront:draggableView];
	}
}

-(void)removeAppHeadForDisplayIdentifier:(NSString *)displayIdentifier {
	if (displayIdentifier != nil && [self hasAppHeadForDisplayIdentifier:displayIdentifier]) {
		CHDraggableView *view = [self draggableViewForIdentifier:displayIdentifier];
		dispatch_async(dispatch_get_main_queue(),^{
			[self.mainViewController removeDraggableView:view];
		});
		[_appHeads removeObjectForKey:displayIdentifier];
	}
}

- (void)showLiveViewForBundleID:(NSString *)bundleID {
	if ([self hasAppHeadForDisplayIdentifier:bundleID]) {
		[_mainViewController showLiveViewForDraggableView:[self draggableViewForIdentifier:bundleID]];
	} else {
		[self activateApplication:bundleID inBackground:YES withCompletionBlock:^{
			[_mainViewController showLiveViewForDraggableView:[self draggableViewForIdentifier:bundleID]];
		}];
	}
}

-(void)addAppHeadForPid:(NSInteger)pid inMode:(SRAppHeadsDisplayMode)mode {

	if ([SRSettings sharedSettings].limitAppHeads && self.numberOfAppHeads >= [SRSettings sharedSettings].allowedAppHeadsCount) {
		return;
	}

	SBApplication *app = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithPid:pid];
	NSString *displayIdentifier = app.displayIdentifier;
	if (![self hasAppHeadForDisplayIdentifier:displayIdentifier] && displayIdentifier != nil) {
		SBApplicationIcon *appIcon = [[objc_getClass("SBApplicationIcon") alloc] initWithApplication:app];
		UIImage *icon = [appIcon generateIconImage:1];
		CGFloat headSizeValue = [SRSettings sharedSettings].headSize;
		CGSize headSize = CGSizeMake(headSizeValue,headSizeValue);
		CHDraggableView *draggableView = [[CHDraggableView alloc] initWithImage:icon size:headSize application:app];
		[draggableView setHidden:[SRSettings sharedSettings].isInHiddenMode];
		[draggableView setDelegate:self.mainViewController];

		if (mode == SRAppHeadsDisplayModeFree) {
			[draggableView setIsDraggable:TRUE];
		}
		
		[self.mainViewController addDraggableView:draggableView];
		[self.mainViewController draggableViewNeedsAlignment:draggableView];
		[_appHeads setObject:draggableView forKey:displayIdentifier];
	}
}

-(BOOL)suspendActiveDraggableView {
   return [self.mainViewController suspendActiveDraggableViewWithCompletion:nil];
}

#pragma mark - LAListener Delegate

- (void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event {
	event.handled = [self suspendActiveDraggableView];
}

-(void)closeApplication:(SBApplication *)aApplication {
	if ([[objc_getClass("SBUIController") sharedInstance] isAppSwitcherShowing]) {
            if (iOS8) {
                SBAppSwitcherController *appSwitcher = [[objc_getClass("SBUIController") sharedInstance] _appSwitcherController];
                if (appSwitcher) {
                	SBDisplayItem *displayItem = [[objc_getClass("SBDisplayItem") alloc] initWithType:@"App" displayIdentifier:aApplication.displayIdentifier];
                	if (displayItem) {
                		@try {
                			[appSwitcher _quitAppWithDisplayItem:displayItem];
                		} @catch (NSException *e) {

                		} @finally {
                			[self removeAppHeadForDisplayIdentifier:aApplication.displayIdentifier];
                		}
                	}
                }
            } else if (iOS7) {
                SBAppSliderController *sliderController = [[objc_getClass("SBUIController") sharedInstance] _appSliderController];
               	if (sliderController) {
               		 NSInteger index = [sliderController.applicationList indexOfObject:aApplication.displayIdentifier];
	                if (index != NSNotFound) {
	                    @try {
	                    	[sliderController _quitAppAtIndex:index];
	                    } @catch (NSException *e) {

	                    } @finally {
	                    	[self removeAppHeadForDisplayIdentifier:aApplication.displayIdentifier];
	                    }
	                }
               	}
            }
    } else {
      	[[SRNotificationCenter defaultCenter] postCloseAppWithPid:aApplication.pid];
       	[self removeAppHeadForDisplayIdentifier:aApplication.displayIdentifier];
       	if (iOS8) {
       		SBDisplayItem *displayItem = [[objc_getClass("SBDisplayItem") alloc] initWithType:@"App" displayIdentifier:aApplication.displayIdentifier];
	       	@try {
	       		[[objc_getClass("SBAppSwitcherModel") sharedInstance] removeDisplayItem:displayItem];
	       	} @catch (NSException *e) {
	       		NSLog(@"[SRAppHeadsManager] caught exception: %@",e);
	       	}
       	}
   	}
}

-(void)activateApplication:(NSString *)app inBackground:(BOOL)background withCompletionBlock:(void(^)())completionBlock {
	unsigned int clientPort = [[objc_getClass("FBSSystemService") sharedService] createClientPort];
	[[objc_getClass("FBSSystemService") sharedService] openApplication:app options:@{@"__ActivateSuspended" : @(background)} clientPort:clientPort withResult:completionBlock];
}

-(void)openApplication:(SBApplication *)aApplication {
	if (iOS8) {
		unsigned int clientPort = [[objc_getClass("FBSSystemService") sharedService] createClientPort];
		[self.mainViewController suspendActiveDraggableViewWithCompletion:^{
			[[objc_getClass("FBSSystemService") sharedService] openApplication:[aApplication bundleIdentifier] options:nil clientPort:clientPort withResult:nil];
		}];
	} else {
		[self.mainViewController suspendActiveDraggableViewWithCompletion:^{
			[[objc_getClass("SBUIController") sharedInstance] activateApplicationAnimated:aApplication];
		}];
	}
}

-(void)killAllApplications {
	if ([SRSettings sharedSettings].killallWhiteList.count == 0) {
        [objc_getClass("BSLaunchdUtilities") deleteAllJobsWithLabelPrefix:@"UIKitApplication:"];
    } else {
        NSArray *allJobs = [objc_getClass("BSLaunchdUtilities") allJobLabels];
        NSArray *appJobs = [allJobs filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH %@",@"UIKitApplication:"]];
        for (NSString *label in appJobs) {
            NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@":(\\w*[.])*\\w*" options:NSRegularExpressionCaseInsensitive error:NULL];
            NSTextCheckingResult *result = [expression firstMatchInString:label options:0 range:NSMakeRange(0, [label length])];
            NSString *bundleID = [[label substringWithRange:result.range] stringByReplacingOccurrencesOfString:@":" withString:@""];
            if (![[SRSettings sharedSettings].killallWhiteList containsObject:bundleID]) {
                [objc_getClass("BSLaunchdUtilities") deleteJobWithLabel:label];
            }
        }
    }
}

-(void)addAssertionToApp:(SBApplication *)app {
	[self removeAssertionFromApp:app];
	BKSProcessAssertion *assertion = [[objc_getClass("BKSProcessAssertion") alloc] initWithPID:app.pid flags:0x7 reason:10000 name:app.displayIdentifier withHandler:nil];
	[_assertions setObject:assertion forKey:app.displayIdentifier];
}

-(void)removeAssertionFromApp:(SBApplication *)app {
	BKSProcessAssertion *assertion = nil;
	if ((assertion = [_assertions objectForKey:app.displayIdentifier])) {
		[assertion invalidate];
		[_assertions removeObjectForKey:app.displayIdentifier];
		assertion = nil;
	}
}

@end