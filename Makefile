#
# Makefile for BetterPasscodeKeypad
# http://cydia.mologie.com/package/com.mologie.betterpasscodekeypad/
#

TWEAK_NAME = BetterPasscodeKeypad
BetterPasscodeKeypad_FILES = BetterPasscodeKeypad.x
BetterPasscodeKeypad_FRAMEWORKS = AudioToolbox CoreFoundation

BUNDLE_NAME = BetterPasscodeKeypadSettings
BetterPasscodeKeypadSettings_FILES = BetterPasscodeKeypadSettings.m
BetterPasscodeKeypadSettings_INSTALL_PATH = /Library/PreferenceBundles
BetterPasscodeKeypadSettings_FRAMEWORKS = UIKit
BetterPasscodeKeypadSettings_PRIVATE_FRAMEWORKS = Preferences
BetterPasscodeKeypadSettings_RESOURCE_DIRS = BetterPasscodeKeypadSettings

# Use make DEBUG=1 for building binaries which output logs
DEBUG ?= 0
ifeq ($(DEBUG), 1)
	CFLAGS = -DDEBUG
endif

# Target the iPhone 3GS and all later devices
ARCHS = armv7 armv7s arm64
TARGET_IPHONEOS_DEPLOYMENT_VERSION := 6.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION_arm64 = 7.0

include framework/makefiles/common.mk
include framework/makefiles/bundle.mk
include framework/makefiles/tweak.mk

after-stage::
	$(ECHO_NOTHING)find "$(THEOS_STAGING_DIR)" -iname '*.plist' -exec plutil -convert binary1 "{}" \;$(ECHO_END)
	$(ECHO_NOTHING)find "$(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences" -iname '*.png' -exec /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/pngcrush -q -iphone "{}" "{}.crushed" \; -exec mv "{}.crushed" "{}" \;$(ECHO_END)
