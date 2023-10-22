#! /usr/bin/env sh

echo ""
echo "RebornOS ISO Prerequisites Script"
echo "---------------------------------"
echo ""

SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"
ISO_CONFIGURATION_DIRECTORY="$PROJECT_DIRECTORY/configs/releng"
ISO_SYNC_DIRECTORY="$ISO_CONFIGURATION_DIRECTORY/airootfs/var/lib/pacman/sync"

echo "Project Directory: $PROJECT_DIRECTORY"
echo "Script Directory: $SCRIPT_DIRECTORY"

read -t 5 -p "Do you want to skip upgrading your system? (The default option will be selected in 5 seconds) [y/N] : " -n 1 -r
echo ""
if [ "$REPLY" != "Y" ] && [ "$REPLY" != "y" ]; then
    echo ""
    echo "Upgrading your system..."
    echo ""
    set -o xtrace
    sudo pacman -Syyu
    set +o xtrace
fi

echo ""
echo "Installing prerequisites if needed. Ignore any warnings..."
echo ""
set -o xtrace
sudo pacman -S --noconfirm archlinux-keyring rebornos-keyring
sudo pacman -S --noconfirm --needed archiso refresh-mirrors # wget rsync git git-lfs
# git lfs install
# git lfs pull
set +o xtrace

read -t 5 -p "Do you want to skip refreshing mirrors? (The default option will be selected in 5 seconds) [y/N] : " -n 1 -r
echo ""
if [ "$REPLY" != "Y" ] && [ "$REPLY" != "y" ]; then
    echo ""
    echo "Refreshing mirrors..."
    echo ""
    set -o xtrace
    sudo refresh-mirrors
    set +o xtrace
fi

echo ""
echo "Copying mirrorlists and databases..."
echo ""
set -o xtrace
cp -f /etc/pacman.d/reborn-mirrorlist "$ISO_CONFIGURATION_DIRECTORY"/airootfs/etc/pacman.d/
cp -f /etc/pacman.d/mirrorlist "$ISO_CONFIGURATION_DIRECTORY"/airootfs/etc/pacman.d/
mkdir -p "$ISO_SYNC_DIRECTORY" \
    && {
        cp -f /var/lib/pacman/sync/core.db "$ISO_SYNC_DIRECTORY"/core.db
        cp -f /var/lib/pacman/sync/core.db "$ISO_SYNC_DIRECTORY"/core.db
        cp -f /var/lib/pacman/sync/core.db "$ISO_SYNC_DIRECTORY"/core.db
    }
set +o xtrace
