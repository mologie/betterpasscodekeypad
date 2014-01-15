/**
 * This file is part of BetterPasscodeKeypad
 * Copyright 2014 Oliver Kuckertz <oliver.kuckertz@mologie.de>
 * See COPYING for licensing information.
 */

#import <Preferences/Preferences.h>

@interface BetterPasscodeKeypadSettingsListController : PSListController
@end

@implementation BetterPasscodeKeypadSettingsListController

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"BetterPasscodeKeypadSettings" target:self] retain];
	}
	return _specifiers;
}

- (void)visitWebsite:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://cydia.mologie.com/package/com.mologie.betterpasscodekeypad/"]];
}

- (void)sendEmail:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:support+cydia@mologie.com?subject=BetterPasscodeKeypad"]];
}

@end
