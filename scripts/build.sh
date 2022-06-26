#! /usr/bin/env sh

SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"
WORK_DIRECTORY=/var/tmp/archiso
OUTPUT_DIRECTORY="$PROJECT_DIRECTORY"/output

read -t 15 -p "Do you want to setup prerequisites? [Y/n]: " -n 1 -r
echo ""
if [ "$REPLY" == "N" ] || [ "$REPLY" == "n" ]; then
    :
else
    # Install prerequisites
    echo ""
    sh "$SCRIPT_DIRECTORY"/setup_prerequisites.sh
fi

# Clear old directories
echo ""
echo "Clearing old directories..."
echo ""
set -o xtrace
sudo rm -r "$WORK_DIRECTORY"
sudo rm -r "$OUTPUT_DIRECTORY"
set +o xtrace

# Create directories
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
# rsync 
sudo mkarchiso -v -w "$WORK_DIRECTORY" -o "$OUTPUT_DIRECTORY" "$@" "$PROJECT_DIRECTORY"
EXIT_CODE="$?"
set +o xtrace

echo ""

if [ "$EXIT_CODE" -ne 0 ]; then
    read -t 60 -p "\"mkarchiso\" failed. Do you want to try with the Git version? [Y/n]: " -n 1 -r
    echo ""
    if [ "$REPLY" == "N" ] || [ "$REPLY" == "n" ]; then
        exit 1
    else
        set -o xtrace
        (cd "$SCRIPT_DIRECTORY" && wget -O "mkarchiso" "https://gitlab.archlinux.org/archlinux/archiso/-/raw/master/archiso/mkarchiso") \
            && sudo bash "$SCRIPT_DIRECTORY"/mkarchiso -v -w "$WORK_DIRECTORY" -o "$OUTPUT_DIRECTORY" "$@" "$PROJECT_DIRECTORY" # Only works with bash shell
        set +o xtrace
    fi
fi
