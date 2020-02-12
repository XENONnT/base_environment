#!/bin/bash

# Note: this script assumes that the docker image has already been
# built and pushed

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

rm -f xenonnt.simg
singularity build xenonnt.simg docker://opensciencegrid/osgvo-xenon:$TAG

echo
echo "Created simg file:"
ls -l *.simg
echo

# now push
singularity push --allow-unsigned xenonnt.simg library://rynge/default/xenonnt:$TAG

# development also gets mapped to "latest"
if [ "X$TAG" = "Xdevelopment" ]; then
    singularity push --allow-unsigned xenonnt.simg library://rynge/default/xenonnt:latest
fi

