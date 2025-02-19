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

devcontainer up --docker-path podman --docker-compose-path podman-compose --remove-existing-container --workspace-folder $DATA

exec sleep infinity
