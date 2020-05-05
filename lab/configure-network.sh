#!/bin/bash

set -x

sudo dnf -y install network-scripts
sudo systemctl is-enabled NetworkManager && (sudo systemctl disable NetworkManager ; sudo systemctl enable network ; sudo systemctl stop NetworkManager ; sudo systemctl start network)
sudo systemctl is-enabled firewalld && (sudo systemctl stop firewalld ; sudo systemctl disable firewalld

# Configure breth1
[[ -z "$1" ]] && echo "Requires an IP address as an argument, e.g. 192.168.33.3" && exit 1
sudo ip l add breth1 type bridge
sudo ip l set breth1 up
sudo ip a add $1/24 dev breth1
[[ -z "$2" ]] || sudo ip a add $2/24 dev breth1
sudo ip l add eth1 type dummy
sudo ip l set eth1 up
sudo ip l set eth1 master breth1

# Configure vxlan0 - not idempotent
source labip.sh
if [[ ! -z $LOCAL_IP ]] && [[ ! -z $REMOTE_IP ]]; then
    sudo ip link add vxlan0 type vxlan id 10000 local $LOCAL_IP dstport 4790
    sudo ip link set vxlan0 mtu 1450
    sudo bridge fdb append 00:00:00:00:00:00 dev vxlan0 dst $REMOTE_IP
    sudo ip link set vxlan0 up
    sudo ip link set vxlan0 master breth1
fi
