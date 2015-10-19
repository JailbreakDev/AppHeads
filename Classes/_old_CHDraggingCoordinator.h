//
//  CHDraggingCoordinator.h
//  ChatHeads
//
//  Created by Matthias Hochgatterer on 4/19/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//	Modified by Janosch Hübner for the AppHeads Tweak.
//

#import <Foundation/Foundation.h>
#import <SRClasses/SRNotificationCenter.h>
#import <SRClasses/SRAppHeadsViewController.h>
#import "CHDraggableView.h"


@interface CHDraggingCoordinator : NSObject 

@property (nonatomic) CHSnappingEdge snappingEdge;
@property (nonatomic,strong) CHDraggableView *activeDraggableView;
- (id)initWithViewController:(SRAppHeadsViewController *)aViewController;

@end
