# CHANGELOG

## REBORNOS ISO `2024.07.19` CHANGELOG

### For users

- Update from upstream, bringing new features and bug-fixes.

### For developers

## REBORNOS ISO `2024.03.21` CHANGELOG

### For users

- Change configuration files to use Qt6.
- Fix Grub loopback configuration.
- Update from upstream, bringing new features and bug-fixes.

### For developers

## REBORNOS ISO `2023.12.06` CHANGELOG

### For users

- Enable opening of the Whisker start/launch menu when Super/Start/Windows key is pressed.
- Increase font sizes on the Xfce desktop and on the installer to improve readability on bigger screens.
- Increase icon sizes too.
- Turn off Numlock at boot so that smaller laptop keyboards can type letters by default.
- Fix pacman database sync issues.
- Update from upstream, bringing new features and bug-fixes.

### For developers

- Do not clear the boot, and pacman directories. The `mkarchiso` script is now different from the upstream and any new changes in the future will need to be merged with conflict handling.

## REBORNOS ISO `2023.08.17` CHANGELOG

### For users

- DNS Caching for better internet experience, using `systemd-resolved`.
- Support for more Wireless handware: `rtl8852au`
- Theming for Qt applications (like the installer) fixed with the `QT_QPA_PLATFORMTHEME="qt5ct"` environment variable and a preset Qt5 configuration file in `/home/rebornos/.config/qt5ct/qt5ct.conf`.
- New features and bug fixes from upstream incorporated.

### For developers

- The ISO configuration now resiles in `configs/releng` in line with the upstream directory tree.
- Build scripts revamped with better messages, better formatting, and better prompts.
- Build scripts now additionally log to a text file.
- Build scripts install `refresh-mirrors` for uniformity.
- Partial upgrades removed from the build scripts.
- Bug fixes for executable permissions in build scripts.
- New features and bug fixes from upstream incorporated.
- Updated and faster script to pull upstream changes into a separate `_calamares` branch.
- The `README.md` documentation is updated.

## REBORNOS ISO `2023.01.05` CHANGELOG

### For users

- Loud Beep turned off at boot
 
- Emoji support added through noto-fonts-emoji
 
- Updated with upstream ArchISO for new features and fixes
 
- Updated installer included

- File manager can now see Apple and Android USB devices.

- Bluetooth support added (needed for bluetooth keyboards and mice).

- Pacman databases start out refreshed (you no longer need to run `pacman -Sy`)

### For devs

- Build CI
 
- Revamped and updated documentation

- Xfce is trimmed down

- Removed mirror refresh at boot