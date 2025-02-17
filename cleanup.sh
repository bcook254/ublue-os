#!/usr/bin/bash

set -eoux pipefail
shopt -s extglob

rm -rf /tmp/* || true
find /var/lib /var/cache -maxdepth 1 -mindepth 1 ! -wholename /var/lib/alternatives ! -wholename /var/cache/rpm-ostree -type d -exec rm -rv {} +
find /var -maxdepth 1 -mindepth 1 ! -wholename /var/lib ! -wholename /var/cache -type d -exec rm -rv {} +
