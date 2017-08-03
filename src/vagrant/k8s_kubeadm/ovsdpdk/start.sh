#!/bin/bash

set -ex
sudo sysctl -w vm.nr_hugepages=2048
sudo mount -t hugetlbfs -o pagesize=2M none /dev/hugepages
cp /usr/bin/ovs-vsctl /usr/local/bin
sudo service dpdk restart
sudo service openvswitch-switch restart
sudo ovs-vsctl add-br br-dpdk -- set bridge br-dpdk datapath_type=netdev
sudo modprobe uio_pci_generic
#sudo ip address flush enp0s9
#sudo /usr/share/dpdk/tools/dpdk_nic_bind.py --bind=uio_pci_generic enp0s9
#sudo ovs-vsctl add-port br-dpdk dpdk0 -- set Interface dpdk0 type=dpdk
while true; do sleep 3600; done
echo sudo docker run -ti --privileged -v /dev:/dev -v /usr/local/bin:/usr/local/bin -v /var/run/openvswitch/:/var/run/openvswitch/ dpdk /ovsdpdk/start.sh
