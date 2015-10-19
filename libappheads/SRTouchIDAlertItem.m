#import <SRClasses/SRTouchIDAlertItem.h>

@implementation SRTouchIDAlertItem
@synthesize alertTitle,alertMessage;

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
	self = [super init];

	if (self) {
		[self setAlertTitle:title];
		[self setAlertMessage:message];
	}

	return self;
}

- (void)configure:(BOOL)configure requirePasscodeForActions:(BOOL)requirePasscode {

	if (iOS8) {
		[self alertController].title = self.alertTitle ?: @"";
		[self alertController].message = self.alertMessage ?: @"";
		UIAlertAction *cancelAction = [objc_getClass("UIAlertAction") actionWithTitle:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"CANCEL"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                                         if (dismissBlock) {
                                         	dismissBlock();
                                         	dismissBlock = nil;
                                         }
                                     }];
		[[self alertController] addAction:cancelAction];
	} else if (iOS7) {
		[self alertSheet].delegate = self;
		[self alertSheet].title = self.alertTitle ?: @"";
		[self alertSheet].message = self.alertMessage ?: @"";
		[[self alertSheet] addButtonWithTitle:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"CANCEL"]];
	}
}

-(void)showWithDismissBlock:(void(^)())dBlock {
	dismissBlock = dBlock;
	[[objc_getClass("SBAlertItem") _alertItemsController] activateAlertItem:self];
}

#pragma mark - UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (dismissBlock) {
    	dismissBlock();
    	dismissBlock = nil;
    }
}

@end