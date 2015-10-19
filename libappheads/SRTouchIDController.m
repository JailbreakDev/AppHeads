#import <SRClasses/SRTouchIDController.h>

@interface SRTouchIDController ()
@property (nonatomic) SRTouchIDAlertItem *alertItem;
@end

@implementation SRTouchIDController
@synthesize monitoring,previouslyMatched,alertItem;

+ (instancetype)sharedController {
    static dispatch_once_t p = 0;

    __strong static id _sharedSelf = nil;

    dispatch_once(&p, ^{
        _sharedSelf = [[self alloc] init];
    });

    return _sharedSelf;
}

-(SBUIBiometricEventMonitor *)monitor {
	return [((BiometricKit *)[objc_getClass("BiometricKit") manager]) delegate];
}

-(void)biometricEventMonitor:(id)monitor handleBiometricEvent:(unsigned)event {
	if (resultBlock) {
		resultBlock(self,(SRTouchIDEvent)event);
	}
}

-(void)startMonitoringWithResultBlock:(void(^)(SRTouchIDController *controller,SRTouchIDEvent event))aResultBlock {
	if (self.isMonitoring) {
		return;
	}
	[self setIsMonitoring:YES];
	resultBlock = aResultBlock;
	SBUIBiometricEventMonitor *monitor = [self monitor];
	if (monitor) {
		[self setDidMatch:[monitor isMatchingEnabled]];
		[monitor addObserver:self];
		[monitor _setMatchingEnabled:YES];
		[monitor _startMatching];
		dispatch_async(dispatch_get_main_queue(),^{
			self.alertItem = [[SRTouchIDAlertItem alloc] initWithTitle:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"AUTHENTICATE"] message:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"AUTHENTICATE_DESCRIPTION"]];
			[self.alertItem showWithDismissBlock:^{
				if (resultBlock) {
					resultBlock(self,1337);
				}
			}];
		});
	}
}

-(void)stopMonitoring {
	if(!self.isMonitoring) {
		return;
	}
	if (resultBlock) {
		resultBlock = nil;
	}
	[self setIsMonitoring:NO];
	SBUIBiometricEventMonitor *monitor = [self monitor];
	if (monitor) {
		[monitor removeObserver:self];
		[monitor _setMatchingEnabled:self.didMatch];
		dispatch_async(dispatch_get_main_queue(),^{
			[self.alertItem dismiss];
		});
	}
}

@end