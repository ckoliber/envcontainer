FROM alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf

RUN mkdir -p /workspaces
RUN apk add --no-cache npm git curl podman podman-compose && \
    npm install -g @devcontainers/cli

VOLUME ["/var/lib/containers"]

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
