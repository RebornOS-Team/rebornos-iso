#! /usr/bin/env sh

SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"

LOCAL_REPO_DIRECTORY="/usr/local/share/rebornos-labs/xfce-minimal-iso/repo"
ISO_REPO_DIRECTORY="$PROJECT_DIRECTORY"/airootfs/home/rebornos/rebornos-labs/xfce-minimal-iso/repo/
ISO_INSTALLER_DIRECTORY="$PROJECT_DIRECTORY/airootfs/home/rebornos"
RELATIVE_PACKAGE_BUILD_SCRIPT="scripts/build_package.sh"

EXTRA_PACKAGES=(
    "$PROJECT_DIRECTORY/local_repo/refresh-mirrors-0.0.20-1-any.pkg.tar.zst"
    paru-bin
    b43-firmware
    rtl88xxau-aircrack-dkms-git
    rtl8821ce-dkms-git
    ckbcomp
    fastfetch-git
)

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
sudo pacman -Sy archlinux-keyring rebornos-keyring
sudo pacman -S --needed archiso git git-lfs rsync
yay --answerclean None --answerdiff None --answeredit None --answerupgrade None -S --needed paru-bin "$@"
git lfs install
git lfs pull
set +o xtrace

echo ""
echo "Updating local repository for ISO Building..."
echo ""
printf "%s\n" "${EXTRA_PACKAGES[@]}" | xargs -d '\n' "$PROJECT_DIRECTORY"/scripts/repo-add.sh

echo ""
echo "(Optional) Specify the path to the central RebornOS installer project (named as \"calamares-helper\"). PRESS ENTER TO SKIP..."
echo "Example: /home/john/Downloads/calamares-helper"
echo -n "Path: "
read INSTALLER_DIRECTORY
# Checking if the specified directory exists and if it is named "calamares-helper"
if [ -d "$INSTALLER_DIRECTORY" ] && [ "$(basename "$INSTALLER_DIRECTORY")" == "calamares-helper" ]; then
    set -o xtrace
    INSTALLER_DIRECTORY="$(dirname -- "$INSTALLER_DIRECTORY")"
    CALAMARES_INSTALLER_DIRECTORY="$INSTALLER_DIRECTORY/calamares-helper"
    CALAMARES_CONFIGURATION_DIRECTORY="$INSTALLER_DIRECTORY/calamares-configuration"
    CALAMARES_CORE_DIRECTORY="$INSTALLER_DIRECTORY/calamares-core"
    sudo mkdir -p "$ISO_INSTALLER_DIRECTORY"
    set +o xtrace

    echo "Copying the installer files to $ISO_INSTALLER_DIRECTORY..."
    sudo rsync -abviuP --filter='dir-merge,-n /.gitignore' "$INSTALLER_DIRECTORY/calamares-helper" "$ISO_INSTALLER_DIRECTORY"
    if [ -d "$CALAMARES_CONFIGURATION_DIRECTORY" ]; then
        sudo rsync -abviuP --filter='dir-merge,-n /.gitignore' "$CALAMARES_CONFIGURATION_DIRECTORY" "$ISO_INSTALLER_DIRECTORY"
    else
        echo ""
        echo "ERROR: Configuration directory 'calamares-configuration' not found in the parent directory which contains the 'calamares-helper' directory."
        echo "Please verify that you have followed the instructions in the README for the calamares-helper git repository correctly."
        echo ""
        exit 1
    fi
    if [ -d "$CALAMARES_CORE_DIRECTORY" ]; then
        sudo rsync -abviuP --filter='dir-merge,-n /.gitignore' "$CALAMARES_CORE_DIRECTORY" "$ISO_INSTALLER_DIRECTORY"
    else
        echo ""
        echo "ERROR: Core directory 'calamares-core' not found in the parent directory which contains the 'calamares-helper' directory."
        echo "Please verify that you have followed the instructions in the README for the calamares-helper git repository correctly."
        echo ""
        exit 1
    fi

    echo "Removing old installer packages from the local repo and adding new ones if they exist..."

    # if ! ls "$CALAMARES_CONFIGURATION_DIRECTORY/scripts/packaging/"*.pkg* > /dev/null 2>&1;then
    #     echo ""
    #     echo "WARNING: The 'calamares-configuration' project was not built into a package already. Attempting to build..."
    #     echo "" 
    set -o xtrace
    sh "$CALAMARES_CONFIGURATION_DIRECTORY/$RELATIVE_PACKAGE_BUILD_SCRIPT"
    set +o xtrace
    # fi
    set -o xtrace
    "$PROJECT_DIRECTORY"/scripts/repo-remove.sh "calamares-configuration"
    CONFIGURATION_PACKAGE="$(ls -t "$CALAMARES_CONFIGURATION_DIRECTORY/scripts/packaging/"*.pkg* | head -n 1)"
    "$PROJECT_DIRECTORY"/scripts/repo-add.sh "$CONFIGURATION_PACKAGE"
    set +o xtrace

    # if ! ls "$CALAMARES_CORE_DIRECTORY/scripts/packaging/"*.pkg* > /dev/null 2>&1;then
    #     echo ""
    #     echo "WARNING: The 'calamares-core' project was not built into a package already. Attempting to build..."
    #     echo "" 
    set -o xtrace
    sh "$CALAMARES_CORE_DIRECTORY/$RELATIVE_PACKAGE_BUILD_SCRIPT"
    set +o xtrace
    # fi
    set -o xtrace
    "$PROJECT_DIRECTORY"/scripts/repo-remove.sh "calamares-core"
    CORE_PACKAGE="$(ls -t "$CALAMARES_CORE_DIRECTORY/scripts/packaging/"*.pkg* | head -n 1)"
    "$PROJECT_DIRECTORY"/scripts/repo-add.sh "$CORE_PACKAGE"
    set +o xtrace

else
    echo "Skipping the installer... If you entered a path, check if the directory exists and if it is named \"calamares-helper\""
fi
echo ""

echo "Adding or removing Calamares packages automatically depending on whether they are found..."
validate_package_and_edit_list() {
    PACKAGE_NAME="$1"

    set -o xtrace
    sudo pacman --config "$PROJECT_DIRECTORY/pacman.conf" -Syp "$PACKAGE_NAME"
    PACKAGE_MISSING="$?"
    set +o xtrace
    if grep -q "$PACKAGE_NAME" "$PROJECT_DIRECTORY/packages.x86_64"; then    
        if [ "$PACKAGE_MISSING" -ne 0 ]; then
            echo "Removing $PACKAGE_NAME from the package list since it was not found..."
            grep -v "$PACKAGE_NAME" "$PROJECT_DIRECTORY/packages.x86_64" > "/tmp/packages.x86_64" && mv "/tmp/packages.x86_64" "$PROJECT_DIRECTORY/packages.x86_64"
        fi
    elif [ "$PACKAGE_MISSING" -eq 0 ]; then
        echo "Adding $PACKAGE_NAME to the package list..."
        echo "$PACKAGE_NAME" >> "$PROJECT_DIRECTORY/packages.x86_64"
    fi 
}

validate_package_and_edit_list "calamares-configuration"
validate_package_and_edit_list "calamares-core"

echo ""
echo "Updating local ISO package repository for Calamares..."
echo ""
set -o xtrace
sudo mkdir -p "$ISO_REPO_DIRECTORY"
sudo rsync -abviuP "$LOCAL_REPO_DIRECTORY" "$(dirname -- "$ISO_REPO_DIRECTORY")"
set +o xtrace

echo ""
echo "Copying mirrorlists..."
echo ""
set -o xtrace
cp -f /etc/pacman.d/reborn-mirrorlist "$PROJECT_DIRECTORY"/airootfs/etc/pacman.d/
cp -f /etc/pacman.d/mirrorlist "$PROJECT_DIRECTORY"/airootfs/etc/pacman.d/
set +o xtrace
