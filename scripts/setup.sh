#! /usr/bin/env sh

SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"

echo "Script directory: $SCRIPT_DIRECTORY"
echo "Project directory: $PROJECT_DIRECTORY"

echo ""
echo "Installing prerequisites if needed. Ignore any warnings..."
echo ""
set -o xtrace
sudo pacman -S --needed "$@" archiso git git-lfs rsync
git lfs install
set +o xtrace

echo ""
echo "Pulling LFS files..."
echo ""
set -o xtrace
git lfs pull
set +o xtrace

echo ""
echo "Synchronizing local repository..."
echo ""
set -o xtrace
sudo mkdir -p /usr/local/share/rebornos-labs/xfce-minimal-iso/repo/
sudo rsync -abviuP "$PROJECT_DIRECTORY"/local_repo/ /usr/local/share/rebornos-labs/xfce-minimal-iso/repo/
set +o xtrace

echo ""
echo "Copying mirrorlists..."
echo ""
set -o xtrace
cp -f /etc/pacman.d/reborn-mirrorlist "$PROJECT_DIRECTORY"/airootfs/etc/pacman.d/
cp -f /etc/pacman.d/mirrorlist "$PROJECT_DIRECTORY"/airootfs/etc/pacman.d/
set +o xtrace

echo ""
echo "Copying package databases..."
echo ""
set -o xtrace
mkdir -p "$PROJECT_DIRECTORY"/airootfs/var/lib/pacman/sync/
sudo pacman -Syy
rsync -abviuP /var/lib/pacman/sync/ "$PROJECT_DIRECTORY"/airootfs/var/lib/pacman/sync/
set +o xtrace
