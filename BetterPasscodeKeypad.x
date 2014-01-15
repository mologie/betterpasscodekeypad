/**
 * This file is part of BetterPasscodeKeypad
 * Copyright 2014 Oliver Kuckertz <oliver.kuckertz@mologie.de>
 * See COPYING for licensing information.
 */

#import <CoreFoundation/CoreFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define kBPSettingsPlist @"/var/mobile/Library/Preferences/com.mologie.betterpasscodekeypad.plist"

@interface TPRevealingRingView : NSObject
@end

typedef enum _BPAudioFeedback {
	kBPSystemDefaultAudioFeedback,
	kBPAlwaysEnableAudioFeedback,
	kBPAlwaysDisableAudioFeedback
} BPAudioFeedback;

static BOOL settingsKeypadAnimations;
static BOOL settingsHapticFeedback;
static BPAudioFeedback settingsAudioFeedback;

extern void AudioServicesStopSystemSound(SystemSoundID inSystemSoundID);

static void BPLoadSettings()
{
	NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:kBPSettingsPlist];
	settingsKeypadAnimations = [[settings objectForKey:@"KeypadAnimations"] boolValue];
	settingsHapticFeedback = [[settings objectForKey:@"HapticFeedback"] boolValue];
	settingsAudioFeedback = (BPAudioFeedback)[[settings objectForKey:@"AudioFeedback"] intValue];
}

static void BPSettingsChangedNotification(
	CFNotificationCenterRef center,
	void *observer,
	CFStringRef name,
	const void *object,
	CFDictionaryRef userInfo)
{
	BPLoadSettings();
}

static void BPRegisterNotificationObservers()
{
	CFNotificationCenterAddObserver(
		CFNotificationCenterGetDarwinNotifyCenter(),
		NULL,
		BPSettingsChangedNotification,
		CFSTR("com.mologie.betterpasscodekeypad.settingschanged"),
		NULL,
		CFNotificationSuspensionBehaviorDeliverImmediately
		);
}

static void BPApplyHapticFeedback(BOOL startFeedback)
{
	if (startFeedback)
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	else
		AudioServicesStopSystemSound(kSystemSoundID_Vibrate);
}

%hook TPRevealingRingView

- (void)setRevealed:(BOOL)revealed animated:(BOOL)animated delay:(double)delay {
	BOOL isKeypadButton = ([self class] == [%c(TPRevealingRingView) class]);

	if (!isKeypadButton) {
		%orig;
		return;
	}

	if (settingsHapticFeedback) {
		BPApplyHapticFeedback(revealed);
	}

	if (settingsKeypadAnimations) {
		%orig;
	}
}

%end
	
%hook SBUIPasscodeLockViewBase

// The setPlaysKeypadSounds is called once when the keypad is constructed. It performs preheating of the speakers when set to YES. Therefore, the setter is hooked (instead of the getter) in order to avoid delay when playing the first click sound.
- (void)setPlaysKeypadSounds:(BOOL)playsKeypadSounds {
	switch (settingsAudioFeedback) {
	case kBPSystemDefaultAudioFeedback:
		return %orig;
	case kBPAlwaysEnableAudioFeedback:
		return %orig(YES);
	case kBPAlwaysDisableAudioFeedback:
		return %orig(NO);
	default:
		return %orig;
	}
}

%end

%ctor
{
	BPLoadSettings();
	BPRegisterNotificationObservers();
	%init;
}
