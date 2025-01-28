#!/bin/bash

# Runs inside a Docker container to create the CVMFS tarball

set -e

TAG=$1
TARGET_DIR=/cvmfs/xenon.opensciencegrid.org/releases/nT
# devtools-9 environment for updated compilers
if [ -e /opt/rh/devtoolset-9/enable ]; then
    source /opt/rh/devtoolset-9/enable
fi
cd /srv
./create-env $TARGET_DIR/$TAG $TAG

# create a separate cvmfs catalog
touch $TARGET_DIR/$TAG/.cvmfscatalog

# now tar it up into the work dir - dereference the hard links
# as cvmfs is not happy about those
cd $TARGET_DIR
tar -cz --hard-dereference -f /srv/generated/$TAG.tar.gz $TAG

echo
echo "Tarball generated:"
cd /srv
ls -lh generated/$TAG.tar.gz
echo

