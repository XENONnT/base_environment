#!/bin/bash

. /opt/XENONnT/setup.sh

cd cutax
python setup.py develop --user
cd ..
export X509_USER_PROXY=$PWD/user_cert
python -c "import cutax; print(cutax.__version__)"
# python .github/scripts/update-context-collection.py
