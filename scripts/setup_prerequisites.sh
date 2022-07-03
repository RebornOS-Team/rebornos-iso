#! /usr/bin/env sh

SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"

echo "Script directory: $SCRIPT_DIRECTORY"
echo "Project directory: $PROJECT_DIRECTORY"

echo ""
echo "Giving executable permissions to the required scripts..."
echo ""
set -o xtrace
sudo chmod -R +x "$PROJECT_DIRECTORY/scripts"
set +o xtrace

echo ""
echo "Installing prerequisites if needed. Ignore any warnings..."
echo ""
set -o xtrace
sudo refresh-mirrors
sudo pacman -Sy archlinux-keyring rebornos-keyring
sudo pacman -Sy --needed archiso wget # rsync git git-lfs
# git lfs install
# git lfs pull
set +o xtrace

echo ""
echo "Copying mirrorlists..."
echo ""
set -o xtrace
cp -f /etc/pacman.d/reborn-mirrorlist "$PROJECT_DIRECTORY"/airootfs/etc/pacman.d/
cp -f /etc/pacman.d/mirrorlist "$PROJECT_DIRECTORY"/airootfs/etc/pacman.d/
set +o xtrace
