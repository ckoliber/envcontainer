#!/bin/sh
set -e

DATA=/workspaces/$(basename -s .git "$GIT_URL")

if [ -n "$DOT_URL" ]; then
    [ -d "$HOME/.git" ] || git clone $DOT_URL $HOME/dotfiles ; mv $HOME/dotfiles/.git $HOME ; rm -Rf $HOME/dotfiles
    git -C $HOME remote set-url origin $DOT_URL
    git -C $HOME reset --hard HEAD
    git -C $HOME pull
fi

if [ -n "$GIT_URL" ]; then
    [ -d "$DATA/.git" ] || git clone $GIT_URL $DATA
    git -C $DATA remote set-url origin $GIT_URL
    git -C $DATA reset --hard HEAD
    git -C $DATA pull
fi

# Start Docker daemon
exec /usr/local/bin/dockerd-entrypoint.sh "$@" &

# Wait for Docker to be ready
until docker info >/dev/null 2>&1; do
    echo "Waiting for Docker to be ready..."
    sleep 1
done

devcontainer up --remove-existing-container --workspace-folder "$DATA" && wait
