export THEOS_DEVICE_IP = iPhone
export TARGET := iphone:8.3
export THEOS_BUILD_DIR = build
export ARCHS = armv7 arm64
export TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0
export LIB_DIR = $(THEOS_PROJECT_DIR)/$(THEOS_BUILD_DIR)/libappheads/obj/

include theos/makefiles/common.mk

export ADDITIONAL_CFLAGS = -include $(THEOS_PROJECT_DIR)/Headers.h -I$(THEOS_PROJECT_DIR)/

TWEAK_NAME = AppHeads
AppHeads_FILES = Tweak.xm
AppHeads_OBJC_FILES = $(wildcard $(THEOS_PROJECT_DIR)/Classes/*.m) $(wildcard $(THEOS_PROJECT_DIR)/SRClasses/*.m) $(wildcard $(THEOS_PROJECT_DIR)/Classes/SKBounceAnimation/*.m)
AppHeads_FRAMEWORKS = UIKit QuartzCore CoreGraphics CoreMotion AVFoundation MobileCoreServices CoreText CoreTelephony Security
AppHeads_PRIVATE_FRAMEWORKS = SpringBoardServices SpringBoardUI GraphicsServices SystemConfiguration BackBoardServices
AppHeads_LDFLAGS = -L$(THEOS_BUILD_DIR)/libappheads/obj/
AppHeads_LIBRARIES = AppHeads MobileGestalt
AppHeads_CFLAGS = -fobjc-arc

SUBPROJECTS += libappheads
include $(THEOS_MAKE_PATH)/aggregate.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd assertiond SpringBoard"
SUBPROJECTS += appheadssettings
SUBPROJECTS += postrm
SUBPROJECTS += appheadsfs
SUBPROJECTS += actiheads

