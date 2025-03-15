#!/bin/sh
set -e

DATA="/workspaces/$(basename -s .git "${GIT_URL%%#*}")"
git clone --depth 1 $GIT_URL $DATA
git -C $DATA remote set-url origin $GIT_URL
git -C $DATA reset --hard HEAD
git -C $DATA pull

devcontainer up --docker-path podman --docker-compose-path podman-compose --remove-existing-container --dotfiles-repository "$DOT_URL" --workspace-folder "$DATA"

exec sleep infinity
