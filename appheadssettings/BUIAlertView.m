//
//  BUIAlertView.m
//  Dismiss Block for UIAlertView
//
//  Created by Jack (@sharedRoutine)
//

//import header file
#import "BUIAlertView.h"

//implementation
@implementation BUIAlertView

//just call the super method
-(void)show {
    [super show];
}

//set delegate to this class' object (self) to be able to execute the block when the alert is dismissed
-(void)showWithDismissBlock:(BUIAlertViewDismissBlock)block {
    self.delegate = self; //set delegate
    dismissBlock = block; //save block for later
    [self show]; //show the alert as usual
}

//delegate
#pragma mark - UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	//call block with button index and button title
    dismissBlock(alertView,buttonIndex,[alertView buttonTitleAtIndex:buttonIndex]);
    dismissBlock = nil; //no retain cycles. thanks to caughtinflux
}
@end
