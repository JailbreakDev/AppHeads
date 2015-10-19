#import <SRClasses/SRLocalizer.h>
#import "SRApplicationListViewController.h"

@implementation SRApplicationListViewController
@synthesize pTableView,pDataSource;

- (id)initForContentSize:(CGSize)aSize {

    if ([[PSViewController class] instancesRespondToSelector:@selector(initForContentSize:)])
		self = [super initForContentSize:aSize];
	else
		self = [super init];
	
    if (self)  {

    	CGRect frame;
		frame.origin = (CGPoint){0, 0};
		frame.size = aSize;
	
		self.pTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];

		BOOL isOS7 = (objc_getClass("UIAttachmentBehavior") != nil);
		if (isOS7) self.pTableView.contentInset = UIEdgeInsetsMake(64.0f, 0.0f, 0.0f, 0.0f);

		self.pDataSource = [[SRApplicationListDataSource alloc] initWithController:self];
		NSNumber *iconSize = [NSNumber numberWithUnsignedInteger:ALApplicationIconSizeSmall];
		NSArray *sectionDescriptors = @[
										@{ALSectionDescriptorTitleKey:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"SYSTEM_APPS"],
										ALSectionDescriptorCellClassNameKey:@"ALSwitchCell",
										ALSectionDescriptorIconSizeKey:iconSize,
										ALSectionDescriptorSuppressHiddenAppsKey:(id)kCFBooleanTrue,
										ALSectionDescriptorPredicateKey:@"(isSystemApplication = TRUE)"},
										@{ALSectionDescriptorTitleKey:[[SRLocalizer sharedLocalizer] localizedStringForKey:@"USER_APPS"],
										ALSectionDescriptorCellClassNameKey:@"ALSwitchCell",
										ALSectionDescriptorIconSizeKey:iconSize,
										ALSectionDescriptorSuppressHiddenAppsKey:(id)kCFBooleanTrue,
										ALSectionDescriptorPredicateKey:@"(isSystemApplication = FALSE)"}
										];
		self.pDataSource.sectionDescriptors = sectionDescriptors;
		[self.pTableView setDataSource:self.pDataSource];
		[self.pTableView setDelegate:self];
		[self.pTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin];

    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.tintColor = MAIN_TINTCOLOR;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.tintColor = nil;
}

- (UIView *)view {
	return self.pTableView;
}

- (UITableView *)table {
    return self.pTableView;
}

- (CGSize)contentSize {
	return [self.pTableView frame].size;
}

- (id)navigationTitle {
    return [[SRLocalizer sharedLocalizer] localizedStringForKey:@"AVAILABLE_APPS"];
}

- (NSString *)title {
    return [[SRLocalizer sharedLocalizer] localizedStringForKey:@"AVAILABLE_APPS"];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath {
    [self.pTableView deselectRowAtIndexPath:aIndexPath animated:YES];
}

-(CFStringRef)stringForApplistControllerID {
	PSSpecifier *spec = [self specifier];
	if ([spec.identifier isEqualToString:@"applist"]) {
		return CFSTR("kEnabledApps");
	} else if ([spec.identifier isEqualToString:@"applist_touchid"]) {
		return CFSTR("kTouchIDEnabledApps");
	} else if ([spec.identifier isEqualToString:@"killall_whitelist"]) {
		return CFSTR("kKillallWhiteList");
	} 
	return CFSTR("");
}

- (void)cellAtIndexPath:(NSIndexPath *)aIndexPath didChangeToValue:(id)aNewValue {

    NSString *identifier = [self.pDataSource displayIdentifierForIndexPath:aIndexPath];
    NSMutableArray *filteredApps = [(__bridge_transfer NSArray *)CFPreferencesCopyAppValue([self stringForApplistControllerID],CFSTR("com.sharedroutine.appheads")) mutableCopy] ?: [NSMutableArray array];
    
    if ([aNewValue boolValue]) {
    	[filteredApps addObject:identifier];
    } else {
    	[filteredApps removeObject:identifier];
    }
    CFPreferencesSetAppValue([self stringForApplistControllerID],(__bridge CFArrayRef)filteredApps,CFSTR("com.sharedroutine.appheads"));
    CFPreferencesAppSynchronize(CFSTR("com.sharedroutine.appheads"));
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.sharedroutine.appheads.settings-changed"), NULL, NULL, YES);
}

- (id)valueForCellAtIndexPath:(NSIndexPath *)aIndexPath {
    NSString *identifier = [self.pDataSource displayIdentifierForIndexPath:aIndexPath];
    NSArray *apps = (__bridge_transfer NSArray *)CFPreferencesCopyAppValue([self stringForApplistControllerID],CFSTR("com.sharedroutine.appheads")) ?: [NSArray array];
    return [NSNumber numberWithBool:[apps containsObject:identifier]];
}

@end

@implementation SRApplicationListDataSource

- (instancetype)initWithController:(SRApplicationListViewController *)aController {
	
	self = [super init];

	if (self) {
		[self setRootController:aController];
	}

	return self;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath {

    ALValueCell *cell = (ALValueCell *)[super tableView:aTableView cellForRowAtIndexPath:aIndexPath];
    if ([cell isKindOfClass:[ALSwitchCell class]]) {
		[cell setDelegate:self];
		[cell loadValue:[self.rootController valueForCellAtIndexPath:aIndexPath]];
    }
    return cell;
}

- (void)valueCell:(ALValueCell *)aValueCell didChangeToValue:(id)aNewValue {
	[self.rootController cellAtIndexPath:[self.tableView indexPathForCell:aValueCell] didChangeToValue:aNewValue];
}

@end