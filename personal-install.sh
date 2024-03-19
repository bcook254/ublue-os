#!/bin/sh

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

INCLUDED_PACKAGES=($(jq -r "[(.all.include | (.all, select(.\"$BASE_IMAGE_NAME\" != null).\"$BASE_IMAGE_NAME\")[]), \
                             (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".include | (.all, select(.\"$BASE_IMAGE_NAME\" != null).\"$BASE_IMAGE_NAME\")[])] \
                             | sort | unique[]" /tmp/personal-packages.json))
EXCLUDED_PACKAGES=($(jq -r "[(.all.exclude | (.all, select(.\"$BASE_IMAGE_NAME\" != null).\"$BASE_IMAGE_NAME\")[]), \
                             (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".exclude | (.all, select(.\"$BASE_IMAGE_NAME\" != null).\"$BASE_IMAGE_NAME\")[])] \
                             | sort | unique[]" /tmp/personal-packages.json))

if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    EXCLUDED_PACKAGES=($(rpm -qa --queryformat='%{NAME} ' ${EXCLUDED_PACKAGES[@]}))

fi

if [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 && "${#EXCLUDED_PACKAGES[@]}" -eq 0 ]]; then
    rpm-ostree install \
        ${INCLUDED_PACKAGES[@]}

elif [[ "${#INCLUDED_PACKAGES[@]}" -eq 0 && "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    rpm-ostree override remove \
        ${EXCLUDED_PACKAGES[@]}

elif [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 && "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    rpm-ostree override remove \
        ${EXCLUDED_PACKAGES[@]} \
        $(printf -- "--install=%s " ${INCLUDED_PACKAGES[@]})

else
    echo "No packages to install."

fi

# Install smallstep step-cli
# https://github.com/smallstep/cli
curl -Lo /tmp/step-cli_amd64.rpm https://dl.smallstep.com/cli/docs-cli-install/latest/step-cli_amd64.rpm
rpm -i /tmp/step-cli_amd64.rpm
/usr/bin/step-cli completion zsh > /usr/share/zsh/site-functions/_step

# Install rbw
# https://github.com/doy/rbw
mkdir /tmp/rbw
curl -Lo /tmp/rbw/rbw_linux_amd64.tar.gz https://github.com/doy/rbw/releases/download/1.9.0/rbw_1.9.0_linux_amd64.tar.gz
tar -C /tmp/rbw -xf /tmp/rbw/rbw_linux_amd64.tar.gz
cp /tmp/rbw/rbw /tmp/rbw/rbw-agent /usr/bin
cp /tmp/rbw/completion/bash /usr/share/bash-completion/completions/rbw
cp /tmp/rbw/completion/zsh /usr/share/zsh/site-functions/_rbw
