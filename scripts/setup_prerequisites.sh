#! /usr/bin/env sh

SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"

LOCAL_REPO_DIRECTORY="/usr/local/share/rebornos-labs/xfce-minimal-iso/repo"
ISO_REPO_DIRECTORY="$PROJECT_DIRECTORY"/airootfs/home/rebornos/rebornos-labs/xfce-minimal-iso/repo/

EXTRA_PACKAGES=(
    "$PROJECT_DIRECTORY/local_repo/refresh-mirrors-0.0.18-1-any.pkg.tar.zst"
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
set +o xtrace

echo ""
echo "Updating local repository for ISO Building..."
echo ""
printf "%s\n" "${EXTRA_PACKAGES[@]}" | xargs -d '\n' "$PROJECT_DIRECTORY"/scripts/repo-add.sh

echo ""
echo "(Optional) Specify the path to the RebornOS installer project (named as \"calamares-installer\"). PRESS ENTER TO SKIP..."
echo "Example: /home/john/Downloads/calamares-installer"
echo -n "Path: "
read INSTALLER_DIRECTORY
# Checking if the specified directory exists and if it is named "calamares-installer"
if [ -d "$INSTALLER_DIRECTORY" ] && [ "$(basename "$INSTALLER_DIRECTORY")" == "calamares-installer" ]; then
    ISO_INSTALLER_DIRECTORY="$PROJECT_DIRECTORY/airootfs/home/rebornos/calamares-installer"
    sudo mkdir -p "$ISO_INSTALLER_DIRECTORY"
    echo "Copying the installer files to $ISO_INSTALLER_DIRECTORY..."
    sudo rsync -abviuP --filter='dir-merge,-n /.gitignore' "$INSTALLER_DIRECTORY" "$(dirname -- "$ISO_INSTALLER_DIRECTORY")"

    echo "Removing old installer packages from the local repo and adding new ones if they exist..."
    if ls "$INSTALLER_DIRECTORY/calamares-branding/scripts/packaging/"*.pkg* > /dev/null 2>&1;then
        "$PROJECT_DIRECTORY"/scripts/repo-remove.sh "calamares-branding"
        BRANDING_PACKAGE="$(ls -t "$INSTALLER_DIRECTORY/calamares-branding/scripts/packaging/"*.pkg* | head -n 1)"
        "$PROJECT_DIRECTORY"/scripts/repo-add.sh "$BRANDING_PACKAGE"
    fi
    if ls "$INSTALLER_DIRECTORY/calamares-configuration/scripts/packaging/"*.pkg* > /dev/null 2>&1;then
        "$PROJECT_DIRECTORY"/scripts/repo-remove.sh "calamares-configuration"
        CONFIGURATION_PACKAGE="$(ls -t "$INSTALLER_DIRECTORY/calamares-configuration/scripts/packaging/"*.pkg* | head -n 1)"
        "$PROJECT_DIRECTORY"/scripts/repo-add.sh "$CONFIGURATION_PACKAGE"
    fi
    if ls "$INSTALLER_DIRECTORY/calamares-core/scripts/packaging/"*.pkg* > /dev/null 2>&1;then
        "$PROJECT_DIRECTORY"/scripts/repo-remove.sh "calamares-core"
        CORE_PACKAGE="$(ls -t "$INSTALLER_DIRECTORY/calamares-core/scripts/packaging/"*.pkg* | head -n 1)"
        "$PROJECT_DIRECTORY"/scripts/repo-add.sh "$CORE_PACKAGE"
    fi
else
    echo "Skipping the installer... If you entered a path, check if the directory exists and if it is named \"calamares-installer\""
fi
echo ""

echo "Adding or removing Calamares packages automatically depending on whether they are found..."
validate_package_and_edit_list() {
    PACKAGE_NAME="$1"

    sudo pacman --config "$PROJECT_DIRECTORY/pacman.conf" -Syp "$PACKAGE_NAME"
    PACKAGE_MISSING="$?"
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

validate_package_and_edit_list "calamares-branding"
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
