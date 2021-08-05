#!/bin/bash

. /opt/XENONnT/setup.sh
cd $HOME
# get cutax version
CUTAX_VERSION=$(grep "cutax_version=" create-env)
CUTAX_VERSION=v${CUTAX_VERSION//cutax_version=}
cd cutax
git checkout $CUTAX_VERSION
python setup.py develop --user
cd $HOME
python .github/scripts/update-context-collection.py
