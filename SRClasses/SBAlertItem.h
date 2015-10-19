@interface SBAlertItem : NSObject <UIAlertViewDelegate>
+(SBAlertItemsController *)_alertItemsController;
-(UIAlertView *)alertSheet;
-(UIAlertController *)alertController; //iOS 8
-(void)dismiss;
@end