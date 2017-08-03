#!/bin/bash

set -ex
sudo apt-get update
sudo apt-get install -y openvswitch-switch-dpdk linux-image-extra-4.4.0-75-generic
sudo update-alternatives --set ovs-vswitchd /usr/lib/openvswitch-switch-dpdk/ovs-vswitchd-dpdk
echo "DPDK_OPTS='--dpdk -c 0x1 -n 4 -m 1024'" | sudo tee -a /etc/default/openvswitch-switch
