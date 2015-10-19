include theos/makefiles/common.mk

BUNDLE_NAME = AppHeadsSettings
AppHeadsSettings_FILES = $(wildcard *.m) $(wildcard *.mm)
AppHeadsSettings_INSTALL_PATH = /Library/PreferenceBundles
AppHeadsSettings_FRAMEWORKS = UIKit CoreGraphics Social
AppHeadsSettings_PRIVATE_FRAMEWORKS = Preferences
AppHeadsSettings_LDFLAGS = -L$(LIB_DIR)
AppHeadsSettings_LIBRARIES = AppHeads applist
AppHeadsSettings_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AppHeadsSettings.plist$(ECHO_END)
