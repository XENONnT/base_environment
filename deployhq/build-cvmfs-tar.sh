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

# user the newly created Docker image to build a tarball for CVMFS deployment
mkdir -p generated
chmod 1777 generated
cp ~/deployhq/deployhq/build-cvmfs-tar-inside-helper.sh .
docker run -v `pwd`:/srv -i -t --rm \
       xenonnt/base-environment:$TAG \
       /bin/bash -c "/srv/build-cvmfs-tar-inside-helper.sh $TAG"

scp generated/$TAG.tar.gz deployhq/build-cvmfs-tar-deploy.sh xenon@osg-cvmfs.grid.uchicago.edu:/tmp/
ssh xenon@osg-cvmfs.grid.uchicago.edu "/tmp/build-cvmfs-tar-deploy.sh $TAG"

