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