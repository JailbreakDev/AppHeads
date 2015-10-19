#import "SRTouchIDAlertItem.h"
#import "SRLocalizer.h"

@protocol SBUIBiometricEventMonitorDelegate
@required
-(void)biometricEventMonitor:(id)monitor handleBiometricEvent:(unsigned)event;
@end

@interface SBUIBiometricEventMonitor : NSObject
- (void)addObserver:(id)arg1;
- (void)removeObserver:(id)arg1;
- (void)_startMatching;
- (void)_setMatchingEnabled:(BOOL)arg1;
- (BOOL)isMatchingEnabled;
@end

@interface BiometricKit : NSObject
@property (assign,nonatomic) id delegate;
+(id)manager;
@end

@class SRTouchIDAlertItem;
@interface SRTouchIDController : NSObject <SBUIBiometricEventMonitorDelegate> {
	void (^resultBlock)(SRTouchIDController *controller,SRTouchIDEvent event);
}
@property (nonatomic,getter=isMonitoring,setter=setIsMonitoring:) BOOL monitoring;
@property (nonatomic,getter=didMatch,setter=setDidMatch:) BOOL previouslyMatched;
+(instancetype)sharedController;
-(void)startMonitoringWithResultBlock:(void(^)(SRTouchIDController *controller,SRTouchIDEvent event))resultBlock;
-(void)stopMonitoring;
@end