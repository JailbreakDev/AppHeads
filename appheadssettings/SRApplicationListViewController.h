#import <Preferences/Preferences.h>
#import <libapplist/AppList.h>
#import <objc/runtime.h>

@interface PSViewController (CallSuper)
-(instancetype)initForContentSize:(CGSize)size;
@end

@interface SRApplicationListViewController : PSViewController <UITableViewDelegate>
@property (nonatomic) UITableView *pTableView;
@property (nonatomic,strong) ALApplicationTableDataSource *pDataSource;
- (instancetype)initForContentSize:(CGSize)aSize;
- (UIView *)view;
- (CGSize)contentSize;
- (id)navigationTitle;
@end

@interface SRApplicationListDataSource : ALApplicationTableDataSource <ALValueCellDelegate>
@property (nonatomic) SRApplicationListViewController *rootController;
- (instancetype)initWithController:(SRApplicationListViewController *)aController;
@end