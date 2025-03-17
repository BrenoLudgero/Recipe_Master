#!/bin/bash

git fetch --tags

CURRENT_TAG=$(git describe --tags --abbrev=0)

read -p "Enter new version tag (current: $CURRENT_TAG): " NEW_TAG

# Deletes the current tag locally and remotely if NEW_TAG matches CURRENT_TAG
if [ "$NEW_TAG" == "$CURRENT_TAG" ]; then
    git tag --delete "$CURRENT_TAG"
    git push origin --delete "$CURRENT_TAG"
fi

git tag "$NEW_TAG"
git push origin "$NEW_TAG"
git checkout "$NEW_TAG"

sudo sh release.sh -m vanilla.yaml
sudo sh release.sh -m cataclysm.yaml

git checkout "main"
