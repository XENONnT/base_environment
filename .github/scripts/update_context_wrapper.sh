#!/bin/bash

. /opt/XENONnT/setup.sh
cd $HOME

echo "ref name: ${GITHUB_REF_NAME}"
echo "ref type: ${GITHUB_REF_TYPE}"

# get cutax version
CUTAX_VERSION=$(grep "cutax_version=" create-env)
CUTAX_VERSION=${CUTAX_VERSION//cutax_version=}
if [ $CUTAX_VERSION = 'latest' ]; then echo "Dont upload for latest version" && exit 0; fi
cd cutax
git checkout $CUTAX_VERSION
pip install ./ --user
cd $HOME

max_attempts=3
attempt=1
while true; do
    if python .github/scripts/update-context-collection.py ${GITHUB_REF_NAME} ${GITHUB_REF_TYPE}; then
        break
    fi

    if [ "$attempt" -ge "$max_attempts" ]; then
        echo "WARNING: update-context-collection.py failed after ${max_attempts} attempts"
        exit 1
    fi

    sleep_seconds=$((attempt * 30))
    next_attempt=$((attempt + 1))
    echo "Retrying update-context-collection.py in ${sleep_seconds}s (attempt ${next_attempt}/${max_attempts})"
    sleep "$sleep_seconds"
    attempt=$next_attempt
done
