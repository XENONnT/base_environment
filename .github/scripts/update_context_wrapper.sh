#!/bin/bash

. /opt/XENONnT/setup.sh
cd $HOME
# get cutax versionf
CUTAX_VERSION=$(grep "cutax_version=" create-env)
CUTAX_VERSION=v${CUTAX_VERSION//cutax_version=}
cd cutax
echo "Checking out $CUTAX_VERSION"
git checkout $CUTAX_VERSION
python setup.py develop --user
cd $HOME
python -c "import cutax; print(cutax.__version__)"
# python .github/scripts/update-context-collection.py
