#! /usr/bin/env sh

SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"
WORK_DIRECTORY=/var/tmp/archiso
OUTPUT_DIRECTORY="$PROJECT_DIRECTORY"/output

# Install prerequisites
echo ""
sh "$SCRIPT_DIRECTORY"/setup.sh

# Create directories if they don't exist already
echo ""
echo "Creating necessary directories if they do not exist..."
echo ""
set -o xtrace
mkdir -p "$WORK_DIRECTORY"
mkdir -p "$OUTPUT_DIRECTORY"
set +o xtrace

# Build the ISO image
echo ""
echo "Building the ISO image..."
echo ""
set -o xtrace
sudo mkarchiso -v -w "$WORK_DIRECTORY" -o "$OUTPUT_DIRECTORY" "$@" "$PROJECT_DIRECTORY"
set +o xtrace