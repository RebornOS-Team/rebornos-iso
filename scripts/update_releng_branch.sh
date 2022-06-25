#! /usr/bin/env sh

SCRIPT_DIRECTORY="$(dirname -- "$(readlink -f -- "$0")")"
PROJECT_DIRECTORY="$(dirname -- "$SCRIPT_DIRECTORY")"

set -o xtrace

INITIAL_BRANCH="$(git branch --show-current)"

(
    cd "$PROJECT_DIRECTORY" \
    && git fetch --all \
    && {
        git checkout --track origin/archiso \
        || git checkout archiso
    } \
    && {
        git remote add upstream https://gitlab.archlinux.org/archlinux/archiso \
        || {
            git reset --hard upstream/master \
            && git push --force origin archiso \
            && git subtree split --prefix=configs/releng -b releng \
            && git checkout releng \
            && git push --force origin releng
        }
    }    
)

git checkout "$INITIAL_BRANCH"

set +o xtrace