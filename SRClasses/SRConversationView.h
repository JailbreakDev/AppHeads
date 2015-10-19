#import <SRClasses/SRSettings.h>
#import <SRClasses/SRAppHeadsManager.h>

@interface SRConversationView : UIView
-(instancetype)initWithApplication:(SBApplication *)app;
-(void)animateIn;
-(void)animateOutWithCompletion:(void(^)())completionBlock;
-(void)updateSceneVisibility:(BOOL)x;
@end