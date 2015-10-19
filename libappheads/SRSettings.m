#import <SRClasses/SRSettings.h>
#import <SRClasses/SRNotificationCenter.h>

@interface SRSettings ()
@property (nonatomic,copy) NSDictionary *settings;
@property (nonatomic,readonly) NSArray *bioLockDownApps;
@end

@implementation SRSettings
@synthesize settings = _settings;
@synthesize hiddenMode;
@synthesize hostingMode;
@dynamic isTweakEnabled, excludeMailApp, hideDuringVideos, snappingEdge, singleTapAction, holdAction;
@dynamic doubleTapAction, backgroundView, cornerRadius, viewSize, headSize, doubleTapInterval;
@dynamic borderWidth, enabledForAllApps, touchIDEnabledApps, enabledApps, allowInLockscreen;
@dynamic allowedAppHeadsCount, limitAppHeads, touchID, orientationLocked, displayMode, killallWhiteList;
@dynamic suppressRecentlyKilledApps, borderColor, edgePoints, useBioLockDown;
@synthesize bioLockDownApps = _bioLockDownApps;

+ (instancetype)sharedSettings {
    static dispatch_once_t p = 0;

    __strong static id _sharedSelf = nil;

    dispatch_once(&p, ^{
        _sharedSelf = [[self alloc] init];
    });

    return _sharedSelf;
}

void settingsChanged(CFNotificationCenterRef center,
                           void * observer,
                           CFStringRef name,
                           const void * object,
                           CFDictionaryRef userInfo) {
  	[[SRSettings sharedSettings] updateSettings];
}

-(id)init {

	self = [super init];

	if (self) {
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingsChanged, CFSTR(NotificationName), NULL, CFNotificationSuspensionBehaviorCoalesce);
		[self updateSettings];
	}

	return self;
}

-(void)updateSettings {
	
	_settings = nil;

	CFPreferencesAppSynchronize(CFSTR("com.sharedroutine.appheads"));
	CFStringRef appID = CFSTR("com.sharedroutine.appheads");
    CFArrayRef keyList = CFPreferencesCopyKeyList(appID , kCFPreferencesCurrentUser, kCFPreferencesAnyHost) ?: CFArrayCreate(NULL, NULL, 0, NULL);
    _settings = (__bridge_transfer NSDictionary *)CFPreferencesCopyMultiple(keyList, appID , kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFRelease(keyList);

}

-(void)restoreDefaults {
	_settings = nil;
	CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.sharedroutine.appheads") , kCFPreferencesCurrentUser, kCFPreferencesAnyHost) ?: CFArrayCreate(NULL, NULL, 0, NULL);
	CFPreferencesSetMultiple(CFDictionaryCreate(NULL,NULL,NULL,0,NULL,NULL),keyList,CFSTR("com.sharedroutine.appheads"),kCFPreferencesCurrentUser,kCFPreferencesAnyHost);
	CFPreferencesAppSynchronize(CFSTR("com.sharedroutine.appheads"));
	CFRelease(keyList);
	[self updateSettings];
}

-(BOOL)isTweakEnabled {
	id value = _settings[@"kEnabled"];
	return value ? [value boolValue] : TRUE;
}

-(BOOL)excludeMailApp {
	id value = _settings[@"kExcludeMailApp"];
	return value ? [value boolValue] : TRUE;
}

-(BOOL)hideDuringVideos {
	id value = _settings[@"kHideInVideos"];
	return value ? [value boolValue] : TRUE;
}

-(CHSnappingEdge)snappingEdge {
	id value = _settings[@"kSnappingEdge"];
	return value ? (CHSnappingEdge)[value integerValue] : (CHSnappingEdge)0;
}

-(NSInteger)singleTapAction {
	id value = _settings[@"kSingleTapAction"];
	return value ? [value integerValue] : (NSInteger)1;
}

-(NSInteger)holdAction {
	id value = _settings[@"kHoldAction"];
	return value ? [value integerValue] : (NSInteger)3;
}

-(NSInteger)doubleTapAction {
	id value = _settings[@"kDoubleTapAction"];
	return value ? [value integerValue] : (NSInteger)2;
}

-(CGFloat)doubleTapInterval {
	id value = _settings[@"kDoubleTapInterval"];
	return value ? [value floatValue] : (CGFloat)0.5;
}

-(BOOL)enabledForAllApps {
	id value = _settings[@"kEnabledForAllApps"];
	return value ? [value boolValue] : TRUE;
}

-(NSArray *)enabledApps {
	id value = _settings[@"kEnabledApps"];
	return value ?: @[];
}

-(BOOL)useBioLockDown {
	id value = _settings[@"kUseBioLockDown"];
	return value ? [value boolValue] : FALSE;
}

-(NSArray *)touchIDEnabledApps {
	id value = _settings[@"kTouchIDEnabledApps"]; 
	return value ?: @[];
}

-(BOOL)wantsTouchIDConfirmation {
	id value = _settings[@"kTouchID"];
	return value ? [value boolValue] : FALSE;
}

-(CGFloat)cornerRadius {
	id value = _settings[@"kCornerRadius"];
	return value ? [value floatValue] : 5.0f;
}

-(NSInteger)backgroundView {
	id value = _settings[@"kBackgroundView"];
	return value ? [value integerValue] : (NSInteger)0;
}

-(CGFloat)viewSize {
	id value = _settings[@"kViewSize"];
	return value ? [value floatValue] : (CGFloat)0.86;
}

-(CGFloat)borderWidth {
	id value = _settings[@"kBorderWidth"];
	return value ? [value floatValue] : (CGFloat)1.0;
}

-(CGFloat)headSize {
	id value = _settings[@"kHeadSize"];
	return value ? [value floatValue] : (CGFloat)66.0f;
}

-(UIColor *)borderColor {
	NSData *value = _settings[@"kBorderColor"];
	return value ? (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:value] : [UIColor blackColor];
}

-(void)setBorderColor:(UIColor *)borderColor {
	NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:borderColor];
	CFPreferencesSetAppValue(CFSTR("kBorderColor"),CFBridgingRetain(colorData),CFSTR("com.sharedroutine.appheads"));
	CFPreferencesAppSynchronize(CFSTR("com.sharedroutine.appheads"));
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),CFSTR(NotificationName),NULL,NULL,TRUE);
}

-(NSMutableDictionary *)edgePoints {
	id value = _settings[@"kEdgePoints"];
	return value ? (NSMutableDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:value] : [NSMutableDictionary dictionary];
}

-(void)setEdgePoints:(NSMutableDictionary *)edgePoints {
	NSData *edgePointData = [NSKeyedArchiver archivedDataWithRootObject:edgePoints];
	CFPreferencesSetAppValue(CFSTR("kEdgePoints"),CFBridgingRetain(edgePointData),CFSTR("com.sharedroutine.appheads"));
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),CFSTR(NotificationName),NULL,NULL,TRUE);
}

-(SRAppHeadsDisplayMode)displayMode {
	id value = _settings[@"kDisplayMode"];
	return value ? (SRAppHeadsDisplayMode)[value integerValue] : (SRAppHeadsDisplayMode)1;
}

-(BOOL)allowInLockscreen {
	id value = _settings[@"kAllowInLS"];
	return value ? [value boolValue] : FALSE;
}

-(NSInteger)allowedAppHeadsCount {
	id value = _settings[@"kMaxAppHeads"];
	return value ? [value integerValue] : 10;
}

-(BOOL)limitAppHeads {
	id value = _settings[@"kLimitAppHeads"];
	return value ? [value boolValue] : FALSE;
}

-(BOOL)suppressKilledApps {
	id value = _settings[@"kSuppressRecentlyKilledApps"];
	return value ? [value boolValue] : FALSE;
}

-(NSArray *)killallWhiteList {
	id value = _settings[@"kKillallWhiteList"];
	return value ?: @[];
}

-(BOOL)isOrientationLocked {
	return [[objc_getClass("SBOrientationLockManager") sharedInstance] isLocked];
}

@end