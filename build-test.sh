#!/bin/bash

docker container prune -f && docker image prune -f

set -e

TAG=test

# for logs, cat the requirements file
cat $HOME/base_environment/requirements.txt

# ensure we have the latest base image
docker pull opensciencegrid/osgvo-el7

# build the Docker image (minimized)
docker build --no-cache --network=host --build-arg XENONnT_TAG=$TAG -t osgvo-xenon-layers .
docker run -it osgvo-xenon-layers bash -c "exit"
sleep 30s
CONT_ID=`docker ps -a | grep osgvo-xenon-layers | sed 's/ .*//'`
echo "Exporting container $CONT_ID as minimal image..."
docker export $CONT_ID | docker import - opensciencegrid/osgvo-xenon:$TAG
docker kill $CONT_ID || true
docker rm $CONT_ID || true
