#import "SRLocalizer.h"
#import "SBAlertItem.h"

@interface SRTouchIDAlertItem : SBAlertItem {
	void (^dismissBlock)();
}
@property (nonatomic,copy) NSString *alertTitle;
@property (nonatomic,copy) NSString *alertMessage;
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message;
-(void)showWithDismissBlock:(void(^)())dBlock;
@end