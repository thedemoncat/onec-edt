#!/bin/bash
set -xe

export $(grep -v '^#' .env | xargs)

if [ ! -f .env ]; then
    echo "Please, create .env file"
    exit 1
fi

if [ -z "$HASP_SERVER" ]; then
  HASP_SERVER=localhost
fi

IMAGE_NAME=${1:-"ghcr.io/thedemoncat/onec-edt"}

cp onec-client/config/nethasp.ini onec-client/nethasp.ini
sed -i "s/"%HASP_SERVER%"/$HASP_SERVER/" onec-client/nethasp.ini

env=()
while IFS= read -r line || [[ "$line" ]]; do
  env+=("$line")
done < ONEC_VERSION

for ONEC_VERSION in ${env[*]}
do
    # docker build -t  ghcr.io/thedemoncat/onec-full:"$ONEC_VERSION" \
    #     -f onec-client/onec-full/Dockerfile \
    #     --build-arg ONEC_USERNAME="$ONEC_USERNAME" \
    #     --build-arg ONEC_PASSWORD="$ONEC_PASSWORD"  \
    #     --build-arg ONEC_VERSION="$ONEC_VERSION" onec-client/onec-full

    # docker build -t ghcr.io/thedemoncat/onec-client:"$ONEC_VERSION" \
    #     --build-arg ONEC_USERNAME="$ONEC_USERNAME" \
    #     --build-arg ONEC_PASSWORD="$ONEC_PASSWORD"  \
    #     --build-arg ONEC_VERSION="$ONEC_VERSION" onec-client
    
    docker build -t "$IMAGE_NAME":"$ONEC_VERSION" \
        --build-arg ONEC_USERNAME="$ONEC_USERNAME" \
        --build-arg ONEC_PASSWORD="$ONEC_PASSWORD"  \
        --build-arg ONEC_VERSION="$ONEC_VERSION" .

done

rm -f onec-client/nethasp.ini
