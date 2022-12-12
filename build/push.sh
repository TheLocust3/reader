#! /bin/bash

export VERSION=${1:-latest}

echo "Pushing to ${CONTROL_PLANE_IP} @ $VERSION"

export IMAGE="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/reader:$VERSION"
export UI_IMAGE="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/reader_ui:$VERSION"
export IMAGE_POLICY="IfNotPresent"
export HOST="reader.jakekinsella.com"

rm -rf tmp/
mkdir -p tmp/build/cluster/

for f in build/cluster/*.yaml; do envsubst < $f > tmp/$f; done

ssh ubuntu@"${CONTROL_PLANE_IP}" "mkdir ~/cluster/"

scp -r secrets.env ubuntu@"${CONTROL_PLANE_IP}":~/secrets.env
scp -r tmp/build/cluster/* ubuntu@"${CONTROL_PLANE_IP}":~/cluster/
