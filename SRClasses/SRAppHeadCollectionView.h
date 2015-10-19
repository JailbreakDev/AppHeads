#import <Classes/CHAvatarView.h>
#import <Classes/CHDraggableView.h>
#import "SRSettings.h"
#import "SRAppHeadsManager.h"

@class CHAvatarView,SBApplication;
@interface SRAppHeadCollectionView : UICollectionView <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
-(void)addDraggableView:(CHDraggableView *)aDraggableView;
-(void)removeAppHead:(CHDraggableView *)aDraggableView completion:(void(^)())completionBlock;
-(id)initWithDefaultSettings;
@end