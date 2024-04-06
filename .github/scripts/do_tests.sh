#!/bin/bash

echo "Running tests"

# spool up test-database for tests
export TEST_MONGO_URI='mongodb://localhost:27017/'


case "$1" in
  gfal2 )
    echo " ... gfal2 tests"
    python -c 'import gfal2'
  ;;

  admix )
    echo "... admix tests"
    python -c 'import admix'
  ;;

  strax )
    echo " ... strax tests"
    strax_version=`python -c "import strax; print(strax.__version__)"`
    git clone --single-branch --branch v$strax_version https://github.com/AxFoundation/strax.git
    pytest -v strax || { echo 'strax tests failed' ; exit 1; }
    rm -r strax
  ;;

  straxen )
    echo " ... straxen tests"
    straxen_version=`python -c "import straxen; print(straxen.__version__)"`
    git clone --single-branch --branch v$straxen_version https://github.com/XENONnT/straxen.git
    # TODO remove this cheat, can't get it to work now
    if [ $DISABLE_RUCIO_TEST ];
      then echo "removing rucio remote test";
      rm straxen/tests/storage/test_rucio_remote.py;
    fi
    # /TODO
    # Make sure all new numba code is cached to one directory
    mkdir $HOME/numba_cache
    export NUMBA_CACHE_DIR=$HOME/numba_cache/
    bash straxen/.github/scripts/create_pre_apply_function.sh $HOME
    pytest -vx straxen/tests || { echo 'straxen tests failed' ; exit 1; }
    rm -r straxen
    rm $HOME/pre_apply_function.py
  ;;

  cutax )
    # cutax
    # we have already checked out cutax in the actions workflow
    echo " ... cutax tests"
    echo "Current dir"
    ls

    CUTAX_VERSION=$(grep "cutax_version=" create-env)
    CUTAX_VERSION=${CUTAX_VERSION//cutax_version=}
    unset ALLOW_MC_TEST
    echo "Testing with cutax version ${CUTAX_VERSION}"
    cd cutax
    if [ $CUTAX_VERSION != 'latest' ]
    then
      git checkout $CUTAX_VERSION
    fi
    python setup.py install --user
    cd ..
    pytest cutax || { echo 'cutax tests failed' ; exit 1; }
  ;;

  appletree )
    echo " ... appletree tests"
    appletree_version=`python -c "import appletree; print(appletree.__version__)" | tail -n 1`
    echo "Testing $appletree_version"
    git clone --single-branch --branch v$appletree_version https://github.com/XENONnT/appletree ./appletree
    pytest -v appletree || { echo 'appletree tests failed' ; exit 1; }
    rm -r appletree
  ;;

  alea-inference )
    echo " ... alea-inference tests"
    alea_inference_version=`python -c "import alea; print(alea.__version__)" | tail -n 1`
    echo "Testing $alea_inference_version"
    git clone --single-branch --branch v$alea_inference_version https://github.com/XENONnT/alea ./alea
    pytest -v alea || { echo 'alea tests failed' ; exit 1; }
    rm -r alea
  ;;

  xedocs )
    echo " ... xedocs tests"
    xedocs_version=`python -c "import xedocs; print(xedocs.__version__)"`
    echo "Testing $xedocs_version"
    git clone --single-branch --branch v$xedocs_version https://github.com/XENONnT/xedocs ./xedocs
    pytest xedocs || { echo 'xedocs tests failed' ; exit 1; }
    rm -r xedocs
  ;;
esac
