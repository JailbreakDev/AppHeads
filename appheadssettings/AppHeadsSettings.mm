#import <Preferences/Preferences.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSwitchTableCell.h>
#import <Preferences/PSSegmentTableCell.h>
#import <SRClasses/SRNotificationCenter.h>
#import <SRClasses/SRSettings.h>
#import <SRClasses/SRLocalizer.h>
#import "SRMainHeaderView.h"
#import "BUIAlertView.h"
#include <spawn.h>

@interface SRListItemsController : PSListItemsController 
@end

@implementation SRListItemsController

-(void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath {
	[super tableView:aTableView didSelectRowAtIndexPath:aIndexPath];
	if ([((PSSpecifier *)[self specifier]).identifier isEqualToString:@"snappingedge"]) {
		NSNumber *edge = [self readPreferenceValue:self.specifier];
		[[SRNotificationCenter defaultCenter] postSnappingEdgeChanged:[edge integerValue]];
	} 
}

@end

@interface AppHeadsSettingsListController : PSListController
@end

@implementation AppHeadsSettingsListController

-(void)setExcludeMailApp:(NSNumber *)aValue forSpecifier:(PSSpecifier *)aSpec {
	[self setPreferenceValue:aValue specifier:aSpec];
	[[NSUserDefaults standardUserDefaults] synchronize];

	if ([aValue intValue] == 0) { //switched off
		[[SRNotificationCenter defaultCenter] postAddMailAppHead];
	} else { //switched off
		[[SRNotificationCenter defaultCenter] postRemoveMailAppHead];
	}
}

-(void)setEnabledForAllApps:(NSNumber *)aValue forSpecifier:(PSSpecifier *)aSpec {
	[self setPreferenceValue:aValue specifier:aSpec];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[((PSSpecifier *)[self specifierForID:@"applist"]) setProperty:([aValue intValue] == 0) ? @YES : @NO forKey:@"enabled"];
	[self reloadSpecifierID:@"applist"];
}

-(void)setTweakEnabled:(NSNumber *)aValue forSpecifier:(PSSpecifier *)aSpec {
	
	PSSpecifier *enabledSpec = [self specifierForID:@"enableSpec"];
	BOOL state = ([aValue intValue] == 1);
	BOOL previousState = [[self readPreferenceValue:enabledSpec] boolValue];

	if (state != previousState) {
		BUIAlertView *av = [[BUIAlertView alloc] initWithTitle:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"RESPRING"] message:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"REQUIRES_RESPRING"] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Respring", nil];
		[av showWithDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex, NSString *buttonTitle) {
  			if (buttonIndex != alertView.cancelButtonIndex) {
  				[self setPreferenceValue:aValue specifier:aSpec];
				BOOL synched = [[NSUserDefaults standardUserDefaults] synchronize];
				if (synched) {
					[self relaunchSpringBoard];
				}
  			} else {
  				[self reloadSpecifier:enabledSpec];
  			}
		}];
	}
}

-(void)setTouchIDEnabled:(NSNumber *)aValue forSpecifier:(PSSpecifier *)aSpec {

	BOOL state = ([aValue intValue] == 1);
	
	if (!state) { //switching off
		[[SRNotificationCenter defaultCenter] postTouchIDConfirmationRequiredWithSuccessHandler:^(void) {
			[self setPreferenceValue:aValue specifier:aSpec];
			[[NSUserDefaults standardUserDefaults] synchronize];
			dispatch_async(dispatch_get_main_queue(),^{
				[(PSSpecifier *)[self specifierForID:@"applist_touchid"] setProperty:@(state) forKey:@"enabled"];
				[(PSSpecifier *)[self specifierForID:@"biolockdown"] setProperty:@(state) forKey:@"enabled"];
				[self reloadSpecifier:[self specifierForID:@"applist_touchid"]];
				[self reloadSpecifier:[self specifierForID:@"biolockdown"]];
			});
		} andFailureBlock:^(void) {
			dispatch_async(dispatch_get_main_queue(),^{
				[self reloadSpecifier:aSpec];
			});
		}];
	} else {
		[self setPreferenceValue:aValue specifier:aSpec];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[(PSSpecifier *)[self specifierForID:@"applist_touchid"] setProperty:@(state) forKey:@"enabled"];
		[(PSSpecifier *)[self specifierForID:@"biolockdown"] setProperty:@(state) forKey:@"enabled"];
		[self reloadSpecifier:[self specifierForID:@"applist_touchid"]];
		[self reloadSpecifier:[self specifierForID:@"biolockdown"]];
	}
	
}

-(void)setDisplayMode:(NSNumber *)aValue forSpecifier:(PSSpecifier *)aSpec {
	
	PSSpecifier *displayModeSpec = [self specifierForID:@"displayModeSpec"];
	NSInteger state = [aValue integerValue];
	NSInteger previousState = [[self readPreferenceValue:displayModeSpec] integerValue];

	if (state != previousState) {
		BUIAlertView *av = [[BUIAlertView alloc] initWithTitle:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"RESPRING"] message:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"REQUIRES_RESPRING"] delegate:nil cancelButtonTitle:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"CANCEL"] otherButtonTitles:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"RESPRING"], nil];
		[av showWithDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex, NSString *buttonTitle) {
  			if (buttonIndex != alertView.cancelButtonIndex) {
  				[self setPreferenceValue:aValue specifier:aSpec];
				BOOL synched = [[NSUserDefaults standardUserDefaults] synchronize];
				if (synched) {
					[self relaunchSpringBoard];
				}
  			} else {
  				[self reloadSpecifier:displayModeSpec];
  			}
		}];
	}
}

-(void)setAction:(NSNumber *)value forSpecifier:(PSSpecifier *)spec {
	[self setPreferenceValue:value specifier:spec];
	[[NSUserDefaults standardUserDefaults] synchronize];

	PSSpecifier *killallWhiteListSpec = [self specifierForID:@"killall_whitelist"];
	[killallWhiteListSpec setProperty:[NSNumber numberWithBool:([value integerValue] == 4)] forKey:@"enabled"];
	[self reloadSpecifier:killallWhiteListSpec];
}

-(void)setLimitAppHeads:(NSNumber *)value forSpecifier:(PSSpecifier *)spec {
	[self setPreferenceValue:value specifier:spec];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	PSSpecifier *limitSpec = [self specifierForID:@"limitappheads"];
	BOOL state = ([value intValue] == 1);
	[limitSpec setProperty:[NSNumber numberWithBool:state] forKey:@"enabled"];
	[self reloadSpecifier:limitSpec];
}

-(void)setHeadSize:(NSNumber *)size forSpecifier:(PSSpecifier *)spec {
	[self setPreferenceValue:size specifier:spec];
	[[NSUserDefaults standardUserDefaults] synchronize];
	notify_post("com.sharedroutine.appheads.headsize-changed");
}

-(void)setDoubleTapInterval:(NSNumber *)interval forSpecifier:(PSSpecifier *)spec {
	[self setPreferenceValue:interval specifier:spec];
	[[NSUserDefaults standardUserDefaults] synchronize];
	notify_post("com.sharedroutine.appheads.doubletapinterval-changed");
}

-(void)relaunchSpringBoard {
	char * const argv[4] = {(char *const)"killall", (char *const)"backboardd", NULL, NULL};
	posix_spawnp(NULL, (char *const)"killall", NULL, NULL, argv, NULL);
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self reloadSpecifiers];
	if (iOS8) {
        self.navigationController.navigationController.navigationBar.tintColor = MAIN_TINTCOLOR;
    } else {
        self.navigationController.navigationBar.tintColor = MAIN_TINTCOLOR;
    }
    [UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = MAIN_TINTCOLOR;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
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
		return [[SRMainHeaderView alloc] init];
	}
	return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return 75.f;
	}
	return (CGFloat)-1;
}

-(BOOL)isActivatorInstalled {
	return [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/libactivator.dylib"];
}

-(void)reloadSpecifiers {
	[super reloadSpecifiers];

	PSSpecifier *footerSpec = [self specifierForID:@"footerspec"];
	[footerSpec setProperty:[NSString stringWithFormat:@"Copyright \u00A9 2014 - 2015 Janosch Hübner"] forKey:@"footerText"];
	[self reloadSpecifier:footerSpec];

	if ([self is64BitDevice]) {
		[(PSSpecifier *)[self specifierForID:@"applist_touchid"] setProperty:[self readPreferenceValue:[self specifierForID:@"touchid"]] forKey:@"enabled"];
		[(PSSpecifier *)[self specifierForID:@"biolockdown"] setProperty:[self readPreferenceValue:[self specifierForID:@"touchid"]] forKey:@"enabled"];
		[self reloadSpecifier:[self specifierForID:@"applist_touchid"]];
		[self reloadSpecifier:[self specifierForID:@"biolockdown"]];
	}
}

-(void)restoreDefaults:(PSSpecifier *)spec {
	BUIAlertView *av = [[BUIAlertView alloc] initWithTitle:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"RESPRING"] message:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"REQUIRES_RESPRING"] delegate:nil cancelButtonTitle:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"CANCEL"] otherButtonTitles:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"RESPRING"], nil];
	[av showWithDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex, NSString *buttonTitle) {
  			if (buttonIndex != alertView.cancelButtonIndex) {
  				[[SRSettings sharedSettings] restoreDefaults];
				[self reloadSpecifiers];
				[self relaunchSpringBoard];
  			} 
	}];
}

-(NSString *)descriptionForTouchID {
	if ([self is64BitDevice]) {
		return @"TOUCHID_DESCRIPTION";
	} 
	return @"ERROR_NO_64BIT";
}

-(BOOL)is64BitDevice {
	size_t size;
    cpu_type_t type;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
	return (type == CPU_TYPE_ARM64);
}

- (id)specifiers {
	if(_specifiers == nil) {
		NSMutableArray *specs = [[self loadSpecifiersFromPlistName:@"AppHeadsSettings" target:self] mutableCopy];
		BOOL foundAppList = FALSE,foundActivator = FALSE,foundTouchID = FALSE, foundTouchIDDescription = FALSE, foundLimitSpec = FALSE, foundWhitelist = FALSE;
		for (PSSpecifier *spec in specs) {
			if ([spec.identifier isEqualToString:@"applist"]) {
				[spec setProperty:[NSNumber numberWithBool:![SRSettings sharedSettings].enabledForAllApps] forKey:@"enabled"];
				foundAppList = TRUE;
			} else if ([spec.identifier isEqualToString:@"activatorsettings"]) {
				[spec setProperty:[NSNumber numberWithBool:[self isActivatorInstalled]] forKey:@"enabled"];
				[spec setProperty:[self isActivatorInstalled] ? @"SHOW_HIDE_ACTION" : @"ACTIVATOR_NOT_INSTALLED" forKey:@"footerText"];
				foundActivator = TRUE;
			} else if ([spec.identifier isEqualToString:@"touchid"]) {
				[spec setProperty:[NSNumber numberWithBool:[self is64BitDevice]] forKey:@"enabled"];
				foundTouchID = TRUE;
			} else if ([spec.identifier isEqualToString:@"touchiddescription"]) {
				[spec setProperty:[self descriptionForTouchID] forKey:@"footerText"];
				foundTouchIDDescription = TRUE;
			} else if ([spec.identifier isEqualToString:@"limitappheads"]) {
				[spec setProperty:[NSNumber numberWithBool:[SRSettings sharedSettings].limitAppHeads] forKey:@"enabled"];
				foundLimitSpec = TRUE;
			} else if ([spec.identifier isEqualToString:@"killall_whitelist"]) {
				NSInteger holdAction = [SRSettings sharedSettings].holdAction;
				NSInteger doubleTapAction = [SRSettings sharedSettings].doubleTapAction;
				BOOL enabled = (holdAction == 4) || (doubleTapAction == 4);
				[spec setProperty:[NSNumber numberWithBool:enabled] forKey:@"enabled"];
				foundWhitelist = TRUE;
			}

			if (foundAppList && foundActivator && foundTouchID && foundTouchIDDescription && foundLimitSpec && foundWhitelist) {
				break;
			}
		}
		[self setTitle:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"APPHEADS_SETTINGS"]];
		_specifiers = [[SRLocalizer sharedLocalizer] localizedSpecifiersForSpecifiers:specs];
	}
	return _specifiers;
}

@end

// vim:ft=objc
