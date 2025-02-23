FROM docker:28.0.0-dind

RUN mkdir -p /workspaces
RUN apk add --no-cache npm curl && \
    npm install -g @devcontainers/cli

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
