#! /usr/bin/env sh

SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"

echo "Installing prerequisites if needed. Ignore any warnings..."
echo ""
set -o xtrace
sudo pacman -S --needed "$@" archiso git git-lfs rsync
set +o xtrace

echo "Pulling LFS files..."
echo ""
set -o xtrace
git lfs pull
set +o xtrace

echo "Synchronizing local repository..."
echo ""
set -o xtrace
sudo mkdir -p /usr/local/share/rebornos-labs/xfce-minimal-iso/repo/
sudo rsync -abviuP local_repo/ /usr/local/share/rebornos-labs/xfce-minimal-iso/repo/
set +o xtrace