FROM alpine:3.21.3

RUN mkdir -p /workspaces
RUN apk add --no-cache npm git curl podman podman-compose && \
    npm install -g @devcontainers/cli

VOLUME ["/var/lib/containers"]

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
