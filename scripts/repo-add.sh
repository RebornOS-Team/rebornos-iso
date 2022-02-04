#! /usr/bin/env sh

set -o xtrace

# Global defaults
REPO_DIRECTORY="/usr/local/share/rebornos-labs/xfce-minimal-iso/repo"
REPO_NAME="xfce-minimal-iso"
REPO_EXTENSION="db.tar.xz"
BUILD_DIRECTORY="/var/tmp/repo_build"

PWD="$(pwd)"
SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"

package_files=""
for package_name in "$@"; do
    if [ -f "$package_name" ]; then
        package_path="$package_name"
        package_name=$(basename "$package_path")
        cp "$package_path" "$REPO_DIRECTORY" \
        && package_files="$package_files "$(ls -t "$REPO_DIRECTORY/$package_name" | head -n 1)
        if [ "$?" -ne 0 ]; then
            rm -f "$REPO_DIRECTORY/$package_name"  
        fi  
    else
        # Create and switch to the build directory
        mkdir -p "$BUILD_DIRECTORY"
        cd "$BUILD_DIRECTORY"
        if [ "$(pwd)" != "$(realpath "$BUILD_DIRECTORY")" ]; then
            echo "Could not create and switch to $BUILD_DIRECTORY. The current directory is $(pwd)"
            exit 1
        fi

        GIVEN_VERSION=$(yay -Si "aur/$package_name" | grep "Version" | cut -d ':' -f2 | xargs)
        if ls "$REPO_DIRECTORY/$package_name"*.pkg* > /dev/null 2>&1;then
            REPO_VERSION=$(ls -t "$REPO_DIRECTORY/$package_name"*.pkg* | head -n 1 | sed -rn "s/.*(\/)?$package_name-(.*)-.*\.pkg\..*/\2/p")
            echo "Package: $package_name, AUR: v$GIVEN_VERSION, REPO: v$REPO_VERSION"
        else
            REPO_VERSION="0"
            echo "Package: $package_name, AUR: v$GIVEN_VERSION, REPO: NA"
        fi

        if [ "$GIVEN_VERSION" != "$REPO_VERSION" ]; then                   
            # Build the package and check if the version updates
            # This happens for some git packages like rtl8821ce-dkms-git whose AUR PKGBUILD and query show outdated versions
            yay --getpkgbuild --force "aur/$package_name" \
            && cd "$package_name" \
            && makepkg --force --syncdeps \
            && GIVEN_VERSION=$(ls -t "$package_name"*.pkg* | head -n 1 | sed -rn "s/.*(\/)?$package_name-(.*)-.*\.pkg\..*/\2/p")
            if [ "$GIVEN_VERSION" != "$REPO_VERSION" ]; then
                echo "Package: $package_name, BUILT: v$GIVEN_VERSION, REPO: v$REPO_VERSION"
                cp "$package_name"*.pkg* "$REPO_DIRECTORY" \
                && package_files="$package_files "$(ls -t "$REPO_DIRECTORY/$package_name"*.pkg* | head -n 1)
                if [ "$?" -ne 0 ]; then
                    rm -f "$REPO_DIRECTORY"/"$package_name-$GIVEN_VERSION"*.pkg*  
                fi           
            fi
        fi
    fi
done

if [ ! -z "$package_files" ]; then   
    package_files=$(echo "$package_files" | xargs)
    echo "$package_files" | xargs repo-add -R -n "$REPO_DIRECTORY/$REPO_NAME.$REPO_EXTENSION"     

    set +o xtrace

    echo ""
    echo "Packages added:"
    echo "$package_files" | tr ' ' '\n'
    echo ""
else    
    set +o xtrace
    
    echo ""
    echo "No packages to add..."
    echo ""
fi

cd "$PWD"

