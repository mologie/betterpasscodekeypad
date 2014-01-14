BetterPasscodeKeypad
====================

This tweak enhances the passcode keypad by turning off the keypress animations. It thereby makes it a lot harder to see which passcode is being entered.

## Compilation
```sh
git clone https://github.com/mologie/betterpasscodekeypad
cd betterpasscodekeypad
./bootstrap.sh
make
make package
```

## Testing
In order to create a debug build of BetterPasscodeKeypad and install it on your device, run `./install-on-device.sh device-hostname`. OpenSSH is required. For your own sanity, please setup keyless authentication first.

## License
This tweak is licensed under the GPLv3.
