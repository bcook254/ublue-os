ARG SOURCE_NS="${SOURCE_NS:-ghcr.io}"
ARG SOURCE_ORG="${SOURCE_ORG:-ublue-os}"
ARG IMAGE_NAME="${IMAGE_NAME:-base}"
ARG SOURCE_VARIANT="${SOURCE_VARIANT:-main}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-41}"

FROM scratch AS ctx
COPY / /

FROM ${SOURCE_NS}/${SOURCE_ORG}/${IMAGE_NAME}-${SOURCE_VARIANT}:${FEDORA_MAJOR_VERSION} AS main

ARG IMAGE_NAME="${IMAGE_NAME:-base}"
ARG IMAGE_VARIANT="${IMAGE_VARIANT:-main}"
ARG KERNEL_VERSION="${KERNEL_VERSION}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-41}"
ARG RPMFUSION_MIRROR=""

RUN --mount=type=bind,from=ctx,src=/,dst=/ctx \
    /ctx/pre-install.sh && \
    /ctx/install.sh && \
    /ctx/post-install.sh && \
    # Cleanup everything we don't need
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /tmp /var/tmp
