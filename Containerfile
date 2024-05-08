ARG SOURCE_NS="${SOURCE_NS:-ghcr.io}"
ARG SOURCE_ORG="${SOURCE_ORG:-ublue-os}"
ARG IMAGE_NAME="${IMAGE_IMAGE:-silverblue}"
ARG IMAGE_VARIANT="${IMAGE_VARIANT:-main}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"

FROM ${SOURCE_NS}/${SOURCE_ORG}/${IMAGE_NAME}-${IMAGE_VARIANT}:${FEDORA_MAJOR_VERSION} AS main

ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"
ARG RPMFUSION_MIRROR=""

COPY github-release-install.sh \
     install.sh \
     packages.json \
     packages.sh \
     post-install.sh \
     /tmp/

RUN /tmp/install.sh && \
    /tmp/post-install.sh && \
    # Cleanup everything we don't need
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /tmp /var/tmp
