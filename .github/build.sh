#!/usr/bin/env bash
set -e

function get_ref() {
  TYPE="branch"
  if [ "${GITHUB_REF_TYPE:-}" = "tag" ]; then
    TYPE="tag"
  elif [ -n "${CI_COMMIT_TAG:-}" ]; then
    TYPE="tag"
  elif git describe --tags --exact-match >/dev/null 2>&1; then
    TYPE="tag"
  fi

  if [ -n "${GITHUB_REF_NAME:-}" ]; then
    echo "$TYPE/$GITHUB_REF_NAME"
  elif [ -n "${CI_COMMIT_REF_NAME:-}" ]; then
    echo "$TYPE/$CI_COMMIT_REF_NAME"
  else
    echo "$TYPE/$(git symbolic-ref --quiet --short HEAD || git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD)"
  fi
}

function is_tag() {
  [[ "$(get_ref)" =~ ^tag/(.*)$ ]]
}

function is_release() {
  [[ "$(get_ref)" =~ ^branch/(main|master)$ ]]
}

function is_prerelease() {
  [[ "$(get_ref)" =~ ^branch/(alpha|beta|rc|next)$ ]]
}

VERSION=""
if is_tag; then
  VERSION=$(get_ref | sed 's|^tag/||')
elif is_release || is_prerelease; then
  VERSION=$(git cliff --unreleased --bumped-version)
else
  VERSION=$(git cliff --unreleased --bumped-version)-build.$(git rev-parse --short HEAD)
fi

LATEST=""
if is_release || is_prerelease; then
  LATEST="-t $GHCR_IMAGE:latest -t $DOCKER_IMAGE:latest"
fi

BUILDX=docker-cli-plugin-docker-buildx
$BUILDX use buildkit 2>/dev/null || $BUILDX create --use --name buildkit --driver docker-container
$BUILDX build -t $GHCR_IMAGE:$VERSION -t $DOCKER_IMAGE:$VERSION $LATEST --platform linux/amd64,linux/arm64 --push .
