#!/bin/sh

set -eux

ARCH="$(uname -m)"
VERSION="$(cat ~/version)"
SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"

# Variables used by quick-sharun
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export OUTNAME=Identity-"$VERSION"-anylinux-"$ARCH".AppImage
export DESKTOP=/usr/share/applications/org.gnome.gitlab.YaLTeR.Identity.desktop
export ICON=/usr/share/icons/hicolor/scalable/apps/org.gnome.gitlab.YaLTeR.Identity.svg
export DEPLOY_OPENGL=1
export DEPLOY_GSTREAMER=1
export STARTUPWMCLASS=identity # For Wayland, this is 'org.gnome.gitlab.YaLTeR.Identity', so this needs to be changed in desktop file manually by the user in that case until some potential automatic fix exists for this

# Trace and deploy all files and directories needed for the application (including binaries, libraries and others)
wget --retry-connrefused --tries=30 "$SHARUN" -O ./quick-sharun
chmod +x ./quick-sharun
./quick-sharun /usr/bin/identity

## Set gsettings to save to keyfile, instead to dconf
echo "GSETTINGS_BACKEND=keyfile" >> ./AppDir/.env

# Make the AppImage with uruntime
./quick-sharun --make-appimage

# Prepare the AppImage for release
mkdir -p ./dist
mv -v ./*.AppImage* ./dist
mv -v ~/version     ./dist
