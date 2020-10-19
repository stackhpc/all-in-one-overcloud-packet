#!/bin/bash

# Reset SECONDS
SECONDS=0

set -ex

pushd `dirname ${BASH_SOURCE[0]}`

# Deploy overcloud
export CONFIG_BRANCH=stable/ussuri-standalone-monasca
./stack.sh

popd

# Calculate duration
duration=$SECONDS
echo "[INFO] $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
