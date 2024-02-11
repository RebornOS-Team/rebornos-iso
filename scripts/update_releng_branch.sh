#! /usr/bin/env sh

SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"

set -o xtrace

INITIAL_BRANCH="$(git branch --show-current)"

(
    cd "$PROJECT_DIRECTORY" \
        && { 
            git remote add upstream "https://gitlab.archlinux.org/archlinux/archiso" \
            || true
        } \
        && git fetch --all \
        && git checkout -B _archiso --track upstream/master \
        && git reset --hard upstream/master \
        && { 
            git branch -D _releng \
            || true
        } \
        && git checkout -b _releng \
        && git rm -rf . \
        && git checkout _archiso -- configs/releng \
        && git checkout _archiso -- archiso/mkarchiso \
        && git checkout _archiso -- LICENSE \
        && git checkout main -- .gitignore \
        && git checkout main -- .gitattributes \
        && git add configs/releng \
        && git add archiso/mkarchiso \
        && git commit -m "Updated from the archiso branch"
)

git checkout -f "$INITIAL_BRANCH"

set +o xtrace