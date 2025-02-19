FROM alpine:3.21.3

RUN mkdir -p /workspaces
RUN apk add --no-cache npm git curl shadow podman podman-compose fuse-overlayfs && \
    npm install -g @devcontainers/cli

ADD /containers.conf /etc/containers/containers.conf
RUN sed -e 's|^#mount_program|mount_program|g' \
    -e '/additionalimage.*/a "/var/lib/shared",' \
    -e 's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' \
    /usr/share/containers/storage.conf \
    > /etc/containers/storage.conf
RUN printf '/run/secrets/etc-pki-entitlement:/run/secrets/etc-pki-entitlement\n/run/secrets/rhsm:/run/secrets/rhsm\n' > /etc/containers/mounts.conf
ENV _CONTAINERS_USERNS_CONFIGURED="" BUILDAH_ISOLATION=chroot
RUN mkdir -p /var/lib/shared/overlay-images \
    /var/lib/shared/overlay-layers \
    /var/lib/shared/vfs-images \
    /var/lib/shared/vfs-layers && \
    touch /var/lib/shared/overlay-images/images.lock && \
    touch /var/lib/shared/overlay-layers/layers.lock && \
    touch /var/lib/shared/vfs-images/images.lock && \
    touch /var/lib/shared/vfs-layers/layers.lock

VOLUME /root
VOLUME /workspaces
VOLUME /var/lib/containers

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
