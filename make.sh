#!/bin/bash
set -e

export $(grep -v '^#' .env | xargs)

docker build -t demoncat/onec-full:"$ONEC_VERSION" \
    --build-arg ONEC_USERNAME="$ONEC_USERNAME" \
    --build-arg ONEC_PASSWORD="$ONEC_PASSWORD"  \
    --build-arg VERSION="$ONEC_VERSION" \
    https://github.com/TheDemonCat/onec-full.git

docker build -t demoncat/edt:"$VERSION_EDT"-"$ONEC_VERSION" \
    --build-arg ONEC_USERNAME="$ONEC_USERNAME" \
    --build-arg ONEC_PASSWORD="$ONEC_PASSWORD"  \
    --build-arg ONEC_VERSION="$ONEC_VERSION"  \
    --build-arg VERSION="$VERSION_EDT" .