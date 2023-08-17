# CHANGELOG

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