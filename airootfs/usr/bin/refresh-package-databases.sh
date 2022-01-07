#!/usr/bin/env sh

echo ""
echo "Refreshing package databases..."
echo ""
sudo pacman -Syy
echo ""

read -n 1 -s -r -t 10 -p "Press any key to exit..."; exit 0