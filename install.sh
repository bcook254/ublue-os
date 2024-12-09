#!/usr/bin/bash

set -oeux pipefail

# Install extras fonts
# MesloLGS NF (used for p10k)
mkdir -p /usr/share/fonts/meslolgs-nf
curl --output-dir /usr/share/fonts/meslolgs-nf -sLo "MesloLGS-NF-Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl --output-dir /usr/share/fonts/meslolgs-nf -sLo "MesloLGS-NF-Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
curl --output-dir /usr/share/fonts/meslolgs-nf -sLo "MesloLGS-NF-Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
curl --output-dir /usr/share/fonts/meslolgs-nf -sLo "MesloLGS-NF-Bold-Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache --system-only --really-force --verbose

# Setup packages
/ctx/packages.sh /ctx/packages.json

# Install packages directly from GitHub
/ctx/github-release-install.sh --repository=smallstep/cli --asset-filter=amd64
/ctx/github-release-install.sh --repository=twpayne/chezmoi --asset-filter=x86_64

# Install rbw
# https://github.com/doy/rbw
mkdir /tmp/rbw
curl -sLo /tmp/rbw/rbw_linux_amd64.tar.gz https://github.com/doy/rbw/releases/download/1.12.1/rbw_1.12.1_linux_amd64.tar.gz
tar -C /tmp/rbw -xf /tmp/rbw/rbw_linux_amd64.tar.gz rbw rbw-agent
cp /tmp/rbw/rbw /tmp/rbw/rbw-agent /usr/bin

# Install git-credential-manager
# https://github.com/git-ecosystem/git-credential-manager
mkdir /tmp/gcm
curl -sLo /tmp/gcm/gcm-linux_amd64.tar.gz https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.0/gcm-linux_amd64.2.6.0.tar.gz
tar -C /tmp/gcm -xf /tmp/gcm/gcm-linux_amd64.tar.gz
mkdir /usr/lib/gcm
cp /tmp/gcm/git-credential-manager /tmp/gcm/libHarfBuzzSharp.so /tmp/gcm/libSkiaSharp.so /usr/lib/gcm/

# copy any shared sys files
if [[ -d /ctx/"${IMAGE_VARIANT}"/system_files/shared ]]; then
    rsync -rvK /ctx/"${IMAGE_VARIANT}"/system_files/shared/ /
fi

# copy any spin specific files, eg silverblue
if [[ -d "/ctx/${IMAGE_VARIANT}/system_files/${IMAGE_NAME}" ]]; then
    rsync -rvK "/ctx/${IMAGE_VARIANT}/system_files/${IMAGE_NAME}"/ /
fi

# install any packages from packages.json
if [ -f "/ctx/${IMAGE_VARIANT}/packages.json" ]; then
    /ctx/packages.sh /ctx/"${IMAGE_VARIANT}"/packages.json
fi
