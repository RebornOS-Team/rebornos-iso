# CHANGELOG

## REBORNOS_XFCE_MINIMAL 2022.11.13-x86_64

### Installer:
*For versions*: [ `calamares-core 3.3.0_alpha2_1`, `calamares-configuration 0.1.1` ]
1. Installations with encryption boot successfully now.
2. In the advanced (netinstall) page, big categories (or groups) which are not meant to be selected in whole, can now no longer be selected through a single click. This avoids users unknowingly selecting a group like "Kernels", or "Graphics", thereby unintentionally installing lots of packages that are not meant to be all installed together.
3. The keyboard layout page now displays keys correctly.
4. `initcpiocfg` is enabled in Calamares to add any additional modules to `mkinitcpio.conf` on the target system.
5. The installer is updated to sync with the upstream Calamares to include the latest features and fixes (see changelog on the Calamares Github page).

### Welcome App:
*For version*: [ `rebornos-welcome 0.0.42-2`, `rebornos-iso-welcome 0.0.42-2` ]
1. The ISO's Welcome app is now able to fetch both stable and unstable(git) installer packages (from whenever the RebornOS repo maintainer built it last). The app automatically uninstalls and installs the required packages to avoid package conflicts.
2. If you are an advanced user, you may turn on the "Git Version" switch to use the unstable version of the installer. 
Note: The "Update" switch still decides whether to use local packages or download from the RebornOS repo.
3. Fixes to URLs and Logos.

### Live Medium / ISO:
*For version*: `rebornos_xfce_minimal 2022.11.13-x86_64`
1. The live medium will now be able to open or extract archive files (.zip, ,7z, .gz, .xz, etc.).
2. The ISO is updated to sync with the upstream ArchISO to include the latest features and fixes (see changelog on the ArchISO Gitlab page