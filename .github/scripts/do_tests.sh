#!/bin/bash

echo "Running tests"

. /opt/XENONnT/setup.sh

# gfal2
echo " ... gfal2 tests"
python -c 'import gfal2'

# admix
echo "... admix tests"
python -c 'import admix'

# spool up test-database for tests
export TEST_MONGO_URI='mongodb://localhost:27017/'

# Strax
echo " ... strax tests"
strax_version=`python -c "import strax; print(strax.__version__)"`
git clone --single-branch --branch v$strax_version https://github.com/AxFoundation/strax.git
pytest strax || { echo 'strax tests failed' ; exit 1; }
rm -r strax

# Straxen
export ALLOW_WFSIM_TEST=1
export NUMBA_DISABLE_JIT=1
echo " ... straxen tests"
straxen_version=`python -c "import straxen; print(straxen.__version__)"`
git clone --single-branch --branch storage_reorganization https://github.com/XENONnT/straxen.git
cd straxen
coverage run --source=straxen setup.py test -v
cd ..
coveralls
rm -r straxen
export NUMBA_DISABLE_JIT=0


# wfsim
echo " ... wfsim tests"
wfsim_version=`python -c "import wfsim; print(wfsim.__version__)"`
echo "Testing $wfsim_version"
git clone --single-branch --branch v$wfsim_version https://github.com/XENONnT/wfsim ./wfsim
pytest wfsim || { echo 'wfsim tests failed' ; exit 1; }
rm -r wfsim

# Pema
echo " ... pema tests"
pema_version=`python -c "import pema; print(pema.__version__)"`
echo "Testing $pema_version"
git clone --single-branch --branch v$pema_version https://github.com/XENONnT/pema ./pema
pytest pema || { echo 'pema tests failed' ; exit 1; }
rm -r pema
