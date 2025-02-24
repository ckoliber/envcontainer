#!/bin/sh
set -e

git_fetch() {
	URL=${1%%#*}
	REF=""; [[ "$1" == *#* ]] && REF="${1##*#}"
	DIR=$2; mkdir -p $DIR

	[ -d "$DIR/.git" ] || (git -C $DIR init && git -C $DIR remote add origin "")
	git -C $DIR remote set-url origin $URL
	git -C $DIR fetch origin $REF
	git -C $DIR switch $REF || git -C $DIR switch master || git -C $DIR switch main
}

DATA="/workspaces/$(basename -s .git "${GIT_URL%%#*}")"
[ -n "$DOT_URL" ] && git_fetch "$DOT_URL" "$HOME"
[ -n "$GIT_URL" ] && git_fetch "$GIT_URL" "$DATA"

devcontainer up --docker-path podman --docker-compose-path podman-compose --remove-existing-container --workspace-folder "$DATA"

exec sleep infinity
