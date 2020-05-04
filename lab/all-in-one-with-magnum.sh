#!/bin/bash

set -ex

# Deploy overcloud
export CONFIG_BRANCH=stable/train-magnum
./all-in-one.sh

# Deploy a Kubernetes cluster via Magnum
./magnum-terraform.sh
