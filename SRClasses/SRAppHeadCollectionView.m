#import "SRAppHeadCollectionView.h"

@interface SRAppHeadCollectionView()
@property (nonatomic,strong) NSMutableArray *appHeadIdentifiers;
@end

@implementation SRAppHeadCollectionView
@synthesize appHeadIdentifiers = _appHeadIdentifiers;

-(id)initWithDefaultSettings {

	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	[flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

	self = [super initWithFrame:CGRectZero collectionViewLayout:flowLayout];

	if (self) {
		_appHeadIdentifiers = [NSMutableArray array];
		[self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AppCell"];
		[self setDataSource:self];
    	[self setDelegate:self];
		[self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
		[self setPagingEnabled:TRUE];
		[self setShowsHorizontalScrollIndicator:FALSE];
		[self setShowsVerticalScrollIndicator:FALSE];
		self.layer.cornerRadius = 8.0f;
		self.layer.masksToBounds = YES;
	}

	return self;
}

-(void)removeAppHead:(CHDraggableView *)aDraggableView completion:(void(^)())completionBlock {
	[_appHeadIdentifiers removeObject:aDraggableView];
	[self reloadData];
	if (completionBlock) {
		completionBlock();
	}
}

-(void)addDraggableView:(CHDraggableView *)aDraggableView {
	[_appHeadIdentifiers addObject:aDraggableView];
	[self reloadData];
}

#pragma mark - UICollectionView Datasource

-(NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
	return _appHeadIdentifiers.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AppCell" forIndexPath:indexPath];
	CHDraggableView *appHead = _appHeadIdentifiers[indexPath.row];
	if (appHead) {
		[appHead setFrame:cell.contentView.frame];
		[cell.contentView addSubview:(UIView *)appHead];
	}
	return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat size = [SRSettings sharedSettings].headSize;
	return CGSizeMake(size,size);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5); //top,left,bottom,right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

@end
