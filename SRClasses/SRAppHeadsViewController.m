#import "SRAppHeadsViewController.h"

@implementation SRAppHeadsView
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *superView = [super hitTest:point withEvent:event];
    if (![superView isKindOfClass:[SRAppHeadsView class]]) {
        return superView;
    }
    return nil;
}
@end

@interface SRAppHeadsViewController ()
@property (nonatomic, strong) SRTouchIDAlertItem *confirmationAlert;
@property (nonatomic, strong) SRConversationView *presentingView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSMutableDictionary *edgePointDictionary;
@property (nonatomic, strong) SRAppHeadCollectionView *collectionView;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic) BOOL showsMenu;
@property (nonatomic) UIInterfaceOrientation lastOrientation;
@end

@implementation SRAppHeadsViewController
@synthesize closeView = _closeView;
@synthesize activeDraggableView = _activeDraggableView;
@synthesize presentingView = _presentingView;
@synthesize backgroundView = _backgroundView;
@synthesize edgePointDictionary = _edgePointDictionary;
@synthesize collectionView = _collectionView;
@synthesize menuButton = _menuButton;
@synthesize showsMenu = _showsMenu;
@synthesize lastOrientation = _lastOrientation;
@dynamic view;

#pragma mark - Rotation

-(BOOL)shouldAutorotate {
	return ![SRSettings sharedSettings].isInHostingMode;
}

- (NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return ![SRSettings sharedSettings].isInHostingMode;
}

- (void)loadView {
	self.view = [[SRAppHeadsView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

-(void)viewDidLoad {
	[super viewDidLoad];

	static int orientationToken = 0;
	notify_register_dispatch("com.sharedroutine.appheads.willrotate", &orientationToken, dispatch_get_main_queue(), ^(int token) {
		uint64_t orientation = -1;
		notify_get_state(token,&orientation);
		self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    });

    static int didRotateToken = 0;
	notify_register_dispatch("com.sharedroutine.appheads.didrotate", &didRotateToken, dispatch_get_main_queue(), ^(int token) {
		uint64_t orientation = -1;
		notify_get_state(token,&orientation);
		if ([self shouldAutorotate]) {
			[self sr_didRotateFromInterfaceOrientation:orientation];
		}
    });

	if ([SRSettings sharedSettings].displayMode == SRAppHeadsDisplayModeFree) {
		_closeView = [[SRCloseAppHeadView alloc] init];
		[_closeView setHidden:YES];
		[_closeView setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.view insertSubview:_closeView atIndex:0];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_closeView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
       	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_closeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_closeView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
       	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_closeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:100]];
	} else {
        _collectionView = [[SRAppHeadCollectionView alloc] initWithDefaultSettings];
        CGFloat headSize = [SRSettings sharedSettings].headSize;
        [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addSubview:_collectionView];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:headSize + 5]];
    }
}

-(void)sr_didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (_lastOrientation != fromInterfaceOrientation) {
        CGRect bounds = self.view.bounds;
        for (UIView *s in self.view.subviews) {
            if ([s isKindOfClass:[CHDraggableView class]]) {
                if (((CHDraggableView *)s).isActiveDraggableView) {
                    [self animateViewToConversationArea:(CHDraggableView *)s];
                    continue;
                } 
                CGFloat factor = bounds.size.height / bounds.size.width;
                CGFloat newY = s.center.y * factor;
                [((CHDraggableView *)s) snapViewCenterToPoint:[self destinationPointForReleasePoint:CGPointMake(s.center.x,newY)]];
            }
        }
        _lastOrientation = fromInterfaceOrientation;
    }
}

#pragma mark - Reachability

-(void)handleReachabilityModeDeactivated {
    return;

    if (_activeDraggableView) {
        [_activeDraggableView setTransform:CGAffineTransformMakeTranslation(0,0)];
    }
    if (_presentingView) {
        [_presentingView setTransform:CGAffineTransformMakeTranslation(0,0)];
    }
}

-(void)handleReachabilityModeActivated {
    return;

    if (_activeDraggableView) {
        [_activeDraggableView setTransform:CGAffineTransformMakeTranslation(0,90)];
    }
    if (_presentingView) {
        [_presentingView setTransform:CGAffineTransformMakeTranslation(0,90)];
    }
}

#pragma mark - Hiding and Showing

-(void)showAllAppHeads:(BOOL)show {
    if ([SRSettings sharedSettings].displayMode == SRAppHeadsDisplayModeFree) {
        for (UIView *s in self.view.subviews) {
            if ([s isKindOfClass:[CHDraggableView class]]) {
                [s setHidden:!show];
            }
        }
    } else {
        [_collectionView setHidden:!show];
    }
}

#pragma mark EdgePoints

-(NSMutableDictionary *)edgePointDictionary {
	_edgePointDictionary = [SRSettings sharedSettings].edgePoints;
	return _edgePointDictionary;
}

-(void)setEdgePointDictionary:(NSMutableDictionary *)newDictionary {
	_edgePointDictionary = newDictionary;
	[[SRSettings sharedSettings] setEdgePoints:_edgePointDictionary];
}

#pragma mark - Bouncing

-(void)addBounceAnimationToView:(UIView *)aView withFromValue:(CGFloat)aFrom andToValue:(CGFloat)aTo {
    SKBounceAnimation *animation = [SKBounceAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(aFrom, aFrom, 1)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(aTo, aTo, 1)];
    animation.duration = 0.2f;
    aView.layer.transform = [animation.toValue CATransform3DValue];
    [aView.layer addAnimation:animation forKey:nil];
}

#pragma mark - Geometry

-(CGPoint)destinationPointForReleasePoint:(CGPoint)releasePoint {
	CHSnappingEdge allowedEdge = [SRSettings sharedSettings].snappingEdge;
	CGFloat releasePointX,releasePointY;
    CGFloat headSize = [SRSettings sharedSettings].headSize;
	CGFloat maxX = (CGRectGetWidth(self.view.bounds) - (headSize / 2));
	CGFloat minX = (headSize / 2);
    CGFloat maxY = (CGRectGetMaxY(self.view.bounds) - (headSize / 2));

	if (allowedEdge == CHSnappingEdgeRight) {
		releasePointX = maxX;
	} else if (allowedEdge == CHSnappingEdgeLeft) {
		releasePointX = minX;
	} else { //both
		releasePointX = releasePoint.x > CGRectGetMidX(self.view.bounds) ? maxX : minX;
	}

    if (releasePoint.y >= UIScreen.mainScreen.bounds.size.height) {
        releasePointY = maxY;
    } else {
        releasePointY = (releasePoint.y < headSize) ? (releasePoint.y + arc4random_uniform(maxY)) : releasePoint.y;
    }
    
	return CGPointMake(releasePointX,releasePointY);
}

-(void)addMenuButton {
	if ([SRSettings sharedSettings].displayMode == SRAppHeadsDisplayModeLocked) {
		UIImage *iconImage = [UIImage imageWithContentsOfFile:@"/Library/Application Support/AppHeads/menuicon.png"];
		_menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_menuButton setImage:iconImage forState:UIControlStateNormal];
		[_menuButton addTarget:self action:@selector(tappedMenuButton:) forControlEvents:UIControlEventTouchUpInside];
	    [self.view addSubview:_menuButton];
	    [_menuButton setTranslatesAutoresizingMaskIntoConstraints:NO];
	    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_menuButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_menuButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_collectionView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_menuButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:30]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_menuButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:30]];
	}
}

-(void)tappedMenuButton:(UIButton *)view {
	CGFloat headSize = [SRSettings sharedSettings].headSize;
	if (!_showsMenu) {
		[UIView animateWithDuration:0.4 animations:^{
	        view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -(headSize + 5), 0);
	        _collectionView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -(headSize + 5), 0);
	    }];
    	_showsMenu = TRUE;
	} else {
		[UIView animateWithDuration:0.4 animations:^{
		    view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
		    _collectionView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
		}];
	    _showsMenu = FALSE;
	}
}

#pragma mark - CHDraggableViewDelegate

- (void)draggableViewDidBeginDragging:(CHDraggableView *)view {
	[UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_closeView setHidden:NO];
    } completion:nil];
}

- (void)draggableView:(CHDraggableView *)aView didMoveToPoint:(CGPoint)point {

    static dispatch_once_t show = 0;
    static dispatch_once_t hide = 0;

    if (CGRectContainsPoint(_closeView.dropRect,aView.center)) {
        dispatch_once(&show, ^{
           [self addBounceAnimationToView:_closeView.crossImageView withFromValue:1.0 andToValue:1.2];
           hide = 0;
        });
    } else {
       dispatch_once(&hide, ^{
        	[self addBounceAnimationToView:_closeView.crossImageView withFromValue:1.2 andToValue:1.0];
        	show = 0;
       });
    }
}

- (void)draggableViewReleased:(CHDraggableView *)aView {

	[self hideCloseView];

    if (CGRectContainsPoint(_closeView.dropRect,aView.center)) {
        [[SRAppHeadsManager sharedManager] closeApplication:aView.application];
        return;
    }

	if (_activeDraggableView && aView.isActiveDraggableView) {
        [self animateViewToConversationArea:aView];
        return;
    }
    
    if (aView.state == CHInteractionStateNormal) {
        [self animateViewToEdges:aView];
    } else if (aView.state == CHInteractionStateConversation) {
        [self animateViewToConversationArea:aView];
    }
}

-(void)doAction:(NSInteger)action forDraggableView:(CHDraggableView *)aView {
    switch (action) {
        case 1: //live view
            [self showLiveViewForDraggableView:aView];
        break;

        case 2: //open app
            [[SRAppHeadsManager sharedManager] openApplication:aView.application];
        break;

        case 3: //close application
            [[SRAppHeadsManager sharedManager] closeApplication:aView.application];
        break;

        case 4: { //close all apps
            if (iOS8) {
                [[SRAppHeadsManager sharedManager] killAllApplications];
            } else {
                notify_post("com.sharedroutine.appheads.killall");
            }
        } 
        break;

        case 5: { //lock apphead
            if ([SRSettings sharedSettings].displayMode == SRAppHeadsDisplayModeFree) {
                BOOL draggable = aView.isDraggable;
                [aView setIsDraggable:!draggable];  
            }
        } break;

        default:
        break;
    }
}

- (void)draggableViewHold:(CHDraggableView *)aView { 
    NSInteger action = [SRSettings sharedSettings].holdAction;
    [self doAction:action forDraggableView:aView];    
}

- (void)draggableViewDoubleTapped:(CHDraggableView *)aView {
	NSInteger action = [[SRSettings sharedSettings] doubleTapAction];
    [self doAction:action forDraggableView:aView];
}

- (void)draggableViewTouched:(CHDraggableView *)aView {
    NSInteger action = [SRSettings sharedSettings].singleTapAction;

    switch (action) {
        case 1: //live view
           	[self showLiveViewForDraggableView:aView];
        break;

        case 2: //open application
           	[[SRAppHeadsManager sharedManager] openApplication:aView.application];
        break;

        case 3: { //lock apphead
        	if ([SRSettings sharedSettings].displayMode == SRAppHeadsDisplayModeFree) {
        		BOOL draggable = aView.isDraggable;
        		[aView setIsDraggable:!draggable];	
        	}
        } break;

        default:
        break;
    }
}

#pragma mark - Live View

-(void)animateViewToConversationArea:(CHDraggableView *)aView {
	if ([SRSettings sharedSettings].displayMode != SRAppHeadsDisplayModeFree) {
        return;
    }
    CGFloat headSize = [SRSettings sharedSettings].headSize;
    CGPoint center = CGPointMake(CGRectGetMidX(self.view.bounds),CGRectGetMinY(self.view.bounds)+headSize);
    [aView snapViewCenterToPoint:center];
}

-(void)switchToDraggableView:(CHDraggableView *)aView {
    [self suspendDraggableView:_activeDraggableView withCompletion:^{
        [self showLiveViewForDraggableView:aView]; 
    }];
}

-(void)showLiveViewForDraggableView:(CHDraggableView *)aView {

    NSInteger frontPid = (NSInteger)[[UIApplication sharedApplication] _accessibilityFrontMostApplication].pid;

    if (frontPid == aView.application.pid && aView.state == CHInteractionStateNormal) {
        //suspend app with completion and then show live view
        return;
    }

    if (_activeDraggableView && !aView.isActiveDraggableView) {
        [self switchToDraggableView:aView];
        return;
    }

	void (^showLiveView)(void) = ^(void) {
        if (aView.state == CHInteractionStateNormal) {
            _activeDraggableView = aView;
            [aView setIsActiveDraggableView:TRUE];
            [[SRSettings sharedSettings] setIsInHostingMode:TRUE];
            [self.view bringSubviewToFront:aView];
            [aView setState:CHInteractionStateConversation];
            [self animateViewToConversationArea:aView];
            [self presentViewForDraggableView:aView];
            [[SRAppHeadsManager sharedManager] addAssertionToApp:aView.application];
        } else if (aView.state == CHInteractionStateConversation) {
            [self suspendDraggableView:aView withCompletion:nil];
        }
    };

    BOOL wantsTouchID = [SRSettings sharedSettings].wantsTouchIDConfirmation;
    BOOL requiresTouchID = [[SRSettings sharedSettings].touchIDEnabledApps containsObject:aView.application.displayIdentifier];

    if (wantsTouchID && [SRSettings sharedSettings].useBioLockDown && objc_getClass("BioLockdownController") && aView.state == CHInteractionStateNormal) {
        BioLockdownController *controller = [objc_getClass("BioLockdownController") sharedController];
        if ([controller requiresAuthenticationForApplication:aView.application]) {
            [controller authenticateForApplication:aView.application actionText:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"AUTHENTICATE_DESCRIPTION"] completion:^{
                showLiveView();
            } failure:nil];
        } else{
            showLiveView();
        }
    } else if (wantsTouchID && requiresTouchID && aView.state == CHInteractionStateNormal) {
        [[SRTouchIDController sharedController] startMonitoringWithResultBlock:^(SRTouchIDController *controller,SRTouchIDEvent event){
            if (event == SRTouchIDEventMatched) {
                showLiveView();
                [controller stopMonitoring];
            } else if (event == SRTouchIDEventCancelled) {
                [controller stopMonitoring];
            }
        }];
    } else {
        showLiveView();
    }
}

-(void)presentViewForDraggableView:(CHDraggableView *)aView {

	if ([SRSettings sharedSettings].displayMode == SRAppHeadsDisplayModeLocked) {
		[self tappedMenuButton:_menuButton];
	}

    [[SRNotificationCenter defaultCenter] postActivateAppWithPid:aView.application.pid];

    if ([[objc_getClass("SBLockScreenManager") sharedInstance] isUILocked]) {
    	if (iOS8) {
	    	if ([SRSettings sharedSettings].allowInLockscreen) {
		        if (iOS8) {
		            BKSDisplaySetSecureMode(NO);
		        }
		    }
	    }
        [[objc_getClass("SBBacklightController") sharedInstance] setIdleTimerDisabled:YES forReason:@"AppHeads"];
    }

     _presentingView = [[SRConversationView alloc] initWithApplication:aView.application];
    if ([SRSettings sharedSettings].displayMode == SRAppHeadsDisplayModeFree) {
        [self.view insertSubview:_presentingView belowSubview:_closeView];
    } else {
        [self.view insertSubview:_presentingView belowSubview:_collectionView];
    }
    [_presentingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_presentingView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_presentingView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_presentingView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_presentingView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [_presentingView animateIn];
}

-(void)suspendDraggableView:(CHDraggableView *)aView withCompletion:(void(^)())completionBlock {

    if ([[objc_getClass("SBLockScreenManager") sharedInstance] isUILocked]) {
        [[objc_getClass("SBBacklightController") sharedInstance] setIdleTimerDisabled:NO forReason:@"AppHeads"];
        if (iOS8) {
	    	if ([SRSettings sharedSettings].allowInLockscreen && [[objc_getClass("SBLockScreenManager") sharedInstance] isUILocked]) {
		        if (iOS8) {
		            BKSDisplaySetSecureMode(NO);
		        }
		    }
	    }
    }

    [[SRAppHeadsManager sharedManager] removeAssertionFromApp:aView.application];

	NSValue *knownEdgePoint = [self.edgePointDictionary objectForKey:aView.application.displayIdentifier];
    if (knownEdgePoint) {
        [self animateView:aView toEdgePoint:[self destinationPointForReleasePoint:[knownEdgePoint CGPointValue]]];
    } else {
        [self animateViewToEdges:aView];
    }
    [_presentingView animateOutWithCompletion:^{
        [[SRNotificationCenter defaultCenter] postDeactivateAppWithPid:aView.application.pid];
        _activeDraggableView = nil;
        [aView setIsActiveDraggableView:FALSE];
        [[SRSettings sharedSettings] setIsInHostingMode:FALSE];
        [aView setState:CHInteractionStateNormal];
        _presentingView = nil;
        if (completionBlock) {
            completionBlock();
        }
    }];
}

#pragma mark - Alignment

- (void)draggableViewNeedsAlignment:(CHDraggableView *)aView {
    if (!aView.isActiveDraggableView) {
        NSValue *knownEdgePoint = [self.edgePointDictionary objectForKey:aView.application.displayIdentifier];
        if (knownEdgePoint && [SRSettings sharedSettings].snappingEdge == CHSnappingEdgeBoth) {
            [self animateView:aView toEdgePoint:[self destinationPointForReleasePoint:[knownEdgePoint CGPointValue]]];
        } else {
            [self animateViewToEdges:aView];
        }
    }
}

- (void)animateViewToEdges:(CHDraggableView *)aView {
    if ([SRSettings sharedSettings].displayMode != SRAppHeadsDisplayModeFree) {
        return;
    }
    CGPoint destinationPoint = [self destinationPointForReleasePoint:aView.center];
	[_edgePointDictionary setObject:[NSValue valueWithCGPoint:destinationPoint] forKey:aView.application.displayIdentifier];
    [self setEdgePointDictionary:_edgePointDictionary];
    [aView snapViewCenterToPoint:destinationPoint];

}

- (void)animateView:(CHDraggableView *)aView toEdgePoint:(CGPoint)point {
    if ([SRSettings sharedSettings].displayMode != SRAppHeadsDisplayModeFree) {
        return;
    }
    [_edgePointDictionary setObject:[NSValue valueWithCGPoint:point] forKey:aView.application.displayIdentifier];
    [self setEdgePointDictionary:_edgePointDictionary];
    [aView snapViewCenterToPoint:point];
}

#pragma mark - Cleanup

-(void)hideCloseView {
    [UIView animateWithDuration:0.4f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_closeView setHidden:YES];
    } completion:nil];
}

-(BOOL)suspendActiveDraggableViewWithCompletion:(void(^)())completionBlock {
   if (_activeDraggableView) {
        [_activeDraggableView updateAlpha];
        [self suspendDraggableView:_activeDraggableView withCompletion:completionBlock];
        return TRUE;
   } 

    if (completionBlock) {
        completionBlock();
    }
    return FALSE;
}

- (void)cleanupIfNeccessary:(CHDraggableView *)aView {
    if (_activeDraggableView && [_activeDraggableView.application.displayIdentifier isEqualToString:aView.application.displayIdentifier]) {
        [self suspendActiveDraggableViewWithCompletion:nil];
    }
    if (_closeView && _closeView.superview) {
        [self hideCloseView];
    }
}

#pragma mark - Adding and Removing

- (void)addDraggableView:(CHDraggableView *)aView {
	if (_collectionView) {
		[_collectionView addDraggableView:aView];
	} else {
		[self.view addSubview:aView];
	}
}

- (void)removeDraggableView:(CHDraggableView *)aView {
	[self cleanupIfNeccessary:aView];
	if (_collectionView) {
		[_collectionView removeAppHead:aView completion:^() {
			[aView removeFromSuperview];
		}];
	} else {
		[aView removeFromSuperview];
	}
}

@end