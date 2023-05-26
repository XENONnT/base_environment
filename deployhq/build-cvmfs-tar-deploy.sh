#!/bin/bash

set -e

TAG=$1
PID_FILE=$HOME/.cvmfs-lock

# lock this process - this is needed as only one process
# should do a cvmfs transaction at any given time
if [ -e $PID_FILE ]; then
    PID=$(cat $PID_FILE)
    while kill -0 $PID >/dev/null 2>&1; do
        sleep 30s
    done
fi
echo $$ >$PID_FILE

cvmfs_server transaction xenon.opensciencegrid.org

cd /cvmfs/xenon.opensciencegrid.org/releases/nT/ 
rm -rf $TAG 
bsdtar xzf /tmp/$TAG.tar.gz 
cd /tmp

cvmfs_server publish xenon.opensciencegrid.org

# release lock
rm $PID_FILE


