#!/bin/bash

set -e

while getopts c:g: option
do
case "${option}"
in
c) CODE_FOLDER=${OPTARG};;
g) GIT_URL=${OPTARG};;

esac
done

cd $CODE_FOLDER &&

PROJECT_NAME="$(echo "$GIT_URL" | cut -d/ -f5 | cut -d. -f1)" &&

rm -rf $PROJECT_NAME &&

git clone $GIT_URL &&

cd $PROJECT_NAME &&

cp ../app_configs/docker-entrypoint.sh . &&
cp ../app_configs/Dockerfile .