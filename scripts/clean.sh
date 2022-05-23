#! /usr/bin/env sh

SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"

LOCAL_REPO_DIRECTORY="/usr/local/share/rebornos-labs/xfce-minimal-iso/repo"
ISO_REPO_DIRECTORY="$PROJECT_DIRECTORY"/airootfs/home/rebornos/rebornos-labs/xfce-minimal-iso/repo/
REPO_BUILD_DIRECTORY="/var/tmp/repo_build"

ISO_INSTALLER_DIRECTORY="$PROJECT_DIRECTORY/airootfs/home/rebornos"
CALAMARES_BRANDING_DIRECTORY="$ISO_INSTALLER_DIRECTORY/calamares-branding"
CALAMARES_CONFIGURATION_DIRECTORY="$ISO_INSTALLER_DIRECTORY/calamares-configuration"
CALAMARES_CORE_DIRECTORY="$ISO_INSTALLER_DIRECTORY/calamares-core"

EXTRA_PACKAGES=(
    "$PROJECT_DIRECTORY/local_repo/refresh-mirrors-0.0.20-1-any.pkg.tar.zst"
    paru-bin
    b43-firmware
    rtl88xxau-aircrack-dkms-git
    rtl8821ce-dkms-git
    ckbcomp
    fastfetch-git
)

echo ""
echo "Removing packages..."
echo ""

set -o xtrace

sudo pacman -R refresh-mirrors
sudo pacman -R paru-bin
sudo pacman -R b43-firmware
sudo pacman -R rtl88xxau-aircrack-dkms-git
sudo pacman -R rtl8821ce-dkms-git
sudo pacman -R ckbcomp
sudo pacman -R fastfetch-git

set +o xtrace

echo ""
echo "Removing files and directories..."
echo ""

set -o xtrace

sudo rm -R "$LOCAL_REPO_DIRECTORY"
sudo rm -R "$ISO_REPO_DIRECTORY"
sudo rm -R "$REPO_BUILD_DIRECTORY"
sudo rm -R "$CALAMARES_BRANDING_DIRECTORY"
sudo rm -R "$CALAMARES_CONFIGURATION_DIRECTORY"
sudo rm -R "$CALAMARES_CORE_DIRECTORY"
sudo rm -R "$ISO_INSTALLER_DIRECTORY/calamares-installer"
sudo rm "/tmp/packages.x86_64"

set +o xtrace
