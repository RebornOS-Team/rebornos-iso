#! /usr/bin/env sh

# Global defaults
REPO_DIRECTORY="/usr/local/share/rebornos-labs/xfce-minimal-iso/repo"
REPO_NAME="xfce-minimal-iso"
REPO_EXTENSION="db.tar.xz"
BUILD_DIRECTORY="/var/tmp/repo_build"

USER="$(whoami)"
PWD="$(pwd)"
SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"

# Create the repo directory if it does not exist
set -o xtrace
sudo mkdir -p "$REPO_DIRECTORY"
sudo chown -R "$USER" "$REPO_DIRECTORY"
set +o xtrace

# Create and switch to the build directory
set -o xtrace
mkdir -p "$BUILD_DIRECTORY"
cd "$BUILD_DIRECTORY"
set +o xtrace
if [ "$(pwd)" != "$(realpath "$BUILD_DIRECTORY")" ]; then
    echo "Could not create and switch to $BUILD_DIRECTORY. The current directory is $(pwd)"
    exit 1
fi

package_files=""
for package_name in "$@"; do
    if [ -f "$package_name" ]; then
        package_path="$package_name"
        package_name=$(basename "$package_path")
        set -o xtrace
        cp "$package_path" "$REPO_DIRECTORY" \
        && package_files="$package_files "$(ls -t "$REPO_DIRECTORY/$package_name" | head -n 1)
        set +o xtrace
        if [ "$?" -ne 0 ]; then
            set -o xtrace
            rm -f "$REPO_DIRECTORY/$package_name" 
            set +o xtrace 
        fi  
    else       
        set -o xtrace
        GIVEN_VERSION=$(yay -Si "aur/$package_name" | grep "Version" | cut -d ':' -f2 | xargs)
        set +o xtrace
        if ls "$REPO_DIRECTORY/$package_name"*.pkg* > /dev/null 2>&1;then
            set -o xtrace
            REPO_VERSION=$(ls -t "$REPO_DIRECTORY/$package_name"*.pkg* | head -n 1 | sed -rn "s/.*(\/)?$package_name-(.*)-.*\.pkg\..*/\2/p")
            set +o xtrace
            echo "Package: $package_name, AUR: v$GIVEN_VERSION, REPO: v$REPO_VERSION"
        else
            REPO_VERSION="0"
            echo "Package: $package_name, AUR: v$GIVEN_VERSION, REPO: NA"
        fi

        if [ "$GIVEN_VERSION" != "$REPO_VERSION" ]; then                   
            # Build the package and check if the version updates
            # This happens for some git packages like rtl8821ce-dkms-git whose AUR PKGBUILD and query show outdated versions
            set -o xtrace
            yay --getpkgbuild --force "aur/$package_name" \
            && cd "$package_name" \
            && makepkg --force --syncdeps --noconfirm \
            && GIVEN_VERSION=$(ls -t "$package_name"*.pkg* | head -n 1 | sed -rn "s/.*(\/)?$package_name-(.*)-.*\.pkg\..*/\2/p")
            set +o xtrace
            if [ "$GIVEN_VERSION" != "$REPO_VERSION" ]; then
                echo "Package: $package_name, BUILT: v$GIVEN_VERSION, REPO: v$REPO_VERSION"
                set -o xtrace
                cp "$package_name"*.pkg* "$REPO_DIRECTORY" \
                && package_files="$package_files "$(ls -t "$REPO_DIRECTORY/$package_name"*.pkg* | head -n 1)
                set +o xtrace
                if [ "$?" -ne 0 ]; then
                    set -o xtrace
                    rm -f "$REPO_DIRECTORY"/"$package_name-$GIVEN_VERSION"*.pkg*  
                    set +o xtrace
                fi           
            fi
        fi
    fi
done

if [ ! -z "$package_files" ]; then 
    set -o xtrace
    package_files=$(echo "$package_files" | xargs)
    set +o xtrace
    echo "$package_files" | xargs repo-add -R -n "$REPO_DIRECTORY/$REPO_NAME.$REPO_EXTENSION"     

    echo ""
    echo "Packages added:"
    echo "$package_files" | tr ' ' '\n'
    echo ""
else    
    echo ""
    echo "No packages to add..."
    echo ""
fi

cd "$PWD"

