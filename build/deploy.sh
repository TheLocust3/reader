#! /bin/bash

export VERSION=${1:-latest}

echo "Deploying to ${CONTROL_PLANE_IP} @ $VERSION"

./build/push.sh $VERSION

ssh ubuntu@"${CONTROL_PLANE_IP}" "sudo kubectl create secret tls reader-cert --key=/etc/letsencrypt/live/jakekinsella.com/privkey.pem --cert=/etc/letsencrypt/live/jakekinsella.com/fullchain.pem"
ssh ubuntu@"${CONTROL_PLANE_IP}" "sudo kubectl apply -f ~/cluster/"
