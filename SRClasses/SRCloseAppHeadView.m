#import "SRCloseAppHeadView.h"
#import "SRLocalizer.h"

@interface SRCloseAppHeadView ()
@property (nonatomic,strong) UILabel *dragToHideLabel;
@end

@implementation SRCloseAppHeadView
@synthesize crossImageView = _crossImageView;
@synthesize dragToHideLabel = _dragToHideLabel;
@dynamic dropRect;

-(id)init {

	self = [super initWithFrame:CGRectZero];

	if (self) {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,2);
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.7f;
		[self setupView];
    }

	return self;
}

-(CGRect)dropRect {
    return [self convertRect:_crossImageView.frame toView:self.superview];
}

-(void)setupView {

    UIImage *closeImage = [UIImage imageWithContentsOfFile:@"/Library/Application Support/AppHeads/close.png"];
	CGSize imageSize = CGSizeMake(50,50);
	CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
	UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
	[closeImage drawInRect:imageRect];
	UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	closeImage = roundedImage;

	_crossImageView = [[UIImageView alloc] initWithImage:closeImage];
    
    [_crossImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_crossImageView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_crossImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_crossImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.f constant:10]];

    _dragToHideLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    _dragToHideLabel.text = [[SRLocalizer sharedLocalizer] localizedStringForKey:@"DRAG_TO_CLOSE"];
    _dragToHideLabel.textColor = [UIColor whiteColor];
    _dragToHideLabel.textAlignment = NSTextAlignmentCenter;
    _dragToHideLabel.backgroundColor = [UIColor clearColor];
    _dragToHideLabel.font = [UIFont systemFontOfSize:14.0];

    [_dragToHideLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_dragToHideLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dragToHideLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_crossImageView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dragToHideLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_crossImageView attribute:NSLayoutAttributeBottom multiplier:1.f constant:10]];

}

@end