#import <objc/runtime.h>
#include <substrate.h>
#import <notify.h>
#import "SBClasses.h"

#define MAIN_TINTCOLOR [UIColor colorWithRed:(CGFloat)76.0f/255.0f green:(CGFloat)165.0f/255.0f blue:(CGFloat)217.0f/255.0f alpha:1.0f]

//CoreFoundation Numbers
#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_7_1_2
#define kCFCoreFoundationVersionNumber_iOS_7_1_2 847.27
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_0
#define kCFCoreFoundationVersionNumber_iOS_8_0 1140.10
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_1_1
#define kCFCoreFoundationVersionNumber_iOS_8_1_1 1141.18
#endif

#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define CURRENT_INTERFACE_ORIENTATION iPad ? [[UIApplication sharedApplication] statusBarOrientation] : [[UIApplication sharedApplication] activeInterfaceOrientation]

#define iOS8 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0

#define iOS7 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0 \
&& kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_7_1_2

typedef NS_ENUM(NSInteger, CHSnappingEdge) {
    CHSnappingEdgeBoth = 0,
    CHSnappingEdgeRight = 1,
    CHSnappingEdgeLeft = 2
};

typedef NS_ENUM(NSInteger, SRAHVisibilitySource) {
    SRAHVisibilitySourceSpringBoard = 0,
    SRAHVisibilitySourceActivator = 1,
    SRAHVisibilitySourceFlipswitch = 2
};

typedef NS_ENUM(NSInteger, CHInteractionState) {
    CHInteractionStateNormal = 0,
    CHInteractionStateConversation = 1
};

typedef NS_ENUM(NSInteger, SRAppHeadsDisplayMode) {
    SRAppHeadsDisplayModeFree = 1,
    SRAppHeadsDisplayModeLocked = 2
};

typedef NS_ENUM(NSUInteger, SRTouchIDEvent) {
    SRTouchIDEventFingerUp = 0,
    SRTouchIDEventFingerDown = 1,
    SRTouchIDEventFingerHeld = 2,
    SRTouchIDEventMatched = 3,
    SRTouchIDEventNotMatched = 10,
    SRTouchIDEventCancelled = 1337
};