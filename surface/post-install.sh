#!/usr/bin/bash

set -oeux pipefail

if grep -q "silverblue" <<< "${IMAGE_NAME}"; then
    systemctl enable dconf-update
fi
systemctl enable fprintd
systemctl enable surface-hardware-setup
