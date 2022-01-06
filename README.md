# RebornOS ISO - Xfce Minimal

EXPERIMENTAL: Please contact shivanandvp@rebornos.org

This upstream is [the official releng config of archiso](https://gitlab.archlinux.org/archlinux/archiso/-/tree/master/configs/releng).
This repository has been created using git subtree. Please keep it updated by git merging with latest upstream changes.

## 1. Cloning

In order to download the source code to your local computer for testing, or for development, you can clone from the remote repository using either SSH, or HTTPS. Below are instructions on how to do so using Gitlab hosted code as remote.

### HTTPS

```bash
git clone https://gitlab.com/rebornos-labs/installer-and-iso/iso/xfce-minimal-iso.git   
```

### SSH

```bash
git clone git@gitlab.com:rebornos-labs/installer-and-iso/iso/xfce-minimal-iso.git
```

## 2. Build

The below script will build the ISO image (and install any prerequisites). You would run something like `cd xfce-minimal-iso` after cloning.

```bash
sh scripts/build.sh
```

## 3. Output

Check the `output/` directory in the project base directory.
