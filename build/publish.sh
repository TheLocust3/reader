#! /bin/bash

export VERSION=$(git rev-parse --short HEAD)

echo $VERSION

export ARCH="arm64v8/"

mkdir -p tmp/build/docker/server
mkdir -p tmp/build/docker/ui

envsubst < build/docker/server/Dockerfile > tmp/build/docker/server/Dockerfile
envsubst < build/docker/ui/Dockerfile > tmp/build/docker/ui/Dockerfile

docker buildx build --platform linux/arm64/v8 . -f tmp/build/docker/server/Dockerfile -t "reader-arm:$VERSION"
docker buildx build --platform linux/arm64/v8 . -f tmp/build/docker/ui/Dockerfile -t "reader-ui-arm:$VERSION"

aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
docker tag $(docker images | grep reader-arm | head -n1 | awk '{print $3}') $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/reader:$VERSION
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/reader:$VERSION
docker tag $(docker images | grep reader-ui-arm | head -n1 | awk '{print $3}') $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/reader_ui:$VERSION
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/reader_ui:$VERSION

