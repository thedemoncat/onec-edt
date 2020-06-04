#!/bin/bash
set -e

FILE=.env
if [[ -f "$FILE" ]]; then
    export $(grep -v '^#' "$FILE" | xargs)
fi

docker build -t demoncat/onec-full \
    --build-arg ONEC_USERNAME="$ONEC_USERNAME" \
    --build-arg ONEC_PASSWORD="$ONEC_PASSWORD"  \
    --build-arg VERSION="$ONEC_VERSION" \
    https://github.com/TheDemonCat/onec-full.git

docker build -t demoncat/edt \
    --build-arg ONEC_USERNAME="$ONEC_USERNAME" \
    --build-arg ONEC_PASSWORD="$ONEC_PASSWORD"  \
    --build-arg ONEC_VERSION="$ONEC_VERSION"  \
    --build-arg VERSION="$VERSION_EDT" .