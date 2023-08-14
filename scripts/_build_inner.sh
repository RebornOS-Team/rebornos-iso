#! /usr/bin/env sh

echo ""
echo "========================="
echo "RebornOS ISO Build Script"
echo "========================="
echo ""

SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"
ISO_CONFIGURATION_DIRECTORY="$PROJECT_DIRECTORY/configs/releng"
LOCAL_REPO_SOURCE_DIRECTORY="$PROJECT_DIRECTORY/local_repo"
LOCAL_REPO_DESTINATION_DIRECTORY="/var/tmp/local_repo_dir"
WORK_DIRECTORY="/var/tmp/archiso"
OUTPUT_DIRECTORY="$PROJECT_DIRECTORY"/output

echo "Project Directory: $PROJECT_DIRECTORY"
echo "ISO Configuration Directory: $ISO_CONFIGURATION_DIRECTORY"
echo "Script Directory: $SCRIPT_DIRECTORY"
echo "Local Repo Source Directory: $LOCAL_REPO_SOURCE_DIRECTORY"
echo "Local Repo Destination Directory: $LOCAL_REPO_DESTINATION_DIRECTORY"
echo "Working Directory: $WORK_DIRECTORY"
echo "Output Directory: $OUTPUT_DIRECTORY"

echo ""
read -t 5 -p "Do you want to skip setting up prerequisites? (The default option will be selected in 5 seconds) [y/N] : " -n 1 -r
echo ""
if [ "$REPLY" != "Y" ] && [ "$REPLY" != "y" ]; then
    # Install prerequisites
    echo ""
    echo "Running $SCRIPT_DIRECTORY/_setup_prerequisites.sh..."
    echo ""
    sh "$SCRIPT_DIRECTORY"/_setup_prerequisites.sh
fi

echo ""
read -t 5 -p "Do you want to skip clearing the work, output, and local repo directories? (The default option will be selected in 5 seconds) [y/N]: " -n 1 -r
echo ""
if [ "$REPLY" != "Y" ] && [ "$REPLY" != "y" ]; then
    # Clear old directories
    echo ""
    echo "Clearing old directories..."
    echo ""
    set -o xtrace
    sudo rm -r "$WORK_DIRECTORY"
    sudo rm -r "$OUTPUT_DIRECTORY"
    rm -f "$LOCAL_REPO_DESTINATION_DIRECTORY"
    set +o xtrace
fi

# Create directories
echo ""
echo "Creating work, output, and local directories if they do not exist..."
echo ""
set -o xtrace
mkdir -p "$WORK_DIRECTORY"
mkdir -p "$OUTPUT_DIRECTORY"
sudo mkdir -p "/var/tmp"
sudo chmod 777 "/var/tmp"
ln -s "$LOCAL_REPO_SOURCE_DIRECTORY" "$LOCAL_REPO_DESTINATION_DIRECTORY"
set +o xtrace

# Build the ISO image
echo ""
echo "Building the ISO image..."
echo ""
set -o xtrace
sudo bash "$PROJECT_DIRECTORY/archiso/mkarchiso" -v -w "$WORK_DIRECTORY" -o "$OUTPUT_DIRECTORY" "$@" "$ISO_CONFIGURATION_DIRECTORY" # Only works with bash shell
EXIT_CODE="$?"
set +o xtrace
