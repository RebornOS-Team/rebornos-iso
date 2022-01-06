#! /usr/bin/env sh

SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"
WORK_DIRECTORY=/var/tmp/archiso
OUTPUT_DIRECTORY="$PROJECT_DIRECTORY"/output

set -o xtrace

# Install prerequisites
sh "$SCRIPT_DIRECTORY"/setup.sh

# Create directories if they don't exist already
mkdir -p "$WORK_DIRECTORY"
mkdir -p "$OUTPUT_DIRECTORY"

# Build the ISO image
sudo mkarchiso -w "$WORK_DIRECTORY" -o "$OUTPUT_DIRECTORY" "$@" "$PROJECT_DIRECTORY"

set +o xtrace