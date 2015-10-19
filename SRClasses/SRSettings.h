#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import "../Headers.h"

#define NotificationName "com.sharedroutine.appheads.settings-changed"

@interface SRSettings : NSObject
@property (nonatomic,readonly) BOOL isTweakEnabled;
@property (nonatomic,readonly) BOOL excludeMailApp;
@property (nonatomic,readonly) BOOL hideDuringVideos;
@property (nonatomic,readonly) CHSnappingEdge snappingEdge;
@property (nonatomic,readonly) NSInteger singleTapAction;
@property (nonatomic,readonly) NSInteger holdAction;
@property (nonatomic,readonly) NSInteger doubleTapAction;
@property (nonatomic,readonly) NSInteger backgroundView;
@property (nonatomic,readonly) CGFloat cornerRadius;
@property (nonatomic,readonly) CGFloat viewSize;
@property (nonatomic,readonly) CGFloat headSize;
@property (nonatomic,readonly) CGFloat doubleTapInterval;
@property (nonatomic,readonly) CGFloat borderWidth;
@property (nonatomic,readonly) BOOL enabledForAllApps;
@property (nonatomic,readonly) NSArray *touchIDEnabledApps;
@property (nonatomic,readonly) NSArray *enabledApps;
@property (nonatomic,readonly) BOOL allowInLockscreen;
@property (nonatomic,readonly) NSInteger allowedAppHeadsCount;
@property (nonatomic,readonly) BOOL limitAppHeads;
@property (nonatomic,readonly) BOOL useBioLockDown;
@property (nonatomic,readonly) SRAppHeadsDisplayMode displayMode; 
@property (nonatomic,readonly) NSArray *killallWhiteList;
@property (nonatomic,readonly,getter=suppressKilledApps) BOOL suppressRecentlyKilledApps;
@property (nonatomic,readonly,getter=wantsTouchIDConfirmation) BOOL touchID;
@property (nonatomic,getter=isInHiddenMode,setter=setIsInHiddenMode:) BOOL hiddenMode;
@property (nonatomic,getter=isInHostingMode,setter=setIsInHostingMode:) BOOL hostingMode;
@property (nonatomic,readonly,getter=isOrientationLocked) BOOL orientationLocked; 
@property (nonatomic,copy) NSMutableDictionary *edgePoints;
@property (nonatomic,copy) UIColor *borderColor;
+(instancetype)sharedSettings;
-(void)restoreDefaults;
@end