#! /usr/bin/env sh

SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"

REPO_DIRECTORY="/usr/local/share/rebornos-labs/xfce-minimal-iso/repo"
REPO_NAME="xfce-minimal-iso"
REPO_EXTENSION="db.tar.xz"

set -o xtrace
repo-remove "$REPO_DIRECTORY/$REPO_NAME.$REPO_EXTENSION" "$@"
set +o xtrace
for package_name in "$@"; do
    set -o xtrace  
    rm -f "$REPO_DIRECTORY/$package_name"*.pkg* 
    set +o xtrace
done

