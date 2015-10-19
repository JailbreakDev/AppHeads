#import "SRAppHeadsWindow.h"

@implementation SRAppHeadsWindow

+(BOOL)_isSecure {
	return YES;
}

-(BOOL)_isSecure {
	return YES;
}

-(instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self) {
		[self setRootViewController:[[SRAppHeadsViewController alloc] init]];
		[self setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.0f]];
	}

	return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *superView = [super hitTest:point withEvent:event];
    if (![superView isKindOfClass:[SRAppHeadsWindow class]]) {
        return superView;
    }
    return nil;
}

@end