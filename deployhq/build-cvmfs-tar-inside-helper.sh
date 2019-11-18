#!/bin/bash

# Runs inside a Docker container to create the CVMFS tarball

set -e

TAG=$1
TARGET_DIR=/cvmfs/xenon.opensciencegrid.org/releases/nT

cd /srv
./create-env $TARGET_DIR/$TAG $TAG

# create a separate cvmfs catalog
touch $TARGET_DIR/$TAG/.cvmfscatalog

# now tar it up into the work dir
cd $TARGET_DIR
tar czf /srv/generated/$TAG.tar.gz $TAG

echo
echo "Tarball generated:"
cd /srv
ls -lh generated/$TAG.tar.gz
echo

