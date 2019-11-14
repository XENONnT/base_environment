#!/bin/bash

set -e

# git tag (if any), from DeployHQ
TAG=$1
if [ "X$TAG" = "X" ];then
    TAG=development
fi
echo
echo "Building for target \"$TAG\"..."
echo

# DeployHQ puts the checkout in ~/deployhq/
cd ~/deployhq/

# first build the Docker image (minimized)
docker build --no-cache --build-arg XENONnT_TAG=$TAG -t osgvo-xenon-layers .
docker run -it osgvo-xenon-layers bash -c "exit"
sleep 30s
CONT_ID=`docker ps -a | grep osgvo-xenon-layers | sed 's/ .*//'`
echo "Exporting container $CONT_ID as minimal image..."
docker export $CONT_ID | docker import - opensciencegrid/osgvo-xenon:$TAG
docker kill $CONT_ID || true
docker rm $CONT_ID || true

# upload to Docker Hub - OSG will pull from there for the Singularity CVMFS repo
docker push opensciencegrid/osgvo-xenon:$TAG

# development also gets mapped to "latest"
if [ "X$TAG" = "Xdevelopment" ]; then
    docker tag opensciencegrid/osgvo-xenon:$TAG opensciencegrid/osgvo-xenon:latest
    docker push opensciencegrid/osgvo-xenon:latest
fi

