#!/bin/sh
set -e

mkdir -p "$HOME" /workspace

if [ -n "$DOT_URL" ]; then
    [ -d "$HOME/.git" ] || git clone $DOT_URL $HOME/dotfiles ; mv $HOME/dotfiles/.git $HOME ; rm -Rf $HOME/dotfiles
    git -C $HOME remote set-url origin $DOT_URL
    git -C $HOME reset --hard HEAD
    git -C $HOME pull
fi

if [ -n "$GIT_URL" ]; then
    [ -d "/workspace/.git" ] || git clone $GIT_URL /workspace
    git -C /workspace remote set-url origin $GIT_URL
    git -C /workspace reset --hard HEAD
    git -C /workspace pull
fi

(sleep 10 && devcontainer up --workspace-folder /workspace) &

exec /usr/local/bin/dockerd-entrypoint.sh "$@"
