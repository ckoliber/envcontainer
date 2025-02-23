#!/bin/sh
set -e

git_fetch() {
	URL=${1%%#*}
	REF=""; [[ "$1" == *#* ]] && REF="${1##*#}"
	DIR=$2; mkdir -p $DIR

	[ -d "$DIR/.git" ] || git -C $DIR init && git -C $DIR remote add origin ""
	git -C $DIR remote set-url origin $URL
	git -C $DIR fetch origin $REF
	git -C $DIR switch $REF
}

# Fetch git changes
[ -n "$DOT_URL" ] && git_fetch "$DOT_URL" "$HOME"
[ -n "$GIT_URL" ] && git_fetch "$GIT_URL" "/workspaces/$(basename -s .git "${GIT_URL%%#*}")"

# Start Docker daemon
exec /usr/local/bin/dockerd-entrypoint.sh "$@" &

# Wait for Docker to be ready
until docker info >/dev/null 2>&1; do
    echo "Waiting for Docker to be ready..."
    sleep 1
done

devcontainer up --remove-existing-container --workspace-folder "$DATA" && wait
