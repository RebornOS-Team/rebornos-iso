#! /usr/bin/env sh

# Maintainer: shivanandvp <shivanandvp.oss@gmail.com, shivanandvp@rebornos.org>

# This script needs to be owned by root and have permissions 755
# Refer to https://developer-old.gnome.org/NetworkManager/stable/NetworkManager.html for arguments

# This script (`refresh-package-databases.sh`) is supposed to run when an
# internet connection is made, starting a custom oneshot systemd service
# (just so that NetworkManager does not stop the script due to timeout).
# That oneshot systemd service `refresh-package-databases.service` runs 
# `pacman -Syy` to force refresh package databases

ACTION="$(echo "$2" | tr "[:upper:]" "[:lower:]")"
if [ "$ACTION" == "up" ]; then
    systemctl start refresh-package-databases.service
fi
