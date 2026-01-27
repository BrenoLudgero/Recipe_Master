#!/bin/bash

git fetch --tags

LATEST_REMOTE_TAG=$(git describe --tags --abbrev=0)

read -p "Enter new version tag (current: $LATEST_REMOTE_TAG): " NEW_TAG

# Deletes the current tag locally and remotely if NEW_TAG matches CURRENT_TAG
if [ "$NEW_TAG" == "$LATEST_REMOTE_TAG" ]; then
    git tag --delete "$LATEST_REMOTE_TAG"
    gh release delete "$LATEST_REMOTE_TAG" -y
fi

git tag "$NEW_TAG"
git push origin "$NEW_TAG"
git checkout "$NEW_TAG"

sudo sh release.sh -m vanilla.yaml

git checkout "main"
