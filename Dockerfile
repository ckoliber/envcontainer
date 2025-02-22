FROM docker:27.5.1-dind

RUN mkdir -p /workspaces
RUN apk add --no-cache npm curl && \
    npm install -g @devcontainers/cli

VOLUME /root
VOLUME /workspaces
VOLUME /var/lib/docker

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
