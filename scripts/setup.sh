#! /usr/bin/env sh

SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"

echo "Installing prerequisites if needed. Ignore any warnings..."
echo ""
set -o xtrace
sudo pacman -S --needed "$@" archiso
set +o xtrace