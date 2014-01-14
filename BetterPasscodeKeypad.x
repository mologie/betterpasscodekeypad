/**
 * BetterPasscodeKeypad - Disables highlighting keypresses on the passcode keypad
 * Copyright 2014 Oliver Kuckertz <oliver.kuckertz@mologie.de>
 * See COPYING for licensing information.
 */

@interface TPRevealingRingView : NSObject
@end

%hook TPRevealingRingView

- (void)setRevealed:(BOOL)revealed animated:(BOOL)animated delay:(double)delay {
	BOOL isKeypadButton = ([self class] == [%c(TPRevealingRingView) class]);
	if (!isKeypadButton) {
		%orig;
	}	
}

%end
