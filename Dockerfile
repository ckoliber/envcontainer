FROM docker:27.5.1-dind

RUN apk add --no-cache npm curl \
    && npm install -g @devcontainers/cli

RUN mkdir -p /workspaces

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
