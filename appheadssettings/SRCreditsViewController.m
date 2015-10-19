#import "SRCreditsViewController.h"

@implementation SRCreditsViewController

-(void)actionTapped:(id)aSender {

   if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [composeController setInitialText:@"I am using #AppHeads by @sharedRoutine I love it!"];
        [composeController addImage:[UIImage imageWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/PreferenceBundles/AppHeadsSettings.bundle"] pathForResource:@"AppHeads" ofType:@"png"]]];
        
        [self presentViewController:composeController animated:YES completion:nil];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            [composeController dismissViewControllerAnimated:YES completion:Nil];
        };
        composeController.completionHandler = myBlock;
    }
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionTapped:)];

	if (iOS8) {
        self.navigationController.navigationController.navigationBar.tintColor = MAIN_TINTCOLOR;
    } else {
        self.navigationController.navigationBar.tintColor = MAIN_TINTCOLOR;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationItem.rightBarButtonItem = nil;
	if (iOS8) {
        self.navigationController.navigationController.navigationBar.tintColor = nil;
        self.navigationController.navigationController.navigationBar.barTintColor = nil;
    } else {
        self.navigationController.navigationBar.tintColor = nil;
        self.navigationController.navigationBar.barTintColor = nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		UIImage *headerImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/PreferenceBundles/AppHeadsSettings.bundle"] pathForResource:@"credits_header" ofType:@"png"]];
		UIImageView *headerImageView = [[UIImageView alloc] initWithImage:headerImage];
		return (UIView *)headerImageView;
	}
	return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return 164.f;
	}
	return (CGFloat)-1;
}

- (id)specifiers {
	if(_specifiers == nil) {
		NSArray *specs = [self loadSpecifiersFromPlistName:@"Credits" target:self];
		[self setTitle:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"DEV_AND_DESIGNER"]];
		_specifiers = specs;
	}
	return _specifiers;
}

@end