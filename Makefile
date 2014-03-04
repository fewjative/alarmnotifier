ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = AlarmNotifier
AlarmNotifier_FILES = Tweak.xm
AlarmNotifier_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += alarmnotifier
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 MobileTimer"

