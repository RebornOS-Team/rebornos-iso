# RebornOS ISO

![GitHub](https://img.shields.io/github/license/rebornos-developers/rebornos-iso)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/rebornos-developers/rebornos-iso)
[![Release](https://github.com/RebornOS-Developers/rebornos-iso/actions/workflows/release.yml/badge.svg)](https://github.com/RebornOS-Developers/rebornos-iso/actions/workflows/release.yml)
[![Pre-Release](https://github.com/RebornOS-Developers/rebornos-iso/actions/workflows/pre_release.yml/badge.svg)](https://github.com/RebornOS-Developers/rebornos-iso/actions/workflows/pre_release.yml)

The official RebornOS ISO source.

> **Note**: The script for setting up prerequisites will only build on *Arch Linux* and its derivatives (i.e. on distributions that use `pacman`, and the Arch Linux package repositories)

The upstream is [the releng config of archiso](https://gitlab.archlinux.org/archlinux/archiso/-/tree/master/configs/releng).
This repository has been created using *git subtree*. [Please keep it updated by git merging with latest upstream changes](https://github.com/RebornOS-Developers/rebornos-iso#3-update)

## 1. Cloning

In order to download the source code to your local computer for testing, or for development, you can clone from the remote repository using either SSH, or HTTPS. Below are instructions on how to do so using Gitlab hosted code as remote.

### HTTPS

```bash
git clone https://github.com/RebornOS-Developers/rebornos-iso.git 
```

OR

### SSH

```bash
git clone git@github.com:RebornOS-Developers/rebornos-iso.git
```

## (Optional) Enable local repository
> **Note:** *`file:///var/tmp/local_repo_dir` symlinks to the `local_repo` directory*.

Edit the `pacman.conf` file and uncomment the below lines
```
#[rebornos-iso]
#SigLevel = Optional TrustAll
#Server = file:///var/tmp/local_repo_dir
```

## 2. Build

The below script will build the ISO image (and install any prerequisites). Change to the project directory (`cd rebornos-iso`) and run

```bash
sh scripts/build.sh
```
Check the `output/` directory for the output ISO file.

## 3. Update

To keep this project in sync with the upstream ArchISO Releng configuration, please follow the below steps. Change to the project directory (`cd rebornos-iso`) before continuing...

1. **Fetch changes from the upstream GitLab source**: The below script first clones the [upstream ArchISO](https://gitlab.archlinux.org/archlinux/archiso) to the `archiso` branch (force overwrites it) and then clones the [releng configuration directory](https://gitlab.archlinux.org/archlinux/archiso/-/tree/master/configs/releng) to the `_releng` branch.
```sh
sh scripts/update_releng_branch.sh
```

1. **Merge upstream changes**
```sh
git checkout main

git merge _releng
```

3. **Manually handle merge conflicts**: Follow [this guide for commandline operations](https://www.atlassian.com/git/tutorials/using-branches/merge-conflicts) or [this guide if you are using *Visual Studio Code*](https://code.visualstudio.com/docs/sourcecontrol/overview#_merge-conflicts).

4. **Push updates back to the project**: After all the merge conflicts are handled and you stage all the changes, you are ready to push the updates with `git push`.
