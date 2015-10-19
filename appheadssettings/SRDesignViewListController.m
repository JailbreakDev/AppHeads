#import "SRDesignViewListController.h"

@implementation SRDesignViewListController

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 4) {
		NKOColorPickerView *colorPicker = [[NKOColorPickerView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,400) color:[[SRSettings sharedSettings] borderColor] andDidChangeColorBlock:^(UIColor *color) {
			NSLog(@"COLOR CHANGED");
			[[SRSettings sharedSettings] setBorderColor:color];
		}];
		return colorPicker;
	}
	return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 4) {
		return 400.f;
	}
	return (CGFloat)-1;
}

- (id)specifiers {
	if(_specifiers == nil) {
		NSArray *localizedSpecifiers = [[SRLocalizer sharedLocalizer] localizedSpecifiersForSpecifiers:[self loadSpecifiersFromPlistName:@"DesignViewSettings" target:self] inTable:@"DesignView"];
		[self setTitle:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"DESIGN_SETTINGS" inTable:@"DesignView"]];
		_specifiers = localizedSpecifiers;
	}
	return _specifiers;
}

@end