#!/usr/bin/bash

set -oeux pipefail

# run any pre-install scripts for image variants
if [ -f "/ctx/${IMAGE_VARIANT}/pre-install.sh" ]; then
    "/ctx/${IMAGE_VARIANT}/pre-install.sh"
fi
