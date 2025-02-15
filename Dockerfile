FROM docker:27-dind

RUN apk add --no-cache npm curl \
    && npm install -g @devcontainers/cli

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
