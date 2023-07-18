#!/bin/bash

set -e

# git branch and tag (if any), from DeployHQ
BRANCH=$1
TAG=$2
if [ "X$TAG" = "X" ];then
    TAG=$BRANCH
fi
if [ "X$TAG" = "Xmaster" ];then
    TAG=development
fi
echo
echo "Building for target \"$TAG\"..."
echo

# DeployHQ puts the checkout in ~/deployhq/
cd ~/deployhq/

# for logs
ls

# for logs, cat the requirements file
cat requirements.txt

# ensure we have the latest base image
docker pull opensciencegrid/osgvo-el7

# build the Docker image (minimized)
docker build --no-cache --network=host --memory 8g --build-arg XENONnT_TAG=$TAG -t osgvo-xenon-layers .
docker run -it osgvo-xenon-layers bash -c "exit"
sleep 30s
CONT_ID=`docker ps -a | grep osgvo-xenon-layers | sed 's/ .*//'`
echo "Exporting container $CONT_ID as minimal image..."
docker export $CONT_ID | docker import - opensciencegrid/osgvo-xenon:$TAG
docker kill $CONT_ID || true
docker rm $CONT_ID || true

# upload to Docker Hub - OSG will pull from there for the Singularity CVMFS repo
docker push opensciencegrid/osgvo-xenon:$TAG

# also to the new xenonnt repo
docker tag opensciencegrid/osgvo-xenon:$TAG xenonnt/base-environment:$TAG
docker push xenonnt/base-environment:$TAG

# development also gets mapped to "latest"
if [ "X$TAG" = "Xdevelopment" ]; then
    docker tag opensciencegrid/osgvo-xenon:$TAG opensciencegrid/osgvo-xenon:latest
    docker push opensciencegrid/osgvo-xenon:latest

    docker tag opensciencegrid/osgvo-xenon:$TAG xenonnt/base-environment:latest
    docker push xenonnt/base-environment:latest
fi

