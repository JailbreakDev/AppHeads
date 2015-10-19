#import <Preferences/Preferences.h>

@interface UIView (Constraint)
-(NSLayoutConstraint *)_constraintForIdentifier:(id)arg1 ;
@end

@interface SRDeveloperTableCell : PSTableCell
@property (nonatomic,strong) UIImageView *devImageView;
@property (nonatomic,strong) UILabel *devNameLabel;
@property (nonatomic,strong) UILabel *realNameLabel;
@property (nonatomic,strong) UILabel *jobLabel;
@property (nonatomic,strong) UIButton *followButton;
@property (nonatomic,copy) NSString *twitterHandle;
-(id)initWithDevName:(NSString *)devName realName:(NSString *)realName jobSubtitle:(NSString *)job devImage:(UIImage *)devImage twitterName:(NSString *)twitterName websiteURLString:(NSString *)website;
@end