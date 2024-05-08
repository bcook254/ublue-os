#!/bin/bash

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
/tmp/packages.sh /tmp/packages.json

# Install packages directly from GitHub
/tmp/github-release-install.sh smallstep/cli amd64

# Install rbw
# https://github.com/doy/rbw
mkdir /tmp/rbw
curl -sLo /tmp/rbw/rbw_linux_amd64.tar.gz https://github.com/doy/rbw/releases/download/1.9.0/rbw_1.9.0_linux_amd64.tar.gz
tar -C /tmp/rbw -xf /tmp/rbw/rbw_linux_amd64.tar.gz rbw rbw-agent
cp /tmp/rbw/rbw /tmp/rbw/rbw-agent /usr/bin

# Install git-credential-manager
# https://github.com/git-ecosystem/git-credential-manager
mkdir /tmp/gcm
curl -sLo /tmp/gcm/gcm-linux_amd64.tar.gz https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.4.1/gcm-linux_amd64.2.4.1.tar.gz
tar -C /tmp/gcm -xf /tmp/gcm/gcm-linux_amd64.tar.gz
mkdir /usr/lib/gcm
cp /tmp/gcm/git-credential-manager /tmp/gcm/libHarfBuzzSharp.so /tmp/gcm/libSkiaSharp.so /usr/lib/gcm/
