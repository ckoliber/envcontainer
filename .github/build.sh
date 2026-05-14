#!/usr/bin/env bash
set -e

VERSION=$(git cliff --unreleased --bumped-version)
if [ "$CI_COMMIT_REF_PROTECTED" != "true" ]; then
  VERSION=$VERSION-build.$(git rev-parse --short HEAD)
fi

BUILDX=docker-cli-plugin-docker-buildx
$BUILDX use buildkit 2>/dev/null || $BUILDX create --use --name buildkit --driver docker-container
$BUILDX build -t $GHCR_IMAGE:$VERSION -t $DOCKER_IMAGE:$VERSION --platform linux/amd64,linux/arm64 --push .
