#!/bin/bash

echo "Running tests"

. /opt/XENONnT/setup.sh

# gfal2
echo " ... gfal2 tests"
python -c 'import gfal2'

# Strax
echo " ... strax tests"
strax_version=`python -c "import strax; print(strax.__version__)"`
git clone --single-branch --branch $strax_version https://github.com/AxFoundation/strax.git
pytest strax || { echo 'strax tests failed' ; exit 1; }
rm -r strax

# Straxen
echo " ... straxen tests"
straxen_version=`python -c "import straxen; print(straxen.__version__)"`
git clone --single-branch --branch $straxen_version https://github.com/XENONnT/straxen.git
bash straxen/.github/scripts/create_pre_apply_function.sh $HOME
pytest straxen || { echo 'straxen tests failed' ; exit 1; }
rm -r straxen
rm $HOME/pre_apply_function.py

# wfsim
echo " ... wfsim tests"
wfsim_version=`python -c "import wfsim; print(wfsim.__version__)"`
echo "Testing $wfsim_version"
git clone --single-branch --branch v$wfsim_version https://github.com/XENONnT/wfsim ./wfsim
pytest wfsim || { echo 'wfsim tests failed' ; exit 1; }
rm -r wfsim
