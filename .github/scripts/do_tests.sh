#!/bin/bash

echo "Running tests"

# spool up test-database for tests
export TEST_MONGO_URI='mongodb://localhost:27017/'
export SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True


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

  wfsim )
    # wfsim
    echo " ... wfsim tests"
    wfsim_version=`python -c "import wfsim; print(wfsim.__version__)"`
    echo "Testing $wfsim_version"
    git clone --single-branch --branch v$wfsim_version https://github.com/XENONnT/wfsim ./wfsim
    pytest -v wfsim || { echo 'wfsim tests failed' ; exit 1; }
    rm -r wfsim
  ;;

  pema )
    echo " ... pema tests"
    pema_version=`python -c "import pema; print(pema.__version__)"`
    echo "Testing $pema_version"
    git clone --single-branch --branch v$pema_version https://github.com/XENONnT/pema ./pema
    pytest -v pema || { echo 'pema tests failed' ; exit 1; }
    rm -r pema
  ;;

  cutax )
    # cutax
    # we have already checked out cutax in the actions workflow
    echo " ... cutax tests"
    echo "Current dir"
    ls

    CUTAX_VERSION=$(grep "cutax_version=" create-env)
    CUTAX_VERSION=${CUTAX_VERSION//cutax_version=}
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

  xedocs )
     # xedocs
     echo " ... xedocs tests"
     xedocs_version=`python -c "import xedocs; print(xedocs.__version__)"`
     echo "Testing $xedocs_version"
     git clone --single-branch --branch v$xedocs_version https://github.com/XENONnT/xedocs ./xedocs
     pytest xedocs || { echo 'xedocs tests failed' ; exit 1; }
     rm -r xedocs
  ;;
esac
