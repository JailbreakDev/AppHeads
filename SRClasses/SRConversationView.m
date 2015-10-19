#import "SRConversationView.h"

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@interface SRConversationView ()
@property (nonatomic,strong) SBApplication *application;
@property (nonatomic,assign,readonly) UIView *contentView;
@property (nonatomic,strong) UITapGestureRecognizer *backgroundTapGesture;
@end

@implementation SRConversationView
@synthesize application = _application;
@synthesize contentView = _contentView;
@synthesize backgroundTapGesture = _backgroundTapGesture;

-(instancetype)initWithApplication:(SBApplication *)app {
	self = [super initWithFrame:UIScreen.mainScreen.bounds];
	if (self) {
		_application = app;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	}
	return self;
}

-(UIView *)contentView {
    if (_contentView) {
        return _contentView;
    }
	if (iOS8) {
        FBWindowContextHostWrapperView *wrapperView = (FBWindowContextHostWrapperView *)[[_application mainScene].contextHostManager hostViewForRequester:@"appheads" enableAndOrderFront:TRUE];
        [wrapperView setBackgroundColorWhileHosting:[UIColor clearColor]];
        [wrapperView setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0))];
        // FBWindowContextHostView *hostView = [wrapperView.manager valueForKey:@"_hostView"];
        // hostView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        // wrapperView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _contentView = wrapperView;
    } else {
        _contentView = [[_application mainScreenContextHostManager] hostViewForRequester:@"appheads" enableAndOrderFront:TRUE];
    }
    return _contentView;
}

-(void)animateIn {

    [self updateSceneVisibility:YES];

    self.contentView.alpha = 0.0f;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    [self addSubview:self.contentView];

    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    	self.contentView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
        self.contentView.alpha = 1.0f;
    } completion:^(BOOL finished) {
    	if (finished) {
    		[UIView animateWithDuration:0.3f animations:^{
    			CGFloat viewSize = [SRSettings sharedSettings].viewSize;
    			self.contentView.transform = CGAffineTransformMakeScale(viewSize, viewSize);
    			self.contentView.layer.cornerRadius = [[SRSettings sharedSettings] cornerRadius];
		        self.contentView.layer.borderWidth = [[SRSettings sharedSettings] borderWidth];
		        self.contentView.layer.borderColor = [[SRSettings sharedSettings] borderColor].CGColor;
		    	self.contentView.layer.masksToBounds = YES;
            }];
    	}
    }];

    BOOL wantsNoBG = ([SRSettings sharedSettings].backgroundView == 1); //no background view
    BOOL wantsDismissBG = ([SRSettings sharedSettings].backgroundView == 0); //tap background to close liveview

    if (wantsNoBG) {
    	[self setUserInteractionEnabled:NO];
    	[self setBackgroundColor:[UIColor clearColor]];
    } else if (wantsDismissBG) {
    	_backgroundTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:[SRAppHeadsManager sharedManager] action:@selector(suspendActiveDraggableView)];
	    _backgroundTapGesture.numberOfTapsRequired = 1;
	    [self addGestureRecognizer:_backgroundTapGesture];
    }
}

-(void)animateOutWithCompletion:(void(^)())completionBlock {
	[UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.1,0.1);
        self.contentView.alpha = 0.0f;
        self.contentView.layer.masksToBounds = FALSE;
    } completion:^(BOOL finished) {
    	if (finished) {
	    	[self updateSceneVisibility:FALSE];

	    	if (_backgroundTapGesture) {
	    		[self removeGestureRecognizer:_backgroundTapGesture];
	    		_backgroundTapGesture = nil;
	    	}

	    	if (self.contentView) {
	    		[self.contentView removeFromSuperview];
	    	}
	    	
	    	[self removeFromSuperview];

	    	if (completionBlock) {
    			completionBlock();
	    	}
    	}
    }];
}

- (void) rotateViewAnimated:(UIView*)view
               withDuration:(CFTimeInterval)duration
                    byAngle:(CGFloat)angle
{
    [CATransaction begin];
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.byValue = [NSNumber numberWithFloat:angle];
    rotationAnimation.duration = duration;
    rotationAnimation.removedOnCompletion = YES;

    [CATransaction setCompletionBlock:^{
        view.transform = CGAffineTransformConcat(view.transform,CGAffineTransformRotate(view.transform, angle));
    }];

    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [CATransaction commit];
}

#pragma mark Scene

-(void)updateSceneVisibility:(BOOL)show {
	if (iOS8) {
		FBScene *appScene = [_application mainScene];
		FBSMutableSceneSettings *settings = appScene.mutableSettings;
        // FBWindowContextHostView *hostView = [((FBWindowContextHostWrapperView *)self.contentView).manager valueForKey:@"_hostView"];
        // if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        //     [self rotateViewAnimated:hostView withDuration:0.3 byAngle:DEGREES_TO_RADIANS(-90)];
        //     hostView.layer.anchorPoint = CGPointMake(0.14,0.14);
        // }
		[settings setBackgrounded:!show];
		[settings setInterfaceOrientation:UIApplication.sharedApplication.statusBarOrientation];
		[appScene updateSettings:settings withTransitionContext:nil];
	}
}

@end