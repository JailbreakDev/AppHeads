#import "SRDeveloperTableCell.h"

@implementation SRDeveloperTableCell
@synthesize devImageView,devNameLabel,realNameLabel,jobLabel,followButton,twitterHandle;

-(id)initWithDevName:(NSString *)devName realName:(NSString *)realName jobSubtitle:(NSString *)job devImage:(UIImage *)devImage twitterName:(NSString *)twitterName websiteURLString:(NSString *)website {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SRDeveloperTableCell"];

    if (self) {

    	self.twitterHandle = [twitterName copy];

        self.devImageView = [[UIImageView alloc] initWithImage:devImage];
        self.devImageView.frame = CGRectMake(10,15,70,70);
        self.devImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.devImageView.layer.shadowOffset = CGSizeMake(0, 1);
        self.devImageView.layer.shadowOpacity = 1;
        self.devImageView.layer.shadowRadius = 1.0;
        self.devImageView.clipsToBounds = NO;
        [self addSubview:self.devImageView];

        self.devNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.devNameLabel setText:devName];
        [self.devNameLabel setBackgroundColor:[UIColor clearColor]];
        [self.devNameLabel setTextColor:[UIColor darkGrayColor]];
        [self.devNameLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:iPad ? 30 : 23]];
        [self.devNameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.devNameLabel];
        [self.devNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.devNameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.devImageView attribute:NSLayoutAttributeRight multiplier:1 constant:30]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.devNameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-20]];

        self.realNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.realNameLabel setText:realName];
        [self.realNameLabel setTextColor:[UIColor grayColor]];
        [self.realNameLabel setBackgroundColor:[UIColor clearColor]];
        [self.realNameLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:15]];
        [self.realNameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.realNameLabel];
        [self.realNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.realNameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.devImageView attribute:NSLayoutAttributeRight multiplier:1 constant:30]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.realNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.devNameLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

        self.jobLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.jobLabel setText:job];
        [self.jobLabel setTextColor:[UIColor grayColor]];
        [self.jobLabel setBackgroundColor:[UIColor clearColor]];
        [self.jobLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:12]];
        [self.jobLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.jobLabel];
        [self.jobLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.jobLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.devImageView attribute:NSLayoutAttributeRight multiplier:1 constant:30]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.jobLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.realNameLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];

        self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.followButton.layer.borderWidth = 1;
        self.followButton.layer.cornerRadius = 4.0;
        self.followButton.layer.masksToBounds = YES;
        [self.followButton setAdjustsImageWhenHighlighted:NO];
        [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.followButton.backgroundColor = [UIColor colorWithRed:66/255.0 green:139/255.0 blue:202/255.0 alpha:1];
        self.followButton.layer.borderColor = [[UIColor colorWithRed:53/255.0 green:126/255.0 blue:189/255.0 alpha:1] CGColor];
        [self.followButton setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:51/255.0 green:119/255.0 blue:172/255.0 alpha:1]] forState:UIControlStateHighlighted];
        [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
        [self.followButton addTarget:self action:@selector(followMe:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.followButton];
        [self.followButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.followButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
            [centerY setIdentifier:@"followButtonConstraint1"];
            [self addConstraint:centerY];
            NSLayoutConstraint *rightX = [NSLayoutConstraint constraintWithItem:self.followButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-200];
            [rightX setIdentifier:@"followButtonConstraint2"];
            [self addConstraint:rightX];
        } else {
            NSLayoutConstraint *rightX = [NSLayoutConstraint constraintWithItem:self.followButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.realNameLabel attribute:NSLayoutAttributeRight multiplier:1 constant:10];
            [rightX setIdentifier:@"followButtonConstraint1"];
            [self addConstraint:rightX];
            NSLayoutConstraint *positionY = [NSLayoutConstraint constraintWithItem:self.followButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.devNameLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5];
            [positionY setIdentifier:@"followButtonConstraint2"];
            [self addConstraint:positionY];
        }
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.followButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:iPad ? 100 : 80]];
    }

    return self;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)spec {
    NSBundle *settingsBundle = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/AppHeadsSettings.bundle"];
    UIImage *developerImage = [[UIImage alloc] initWithContentsOfFile:[settingsBundle pathForResource:[spec propertyForKey:@"devImage"] ofType:@"png"]];
    self = [self initWithDevName:[spec propertyForKey:@"devName"] realName:[spec propertyForKey:@"realName"] jobSubtitle:[spec propertyForKey:@"job"] devImage:developerImage twitterName:[spec propertyForKey:@"twittername"] websiteURLString:[spec propertyForKey:@"website"]];
    return self;
}

-(BOOL)canOpenURL:(NSString *)url {
	return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
}

-(void)openURL:(NSString *)url {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void)followMe:(UIButton *)sender {
	NSString *twitterName = [self.twitterHandle lowercaseString];
	if ([self canOpenURL:@"tweetbot:"])
        [self openURL:[NSString stringWithFormat:@"tweetbot:///user_profile/%@",twitterName]];
    else if ([self canOpenURL:@"twitterrific:"]) 
        [self openURL:[NSString stringWithFormat:@"twitterrific:///profile?screen_name=%@",twitterName]];
    else if ([self canOpenURL:@"tweetings:"]) 
        [self openURL:[NSString stringWithFormat:@"tweetings:///user?screen_name=%@",twitterName]];
    else if ([self canOpenURL:@"twitter:"]) 
        [self openURL:[NSString stringWithFormat:@"twitter://user?screen_name=%@",twitterName]];
    else 
        [self openURL:[NSString stringWithFormat:@"https://mobile.twitter.com/%@",twitterName]];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self removeConstraint:[self _constraintForIdentifier:@"followButtonConstraint1"]];
    [self removeConstraint:[self _constraintForIdentifier:@"followButtonConstraint2"]];
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.followButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [centerY setIdentifier:@"followButtonConstrainft1"];
        [self addConstraint:centerY];
        NSLayoutConstraint *rightX = [NSLayoutConstraint constraintWithItem:self.followButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-200];
        [rightX setIdentifier:@"followButtonConstraint2"];
        [self addConstraint:rightX];
    } else {
        NSLayoutConstraint *rightX = [NSLayoutConstraint constraintWithItem:self.followButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.realNameLabel attribute:NSLayoutAttributeRight multiplier:1 constant:10];
        [rightX setIdentifier:@"followButtonConstraint1"];
        [self addConstraint:rightX];
        NSLayoutConstraint *positionY = [NSLayoutConstraint constraintWithItem:self.followButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.devNameLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5];
        [positionY setIdentifier:@"followButtonConstraint2"];
        [self addConstraint:positionY];
    }
}

- (UIImage *)buttonImageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end