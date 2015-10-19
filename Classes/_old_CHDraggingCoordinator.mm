//
//  CHDraggingCoordinator.mm
//  ChatHeads
//
//  Created by Matthias Hochgatterer on 4/19/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//  Modified by Janosch Hübner for the AppHeads Tweak.
//

#import <QuartzCore/QuartzCore.h>
#import <SRClasses/SRLocalizer.h>
#import <SRClasses/SRTouchIDController.h>
#import "CHDraggableView.h"
#import "CHDraggingCoordinator.h"
#import "SKBounceAnimation/SKBounceAnimation.h"

static dispatch_once_t gShowCloseView = 0;

@interface CHDraggingCoordinator ()
@property (nonatomic,strong) SRAppWindow *pWindow;
@property (nonatomic,strong) UIView *presentedView;
@property (nonatomic,strong) UIView *hostView;
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong,readonly) SBApplication *frontApp;
@property (nonatomic,strong,readonly) UIView *mainView;
@property (nonatomic,strong) UITapGestureRecognizer *backgroundTapGesture;
@property (nonatomic) BOOL pInsideCenter;
@property (nonatomic) NSInteger lastPid;
@end

@implementation CHDraggingCoordinator

- (id)initWithViewController:(SRAppHeadsViewController *)aViewController {

    self = [super init];

    if (self) {

        _pInsideCenter = FALSE;
        _pWindow = (SRAppWindow *)aWindow;
        _draggableViewBounds = aBounds;
        _edgePointDictionary = [[SRSettings sharedSettings] edgePoints];
        

        
        static int orientationToken = 0;
        notify_register_dispatch("com.sharedroutine.appheads.orientation-changed", &orientationToken, dispatch_get_main_queue(), ^(int token) {
            uint64_t orientation = -1;
            notify_get_state(token,&orientation);

            if (orientation == -1) {
                return;
            }
            SBApplication *hostedApp = [_activeDraggableView application];
            if (hostedApp && iOS8) {
                dispatch_async(dispatch_get_main_queue(),^{
                    FBScene *appScene = [hostedApp mainScene];
                    FBSMutableSceneSettings *settings = [appScene mutableSettings];
                    [settings setInterfaceOrientation:orientation];
                    [appScene updateSettings:settings withTransitionContext:nil];
                    [settings setBackgrounded:YES];
                    [appScene updateSettings:settings withTransitionContext:nil];
                    [settings setBackgrounded:NO];
                    [appScene updateSettings:settings withTransitionContext:nil];
                });
            }
        });

        static int suspendActiveToken = 0;
		notify_register_dispatch("com.sharedroutine.appheads.suspendactivedraggableview", &suspendActiveToken, dispatch_get_main_queue(), ^(int token) {
			[self suspendActiveDraggableView];
        });
    }
    return self;
}

-(UIView *)mainView {
	return _pWindow.rootViewController.view;
}

#pragma mark - Geometry

- (CGRect)_dropArea {
    return CGRectInset([_pWindow.screen applicationFrame], -(NSInteger)(CGRectGetHeight(_draggableViewBounds)/6), 0);
}

- (CGRect)_conversationArea {
    CGRect slice;
    CGRect remainder;
    CGRectDivide([_pWindow.screen applicationFrame], &slice, &remainder, CGRectGetHeight(CGRectInset(_draggableViewBounds, -10, 0)), CGRectMinYEdge);
    return slice;
}
/*
- (CGRectEdge)_destinationEdgeForReleasePointInCurrentState:(CGPoint)releasePoint {
    if (UIInterfaceOrientationIsLandscape(CURRENT_INTERFACE_ORIENTATION)) {
        return releasePoint.y < CGRectGetMidY([self _dropArea]) ? CGRectMinYEdge : CGRectMaxYEdge;
    } 
    return releasePoint.x < CGRectGetMidX([self _dropArea]) ? CGRectMinXEdge : CGRectMaxXEdge;
}

- (CGPoint)_destinationPointForReleasePoint:(CGPoint)releasePoint {
    CGRect dropArea = [self _dropArea];
    CGFloat midXDragView = CGRectGetMidX(_draggableViewBounds);
    CGRectEdge destinationEdge = [self _destinationEdgeForReleasePointInCurrentState:releasePoint];
    CGFloat destinationY;
    CGFloat destinationX;

    if (self.snappingEdge == CHSnappingEdgeRight) {
    	CGFloat xOffset = (ifRightSide ? (self.view.frame.size.width - 60.0f) - 10.0f : 10.0f);
    }

    if (self.snappingEdge == CHSnappingEdgeBoth){   //ChatHead will snap to both edges
        if (destinationEdge == CGRectMinXEdge) {
            destinationX = CGRectGetMinX(dropArea) + midXDragView;
        } else {
            destinationX = CGRectGetMaxX(dropArea) - midXDragView;
        }
        
    }else if(self.snappingEdge == CHSnappingEdgeLeft){  //ChatHead will snap only to left edge
        destinationX = CGRectGetMinX(dropArea) + midXDragView;
        
    }else{  //ChatHead will snap only to right edge
        destinationX = CGRectGetMaxX(dropArea) - midXDragView;
    }

    return CGPointMake(destinationX, destinationY);
}
*/

-(SBApplication *)frontApp {
    return [[UIApplication sharedApplication] _accessibilityFrontMostApplication];
}

#pragma mark - Dragging
/*
- (void)draggableView:(CHDraggableView *)aView didMoveToPoint:(CGPoint)point {

    dispatch_once(&gShowCloseView,^{
        [self showCloseView];
    });

    static dispatch_once_t p = 0;
    static dispatch_once_t pp = 0;

    if (CGRectContainsPoint(_pCloseView.dropRect,aView.center)) {
        pp = 0;
        _pInsideCenter = TRUE;
    } else {
        p = 0;
        _pInsideCenter = FALSE;
    }
    if (_pInsideCenter) {
        dispatch_once(&p, ^{
            [self addBounceAnimationToView:_pCloseView.crossImageView withFromValue:1.0 andToValue:1.2];
        });
    } else {
         dispatch_once(&pp, ^{
            [self addBounceAnimationToView:_pCloseView.crossImageView withFromValue:1.2 andToValue:1.0];
        });
    }
}
*/

/*
-(void)hideCloseView {
    [UIView animateWithDuration:0.4f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_pCloseView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        if (finished) {
            gShowCloseView = 0;
        }
    }];
}
-(void)showCloseView {
    [UIView animateWithDuration:0.4f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_pCloseView setAlpha:1.0f];
    } completion:nil];
}
*/

/*
-(void)closeApplicationForView:(CHDraggableView *)aView {
    SBApplication *app = aView.application;
    if (app) {
        if ([[objc_getClass("SBUIController") sharedInstance] isAppSwitcherShowing]) {
            if (iOS8) {
                SBAppSwitcherController *appSwitcher = [[objc_getClass("SBUIController") sharedInstance] _appSwitcherController];
                SBDisplayItem *displayItem = [[objc_getClass("SBDisplayItem") alloc] initWithType:@"App" displayIdentifier:app.displayIdentifier];
                [appSwitcher _quitAppWithDisplayItem:displayItem];
            } else if (iOS7) {
                SBAppSliderController *sliderController = [[objc_getClass("SBUIController") sharedInstance] _appSliderController];
                NSInteger index = [sliderController.applicationList indexOfObject:app.displayIdentifier];
                if (index != NSNotFound) {
                    [sliderController _quitAppAtIndex:index];
                }
            }
        } else {
            [[SRNotificationCenter defaultCenter] postCloseAppWithPid:app.pid];
        	[[SRAppHeadsManager sharedManager] removeAppHeadForDisplayIdentifier:app.displayIdentifier];
        }
	}
}
*/

-(NSString *)animationSubtypeForSettings {
    NSInteger displayMode = [SRSettings sharedSettings].displayMode;
    if (displayMode == SRAppHeadsDisplayModeFree) {
        return kCATransitionFromBottom;
    }
    switch (displayMode) {
        case SRAppHeadsDisplayModeLockedBottom:
            return kCATransitionFromBottom;
        case SRAppHeadsDisplayModeLockedLeft:
            return kCATransitionFromLeft;
        case SRAppHeadsDisplayModeLockedRight:
            return kCATransitionFromRight;
        case SRAppHeadsDisplayModeLockedTop:
            return kCATransitionFromTop;
        default:
            return kCATransitionFromBottom;
    }
}

-(void)switchToDraggableView:(CHDraggableView *)aView {

    void (^switchForReal)() = ^{
        NSValue *knownEdgePoint = [_edgePointDictionary objectForKey:@(_activeDraggableView.tag)];
        if (knownEdgePoint) {
            [self _animateView:_activeDraggableView toEdgePoint:[knownEdgePoint CGPointValue]];
        } else {
            [self _animateViewToEdges:_activeDraggableView];
        }

        [self.mainView bringSubviewToFront:aView];
        [self animateViewToConversationArea:aView];
            
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.5];
        [animation setType:kCATransitionPush];
        [animation setSubtype:[self animationSubtypeForSettings]];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]]; 
        [[_hostView layer] addAnimation:animation forKey:@"appheads_switchview"];
        [self suspendDraggableView:_activeDraggableView  withCompletion:^{
            [self showLiveViewForDraggableView:aView alreadyAuthenticated:YES];
            [[_hostView layer] removeAnimationForKey:@"appheads_switchview"];
        }];
    };

    if ([SRSettings sharedSettings].wantsTouchIDConfirmation && [[SRSettings sharedSettings].touchIDEnabledApps containsObject:aView.application.displayIdentifier] && aView.state == CHInteractionStateNormal) {
        [[SRTouchIDController sharedController] startMonitoringWithResultBlock:^(SRTouchIDController *controller,SRTouchIDEvent event){
            if (event == SRTouchIDEventMatched) {
                switchForReal();
                [controller stopMonitoring];
            } else if (event == SRTouchIDEventCancelled) {
                [controller stopMonitoring];
            }
        }];
    } else {
        switchForReal();
    }
}

/*
-(void)showLiveViewForDraggableView:(CHDraggableView *)aView alreadyAuthenticated:(BOOL)authenticated {

    NSInteger frontPid = (NSInteger)[[UIApplication sharedApplication] _accessibilityFrontMostApplication].pid;

    void (^showForReal)(void) = ^(void) {
        if (aView.state == CHInteractionStateNormal) {
            if (frontPid == aView.application.pid) {
                return;
            }
            _activeDraggableView = aView;
            [aView setIsActiveDraggableView:TRUE];
            _lastPid = frontPid;
            [[SRSettings sharedSettings] setIsInHostingMode:TRUE];
            [self.mainView bringSubviewToFront:aView];
            aView.state = CHInteractionStateConversation;
            [self animateViewToConversationArea:aView];
            [self presentViewForDraggableView:aView];
        } else if (aView.state == CHInteractionStateConversation) {
            [self suspendDraggableView:aView withCompletion:nil];
        }
    };

	if (_activeDraggableView && !aView.isActiveDraggableView) {
        [self switchToDraggableView:aView];
		return;
	}

    if ([SRSettings sharedSettings].wantsTouchIDConfirmation && [[SRSettings sharedSettings].touchIDEnabledApps containsObject:aView.application.displayIdentifier] && aView.state == CHInteractionStateNormal && !authenticated) {
        [[SRTouchIDController sharedController] startMonitoringWithResultBlock:^(SRTouchIDController *controller,SRTouchIDEvent event){
            if (event == SRTouchIDEventMatched) {
                showForReal();
                [controller stopMonitoring];
            } else if (event == SRTouchIDEventCancelled) {
                [controller stopMonitoring];
            }
        }];
    } else {
        showForReal();
    }
}
*/


/*
-(void)suspendDraggableView:(CHDraggableView *)aView withCompletion:(void(^)())completionBlock {
	[[SRSettings sharedSettings] setIsInHostingMode:FALSE];
    aView.state = CHInteractionStateNormal;
    NSValue *knownEdgePoint = [_edgePointDictionary objectForKey:@(aView.tag)];
    if (knownEdgePoint) {
        [self _animateView:aView toEdgePoint:[knownEdgePoint CGPointValue]];
    } else {
        [self _animateViewToEdges:aView];
    }
    _activeDraggableView = nil;
    [aView setIsActiveDraggableView:FALSE];
    [self hidePresentedViewWithCompletion:^(void) {
    	[[SRNotificationCenter defaultCenter] postDeactivateAppWithPid:aView.application.pid];
    	 if (completionBlock) {
    		completionBlock();
    	}
    }];
   
}
*/

/**
//managed by appheads manager
-(void)openApplicationForSBApplication:(SBApplication *)aApplication {
	
	if (iOS8) {
		unsigned int clientPort = [[objc_getClass("FBSSystemService") sharedService] createClientPort];
		[self suspendActiveDraggableViewWithCompletion:^{
			[[objc_getClass("FBSSystemService") sharedService] openApplication:[aApplication bundleIdentifier] options:nil clientPort:clientPort withResult:nil];
		}];
	} else {
		[self suspendActiveDraggableViewWithCompletion:^{
			[[objc_getClass("SBUIController") sharedInstance] activateApplicationAnimated:aApplication];
		}];
	}
}
*/

/*
#pragma mark - CHDraggableViewDelegate

- (void)draggableViewReleased:(CHDraggableView *)aView {

    [self hideCloseView];

    if (CGRectContainsPoint(_pCloseView.dropRect,aView.center)) {
        [self closeApplicationForView:aView];
        return;
    }

    if (_activeDraggableView && aView.isActiveDraggableView) {
         [self animateViewToConversationArea:aView];
        return;
    }

    if (aView.state == CHInteractionStateNormal) {
        [self _animateViewToEdges:aView];
    } else if(aView.state == CHInteractionStateConversation) {
        [self animateViewToConversationArea:aView];
        [self presentViewForDraggableView:aView];
    }
}
*/

/*
- (void)draggableViewHold:(CHDraggableView *)aView { 

    NSInteger action = [SRSettings sharedSettings].holdAction;

    switch (action) {
        case 1: //live view
            [self showLiveViewForDraggableView:aView alreadyAuthenticated:NO];
        break;

        case 2: //open app
          [self openApplicationForSBApplication:aView.application];
        break;

        case 3: //close application
            [self closeApplicationForView:aView];
        break;

        case 4: { //close all apps
        	if (iOS8) {
        		[self killSelectedApps];
        	} else {
        		notify_post("com.sharedroutine.appheads.killall");
        	}
        } 
        break;

        case 5: {//lock apphead
        	if ([SRSettings sharedSettings].displayMode == SRAppHeadsDisplayModeFree) {
        		BOOL draggable = aView.isDraggable;
        		[aView setIsDraggable:!draggable];	
        	}
        } break;

        default:
        break;
    }
}

- (void)draggableViewDoubleTapped:(CHDraggableView *)aView {

	NSInteger action = [[SRSettings sharedSettings] doubleTapAction];

	switch (action) {
        case 1: //live view
            [self showLiveViewForDraggableView:aView alreadyAuthenticated:NO];
        break;

        case 2: //open app
          [self openApplicationForSBApplication:aView.application];
        break;

        case 3: //close application
            [self closeApplicationForView:aView];
        break;

        case 4: //close all apps
        	if (iOS8) {
        		[self killSelectedApps];
        	} else {
        		notify_post("com.sharedroutine.appheads.killall");
        	}
        break;

        case 5: {//lock apphead
        	if ([SRSettings sharedSettings].displayMode == SRAppHeadsDisplayModeFree) {
        		BOOL draggable = aView.isDraggable;
        		[aView setIsDraggable:!draggable];	
        	}
        } break;

        default:
        break;
    }
}

- (void)draggableViewTouched:(CHDraggableView *)aView {
    NSInteger action = [SRSettings sharedSettings].singleTapAction;

    switch (action) {
        case 1: //live view
            [self showLiveViewForDraggableView:aView alreadyAuthenticated:NO];
        break;

        case 2: //open application
            [self openApplicationForSBApplication:aView.application];
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
*/

/*
#pragma mark - Alignment

- (void)draggableViewNeedsAlignment:(CHDraggableView *)aView {
    [self _animateViewToEdges:aView];
}

#pragma mark Dragging Helper

- (void)_animateViewToEdges:(CHDraggableView *)aView {
    if ([SRSettings sharedSettings].displayMode != SRAppHeadsDisplayModeFree) {
        return;
    }

    CGPoint destinationPoint = [self _destinationPointForReleasePoint:aView.center]; 
	[self _animateView:aView toEdgePoint:destinationPoint]; 
}

- (void)_animateView:(CHDraggableView *)aView toEdgePoint:(CGPoint)point {
    if ([SRSettings sharedSettings].displayMode != SRAppHeadsDisplayModeFree) {
        return;
    }
    [_edgePointDictionary setObject:[NSValue valueWithCGPoint:point] forKey:@(aView.tag)];
    [[SRSettings sharedSettings] setEdgePoints:_edgePointDictionary];
    [aView snapViewCenterToPoint:point];
}
*/

/*
-(CGPoint)centerForOrientation:(UIInterfaceOrientation)orientation {
	CGRect dropArea = [self _dropArea];
	switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return CGPointMake(CGRectGetMinX(dropArea)+CGRectGetMidX(_draggableViewBounds),CGRectGetMidY(dropArea));
        break;

        case UIInterfaceOrientationLandscapeRight:
            return CGPointMake(CGRectGetMaxX(dropArea)-CGRectGetMidX(_draggableViewBounds),CGRectGetMidY(dropArea));
        break;

        case UIInterfaceOrientationPortrait:
            return CGPointMake(CGRectGetMidX(dropArea),CGRectGetMinY(dropArea)+CGRectGetMidX(_draggableViewBounds));
        break;

        case UIInterfaceOrientationPortraitUpsideDown:
            return CGPointMake(CGRectGetMidX(dropArea),CGRectGetMaxY(dropArea)-CGRectGetMidX(_draggableViewBounds));
        break;

        default:
            return CGPointMake(CGRectGetMidX(dropArea),CGRectGetMinY(dropArea)+CGRectGetMidX(_draggableViewBounds));
        break;
    }
}

- (void)animateViewToConversationArea:(CHDraggableView *)view {
    if ([SRSettings sharedSettings].displayMode != SRAppHeadsDisplayModeFree) {
        return;
    }

    CGPoint center = [self centerForOrientation:CURRENT_INTERFACE_ORIENTATION];
    [view snapViewCenterToPoint:center];
}
*/

/*

#pragma mark - View Controller Handling

- (void)presentViewForDraggableView:(CHDraggableView *)aDraggableView {
    _presentedView = [[SRConversationView sharedInstance] conversationViewForApplication:aDraggableView.application];
    if (!_hostView) {
        _hostView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _hostView.userInteractionEnabled = NO;
    }
    [_hostView addSubview:_presentedView];
    if ([SRSettings sharedSettings].displayMode == SRAppHeadsDisplayModeFree) {
        [self.mainView insertSubview:_hostView belowSubview:_pCloseView];
    } else {
        [self.mainView insertSubview:_hostView belowSubview:aDraggableView];
    }
    [self showPresentedViewForDraggableView:aDraggableView withCompletion:^{
    	_presentedView.layer.cornerRadius = [[SRSettings sharedSettings] cornerRadius];
        _presentedView.layer.borderWidth = [[SRSettings sharedSettings] borderWidth];
        _presentedView.layer.borderColor = [[SRSettings sharedSettings] borderColor].CGColor;
    	_presentedView.layer.masksToBounds = YES;
        [[SRNotificationCenter defaultCenter] postActivateAppWithPid:aDraggableView.application.pid];
    }];
}

- (void)showPresentedViewForDraggableView:(CHDraggableView *)aView withCompletion:(void(^)())completionBlock {
    BOOL usesWP = ([SRSettings sharedSettings].backgroundView == 1); //wallpaper view
    BOOL usesScreenshot = ([SRSettings sharedSettings].backgroundView == 0);
    _presentedView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    _backgroundView = [[UIView alloc] initWithFrame:[_pWindow frame]];
    _backgroundView.alpha = 0.0f;
    if (usesWP) { //wallpaper view
        SRWallpaperImage *image = [SRWallpaperImage wallpaperImage];
        UIImageView *wallpaperImageView = [[UIImageView alloc] initWithImage:image];
        [wallpaperImageView setFrame:[[UIScreen mainScreen] bounds]];
       [_backgroundView addSubview:wallpaperImageView];
    } else if (usesScreenshot) { //last app bg
    	UIView *screenshotView = [[SRAppHeadsManager sharedManager] snapshotViewForApplication:[[UIApplication sharedApplication] _accessibilityFrontMostApplication]];
        screenshotView.tag = 1924;
        [_backgroundView addSubview:screenshotView];
    } else {
    	_backgroundView.userInteractionEnabled = NO;
    	[_backgroundView setBackgroundColor:[UIColor clearColor]];
    }

    _backgroundTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suspendActiveDraggableView)];
    _backgroundTapGesture.numberOfTapsRequired = 1;
    [_backgroundView addGestureRecognizer:_backgroundTapGesture];

    [self.mainView insertSubview:_backgroundView atIndex:0];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _presentedView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
        _backgroundView.alpha = 1.0f;
    } completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.3f animations:^{
            	CGFloat viewSize = [SRSettings sharedSettings].viewSize;
                _presentedView.transform = CGAffineTransformMakeScale(viewSize, viewSize);
            }];
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}
*/

/*
- (void)cleanupIfNeccessary:(CHDraggableView *)aView {
    if (_activeDraggableView && [_activeDraggableView.application.displayIdentifier isEqualToString:aView.application.displayIdentifier]) {
        [self hidePresentedViewWithCompletion:^{
            _activeDraggableView = nil;
            [aView setIsActiveDraggableView:FALSE];
        }];
    }
    if (_pCloseView && _pCloseView.superview) {
        [self hideCloseView];
    }
    SBApplication *frontApp = (SBApplication *)self.frontApp;
    if (frontApp && [aView.application.displayIdentifier isEqualToString:frontApp.displayIdentifier]) {
    	UIView *bgView = [_backgroundView viewWithTag:1924];
    	if (bgView) {
    		[bgView removeFromSuperview];
    	}
    }
}
*/

/*
- (void)hidePresentedViewWithCompletion:(void(^)())completionBlock {
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _presentedView.transform = CGAffineTransformMakeScale(0,0);
        _presentedView.alpha = 0.0f;
        _presentedView.layer.masksToBounds = FALSE;
        _backgroundView.alpha = 0.0f;
    } completion:^(BOOL finished){
        if (finished) {
            [_backgroundView removeFromSuperview];
            _backgroundView = nil;
            _backgroundTapGesture = nil;
            [_presentedView removeFromSuperview];
            _presentedView = nil;
            [_hostView removeFromSuperview];
            _hostView = nil;

            if (completionBlock) {
            	completionBlock();
            }
        }
    }];
}
*/

@end
