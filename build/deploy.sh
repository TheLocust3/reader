#! /bin/bash

export VERSION=${1:-latest}

echo "Deploying to ${CONTROL_PLANE_IP} @ $VERSION"

./build/push.sh $VERSION

PASSWORD=$(ssh ubuntu@"${CONTROL_PLANE_IP}" "aws ecr get-login-password --region us-east-1")
ssh -A ubuntu@"${CONTROL_PLANE_IP}" "sudo ./ecr_refresh.sh $PASSWORD"
ssh ubuntu@"${CONTROL_PLANE_IP}" "sudo kubectl apply -f ~/cluster/reader/"
