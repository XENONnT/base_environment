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
git clone --single-branch --branch master https://github.com/AxFoundation/strax.git
pip install -e strax
pytest strax || { echo 'strax tests failed' ; exit 1; }

# Straxen
echo " ... straxen tests"
git clone --single-branch --branch master https://github.com/XENONnT/straxen.git
pip install -e straxen
bash straxen/.github/scripts/create_pre_apply_function.sh $HOME
pytest straxen || { echo 'straxen tests failed' ; exit 1; }
rm $HOME/pre_apply_function.py

# wfsim
echo " ... wfsim tests"
wfsim_version=`python -c "import wfsim; print(wfsim.__version__)"`
git clone --single-branch --branch master https://github.com/XENONnT/wfsim ./wfsim
pip install -e wfsim
pytest wfsim || { echo 'wfsim tests failed' ; exit 1; }
