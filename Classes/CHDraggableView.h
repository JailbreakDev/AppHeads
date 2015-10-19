//
//  CHDraggableView.h
//  ChatHeads
//
//  Created by Matthias Hochgatterer on 4/19/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//	Modified by Janosch Hübner for the AppHeads Tweak.
//

#import <SRClasses/SRSettings.h>
#import "CHAvatarView.h"

@protocol CHDraggableViewDelegate;
@interface CHDraggableView : UIView
@property (nonatomic,getter=isDraggable,setter=setIsDraggable:) BOOL draggable;
@property (nonatomic,assign) id<CHDraggableViewDelegate> delegate;
@property (nonatomic,strong) SBApplication *application;
@property (nonatomic,assign) CHInteractionState state;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic,getter=isActiveDraggableView,setter=setIsActiveDraggableView:) BOOL activeDraggableView;
-(instancetype)initWithImage:(UIImage *)image size:(CGSize)size application:(SBApplication *)app;
-(void)snapViewCenterToPoint:(CGPoint)point;
-(void)updateAlpha;
-(void)updateToSize:(CGSize)size;
@end

@protocol CHDraggableViewDelegate <NSObject>
@required
- (void)draggableViewDoubleTapped:(CHDraggableView *)view;
- (void)draggableViewHold:(CHDraggableView *)view;
- (void)draggableViewDidBeginDragging:(CHDraggableView *)view;
- (void)draggableView:(CHDraggableView *)view didMoveToPoint:(CGPoint)point;
- (void)draggableViewReleased:(CHDraggableView *)view;
- (void)draggableViewTouched:(CHDraggableView *)view;
- (void)draggableViewNeedsAlignment:(CHDraggableView *)view;
@end