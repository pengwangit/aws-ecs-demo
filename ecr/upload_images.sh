#!/bin/bash

set -e

while getopts c:u:t: option
do
case "${option}"
in
c) CODE_PATH=${OPTARG};;
u) URL=${OPTARG};;
t) TAG=${OPTARG};;
esac
done

IMAGE_NAME="$(echo "$URL" | cut -d/ -f2)"

cd $CODE_PATH &&

docker build -t "$IMAGE_NAME" .

LOGIN=$(aws ecr get-login-password | docker login --username AWS --password-stdin "$URL") &&

echo $LOGIN

docker tag "$IMAGE_NAME" "$URL":"$TAG" &&
docker push "$URL":"$TAG" &&

echo "Image is ready to use"