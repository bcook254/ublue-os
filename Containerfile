ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-silverblue}"
ARG IMAGE_FLAVOR="${IMAGE_FLAVOR:--surface}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-${BASE_IMAGE_NAME}${IMAGE_FLAVOR}}"
ARG BASE_IMAGE="ghcr.io/ublue-os/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS personal
ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"

COPY install.sh personal-packages.json personal-packages.sh workarounds.sh github-release-install.sh /tmp/

RUN /tmp/install.sh

RUN /tmp/workarounds.sh

# Cleanup everything we don't need
RUN rm -rf /tmp/* /var/* && \    
    ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /tmp /var/tmp
