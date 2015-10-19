#import <SRClasses/SRCloseAppHeadView.h>
#import <SRClasses/SRTouchIDAlertItem.h>
#import <SRClasses/SRAppHeadsManager.h>
#import <SRClasses/SRAppHeadCollectionView.h>
#import <SRClasses/SRConversationView.h>
#import <SRClasses/SRSettings.h>
#import <Classes/CHDraggableView.h>
#import <Classes/SKBounceAnimation/SKBounceAnimation.h>

@interface SRAppHeadsView : UIView
@end

@protocol CHDraggableViewDelegate;
@interface SRAppHeadsViewController : UIViewController <CHDraggableViewDelegate,SBReachabilityObserver>
@property (nonatomic, retain) SRAppHeadsView *view;
@property (nonatomic, strong) SRCloseAppHeadView *closeView;
@property (nonatomic, strong) CHDraggableView *activeDraggableView;
@property (nonatomic) BOOL requestsUIUnlock;
- (void)draggableViewNeedsAlignment:(CHDraggableView *)aView;
- (BOOL)suspendActiveDraggableViewWithCompletion:(void(^)())completionBlock;
- (void)cleanupIfNeccessary:(CHDraggableView *)aView;
- (void)addDraggableView:(CHDraggableView *)aView;
- (void)removeDraggableView:(CHDraggableView *)aView;
- (void)showAllAppHeads:(BOOL)show;
- (void)showLiveViewForDraggableView:(CHDraggableView *)aView;
- (void)addMenuButton;
@end