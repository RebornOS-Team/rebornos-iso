#! /usr/bin/env sh

SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"

echo ""
echo "Giving executable permissions to the required scripts..."
echo ""
set -o xtrace
sudo chmod -R +x "$PROJECT_DIRECTORY/scripts"
set +o xtrace

"$SCRIPT_DIRECTORY/_build_inner.sh" 2>&1 | tee -a "$PROJECT_DIRECTORY/output.log"