#!/bin/bash

# Reset SECONDS
SECONDS=0

set -ex

pushd `dirname ${BASH_SOURCE[0]}`

# Deploy overcloud
export CONFIG_BRANCH=stable/train-magnum
./all-in-one.sh

# Deploy a Kubernetes cluster via Magnum
./magnum-terraform.sh

popd

set +ex

# Calculate duration
duration=$SECONDS
echo "[INFO] $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
