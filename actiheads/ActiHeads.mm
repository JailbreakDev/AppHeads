#import <libactivator/libactivator.h>
#import <UIKit/UIKit.h>
#import <appheadsfs/FSSwitchPanel.h>
#import <SRClasses/SRSettings.h>
#import <SRClasses/SRNotificationCenter.h>

@interface ActiHeads : NSObject <LAListener>
@end

@implementation ActiHeads

- (NSString *)activator:(LAActivator *)aActivator requiresLocalizedGroupForListenerName:(NSString *)aListenerName {
	return @"AppHeads";
}
- (NSString *)activator:(LAActivator *)aActivator requiresLocalizedTitleForListenerName:(NSString *)aListenerName {
	return @"AppHeads";
}
- (NSString *)activator:(LAActivator *)aActivator requiresLocalizedDescriptionForListenerName:(NSString *)aListenerName {
	return @"Show and Hide AppHeads with an assigned Action";
}

- (void)activator:(LAActivator *)aActivator receiveEvent:(LAEvent *)aEvent {
	if ([[aActivator assignedListenerNamesForEvent:aEvent] containsObject:@"com.sharedroutine.actiheads"]) {
		[aEvent setHandled:YES];
		if ([SRSettings sharedSettings].isInHiddenMode) {
			[[FSSwitchPanel sharedPanel] setState:FSSwitchStateOn forSwitchIdentifier:@"com.sharedroutine.appheadsfs"];
			[[SRNotificationCenter defaultCenter] postShowAllAppHeadsFromSource:SRAHVisibilitySourceActivator];
		} else {
			[[FSSwitchPanel sharedPanel] setState:FSSwitchStateOff forSwitchIdentifier:@"com.sharedroutine.appheadsfs"];
			[[SRNotificationCenter defaultCenter] postHideAllAppHeadsFromSource:SRAHVisibilitySourceActivator];
		}
	}
}

+ (void)load {
	@autoreleasepool {
		if (LASharedActivator.isRunningInsideSpringBoard) {
			[LASharedActivator registerListener:[self new] forName:@"com.sharedroutine.actiheads"];
		}
	}
}

@end