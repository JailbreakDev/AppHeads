//
//  CHDraggableView.m
//  ChatHeads
//
//  Created by Matthias Hochgatterer on 4/19/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//  Modified by Janosch Hübner for the AppHeads Tweak.
//

#import <QuartzCore/QuartzCore.h>
#import "CHDraggableView.h"
#import "SKBounceAnimation/SKBounceAnimation.h"

@interface CHDraggableView ()
@property (nonatomic,strong) CHAvatarView *avatarView;
@end

@implementation CHDraggableView
@synthesize delegate = _delegate;
@synthesize application,draggable,state,activeDraggableView;
@synthesize doubleTapGesture = _doubleTapGesture;
@synthesize avatarView = _avatarView;

-(instancetype)initWithImage:(UIImage *)image size:(CGSize)size application:(SBApplication *)app {
    self = [super initWithFrame:CGRectMake(0,0,size.width,size.height)];
    if (self) {
        self.application = app;
        [self addGestureRecognizer];
        [self updateAlpha];
        _avatarView = [[CHAvatarView alloc] initWithImage:image frame:CGRectInset(self.frame, 4, 4)];
        _avatarView.backgroundColor = [UIColor clearColor];
        _avatarView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addSubview:_avatarView];
    }
    return self;
}

-(void)addGestureRecognizer {

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragging:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:panGesture];
        
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self addGestureRecognizer:longPress];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];

    _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    _doubleTapGesture.numberOfTapsRequired = 2;
    [_doubleTapGesture setMaximumIntervalBetweenSuccessiveTaps:[[SRSettings sharedSettings] doubleTapInterval]];
    [self addGestureRecognizer:_doubleTapGesture];
    [tapGesture requireGestureRecognizerToFail:_doubleTapGesture];

}

-(void)updateAlpha {

    if (![SRSettings sharedSettings].isInHiddenMode) {
        [self setAlpha:1.0];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        dispatch_async(dispatch_get_main_queue(),^{
            if (![SRSettings sharedSettings].isInHiddenMode && !self.isActiveDraggableView) {
                [self setAlpha:0.4];
            }
        });
    });
}

#pragma mark - Gesture Recognizer

-(void)handleTap:(UITapGestureRecognizer *)recognizer {
    if (_delegate && [_delegate respondsToSelector:@selector(draggableViewTouched:)]) {
        [self updateAlpha];
        [_delegate draggableViewTouched:self];
    }
}

-(void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    if (_delegate && [_delegate respondsToSelector:@selector(draggableViewDoubleTapped:)]) {
        [self updateAlpha];
        [_delegate draggableViewDoubleTapped:self];
    }
}

-(void)longPressed:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self updateAlpha];
        if (_delegate && [_delegate respondsToSelector:@selector(draggableViewHold:)]) {
            [self _beginHoldAnimation];
            [_delegate draggableViewHold:self];
        }
    }
}

#pragma mark - Touching

-(void)handleDragging:(UIPanGestureRecognizer *)recognizer {

    if (!self.isDraggable) {
        return;
    }

    [self setAlpha:1.0];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (_delegate) {
            [_delegate draggableViewDidBeginDragging:self];
        }
    }
    
    CGPoint translation = [recognizer translationInView:self];
	self.center = CGPointMake(recognizer.view.center.x + translation.x,
	                              recognizer.view.center.y + translation.y);
	[recognizer setTranslation:CGPointMake(0, 0) inView:self];
	   
	if (_delegate) {
	   [_delegate draggableView:self didMoveToPoint:self.center];
	}
	
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (_delegate && [_delegate respondsToSelector:@selector(draggableViewReleased:)]) {
            [_delegate draggableViewReleased:self];
        }
        [self updateAlpha];
        [self _beginReleaseAnimation];
    }

}

#pragma mark - Animations

- (void)_beginHoldAnimation {
    [self addBounceAnimationWithTransformTo:CATransform3DMakeScale(0.95, 0.95, 1) andFromTransform:CATransform3DMakeScale(1, 1, 1)];
}

- (void)_beginReleaseAnimation {
    [self addBounceAnimationWithTransformTo:CATransform3DMakeScale(1, 1, 1) andFromTransform:self.layer.transform];
}

-(void)updateToSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    [self setFrame:frame];
    CGRect avFrame = _avatarView.frame;
    avFrame.size = size;
    [_avatarView setFrame:avFrame];
}

-(void)addBounceAnimationWithTransformTo:(CATransform3D)to andFromTransform:(CATransform3D)from {
    SKBounceAnimation *animation = [SKBounceAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCATransform3D:from];
    animation.toValue = [NSValue valueWithCATransform3D:to];
    animation.duration = 0.2f;
    self.layer.transform = [animation.toValue CATransform3DValue];
    [self.layer addAnimation:animation forKey:nil];
}

-(void)snapFromPoint:(CGPoint)lastPoint toPoint:(CGPoint)newPoint {
    SKBounceAnimation *animation = [SKBounceAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCGPoint:lastPoint];
    animation.toValue = [NSValue valueWithCGPoint:newPoint];
    animation.duration = 1.2f;
    self.layer.position = newPoint;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)snapViewCenterToPoint:(CGPoint)point {
    CGPoint currentCenter = self.center;
    [self snapFromPoint:currentCenter toPoint:point];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];

    if (![SRSettings sharedSettings].isInHostingMode) {
        if (_delegate) {
            [_delegate draggableViewNeedsAlignment:self];
        }
    } 
}

@end
