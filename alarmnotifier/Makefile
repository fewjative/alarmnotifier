ARCHS = armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = AlarmNotifier
AlarmNotifier_FILES = AlarmNotifier.mm
AlarmNotifier_INSTALL_PATH = /Library/PreferenceBundles
AlarmNotifier_FRAMEWORKS = UIKit
AlarmNotifier_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AlarmNotifier.plist$(ECHO_END)

include $(THEOS_MAKE_PATH)/aggregate.mk
