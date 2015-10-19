//
//  BUIAlertView.h
//  Dismiss Block for UIAlertView
//
//  Created by Jack (@sharedRoutine)
//

#import <UIKit/UIKit.h>

//block typedef
typedef void (^BUIAlertViewDismissBlock)(UIAlertView *alertView, NSInteger buttonIndex, NSString *buttonTitle);

//subclass of UIAlertView
@interface BUIAlertView : UIAlertView <UIAlertViewDelegate> {
    BUIAlertViewDismissBlock dismissBlock; //save block temporarily
}
-(void)showWithDismissBlock:(BUIAlertViewDismissBlock)block; //shows alert with dismiss block
@end
