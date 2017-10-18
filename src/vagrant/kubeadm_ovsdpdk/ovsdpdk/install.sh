#!/bin/bash

set -ex
sudo apt-get update
sudo apt-get install -y openvswitch-switch-dpdk pciutils vim
sudo update-alternatives --set ovs-vswitchd /usr/lib/openvswitch-switch-dpdk/ovs-vswitchd-dpdk
