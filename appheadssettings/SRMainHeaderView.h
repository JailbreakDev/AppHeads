#import <Preferences/Preferences.h>
@interface SRMainHeaderView : UIView
@property (nonatomic,strong) UILabel *headerLabel;
@property (nonatomic,strong) UILabel *subHeaderLabel;
@property (nonatomic,strong) UILabel *randomLabel;
@property (nonatomic,readonly) NSArray *randomTexts;
@end