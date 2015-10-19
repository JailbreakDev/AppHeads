#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import <SRClasses/SRNotificationCenter.h>
#import <SRClasses/SRSettings.h>

@interface AppHeadsFSSwitch : NSObject <FSSwitchDataSource>
@end

@implementation AppHeadsFSSwitch

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)aSwitchIdentifier {
	return [[SRSettings sharedSettings] isInHiddenMode] ? FSSwitchStateOff : FSSwitchStateOn;
}

- (void)applyState:(FSSwitchState)aNewState forSwitchIdentifier:(NSString *)aSwitchIdentifier {

	switch (aNewState) {
		case FSSwitchStateOn: {
			[[SRSettings sharedSettings] setIsInHiddenMode:FALSE];
			[[SRNotificationCenter defaultCenter] postShowAllAppHeadsFromSource:SRAHVisibilitySourceFlipswitch];
		}
		break;
		case FSSwitchStateOff: {
			[[SRSettings sharedSettings] setIsInHiddenMode:TRUE];
			[[SRNotificationCenter defaultCenter] postHideAllAppHeadsFromSource:SRAHVisibilitySourceFlipswitch];
		}
		break;

		case FSSwitchStateIndeterminate:
		default:
			break;
	}
}

- (NSString *)titleForSwitchIdentifier:(NSString *)aSwitchIdentifier {
	return @"AppHeads";
}

@end