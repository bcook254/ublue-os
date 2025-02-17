#!/usr/bin/bash

set -oeux pipefail

# https://tim.siosm.fr/blog/2023/12/22/dont-change-defaut-login-shell/
rm -f /usr/bin/chsh /usr/bin/lchsh

# run any pre-install scripts for image variants
if [ -f "/ctx/${IMAGE_VARIANT}/pre-install.sh" ]; then
    "/ctx/${IMAGE_VARIANT}/pre-install.sh"
fi
