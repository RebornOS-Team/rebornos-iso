#! /usr/bin/env sh

# This script needs to be owned by root and have permissions 755
# Refer to https://developer-old.gnome.org/NetworkManager/stable/NetworkManager.html for arguments

ACTION="$(echo "$2" | tr "[:upper:]" "[:lower:]")"
if [ "$ACTION" = "up" ]; then
    systemctl start refresh-package-databases.service
fi
