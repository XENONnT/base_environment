#!/bin/bash

. /opt/XENONnT/setup.sh
cd $HOME
# get cutax version
CUTAX_VERSION=$(grep "cutax_version=" create-env)
CUTAX_VERSION=${CUTAX_VERSION//cutax_version=}
if [ $CUTAX_VERSION = 'latest' ]; then echo "Dont upload for latest version" && exit 0; fi
cd cutax
git checkout $CUTAX_VERSION
python setup.py install --user
cd $HOME
python .github/scripts/update-context-collection.py
