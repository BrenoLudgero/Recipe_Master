#!/bin/bash

set -e

git fetch --tags

LATEST_REMOTE_TAG=$(git describe --tags --abbrev=0)

read -p "Enter new version tag (current: $LATEST_REMOTE_TAG): " NEW_TAG

if [ -z "$NEW_TAG" ]; then
    echo "No tag entered, aborting."
    exit 1
fi

# If NEW_TAG matches LATEST_REMOTE_TAG, deletes the
# current tag (locally and remotely) and latest release
if [ "$NEW_TAG" = "$LATEST_REMOTE_TAG" ]; then
    git tag --delete "$LATEST_REMOTE_TAG"
    gh release delete "$LATEST_REMOTE_TAG" -y
    git push remote --delete "$LATEST_REMOTE_TAG"
fi

git tag "$NEW_TAG"
git push origin "$NEW_TAG"
git checkout "$NEW_TAG"

sudo bash release.sh -m vanilla.yaml
sudo bash release.sh -m tbc.yaml

git checkout "main"
