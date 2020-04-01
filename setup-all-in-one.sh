set -x

# Install git
sudo yum install -y git selinux-policy

# From https://docs.openstack.org/kayobe/latest/development/automated.html#overcloud
git clone https://opendev.org/openstack/kayobe.git -b stable/train
cd kayobe
mkdir -p config/src
CONFIG_REPO=${CONFIG_REPO:-https://github.com/brtknr/kayobe-config-dev} # https://opendev.org/openstack/kayobe-config-dev.git
CONFIG_BRANCH=${CONFIG_BRANCH:-stable/train-magnum} # stable/train
git clone $CONFIG_REPO -b $CONFIG_BRANCH config/src/kayobe-config

# Setup network
sudo ip l add breth1 type bridge
sudo ip l set breth1 up
sudo ip a add 192.168.33.3/24 dev breth1
sudo ip l add eth1 type dummy
sudo ip l set eth1 up
sudo ip l set eth1 master breth1

# Bootstrap and exit if there is error
set -e
./dev/install-dev.sh
./dev/overcloud-deploy.sh
