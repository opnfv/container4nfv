#!/bin/bash

set -ex

for i in {1..10}
do
    sudo sysctl -w vm.nr_hugepages=2048; sleep 1
done
sudo modprobe uio_pci_generic
ip=$(ip a s enp0s9 | grep inet | grep -v inet6 | sed "s/.*inet//" | cut -f2 -d' ')
sudo ip address flush enp0s9
sudo /usr/share/dpdk/tools/dpdk_nic_bind.py --bind=uio_pci_generic enp0s9
sudo sysctl -w vm.nr_hugepages=1024
sudo mount -t hugetlbfs -o pagesize=2M none /dev/hugepages
sudo cp /usr/bin/ovs-vsctl /usr/local/bin
memory=$(grep HugePages_Total /proc/meminfo | cut -f2 -d:)
echo "DPDK_OPTS='--dpdk -c 0x1 -n 2 -m $memory'" | sudo tee -a /etc/default/openvswitch-switch
sudo service dpdk restart
sudo service openvswitch-switch restart
sudo pkill ovs-vswitchd
sudo ovs-vswitchd --dpdk -c 0x1 -n 2 -m $memory -- unix:/var/run/openvswitch/db.sock -vconsole:emer -vsyslog:err -vfile:info --mlockall --no-chdir --log-file=/var/log/openvswitch/ovs-vswitchd.log --pidfile=/var/run/openvswitch/ovs-vswitchd.pid --detach --monitor
sudo ovs-vsctl add-br br-dpdk -- set bridge br-dpdk datapath_type=netdev
sudo ovs-vsctl add-port br-dpdk dpdk0 -- set Interface dpdk0 type=dpdk
sudo ip a a $ip dev br-dpdk
sudo ip link set dev br-dpdk up
while true; do sleep 3600; done
echo sudo docker build -t openretriever/ubuntu1604-ovsdpdk .
echo sudo docker run -ti --privileged --net=host -v /dev:/dev -v /usr/local/bin:/usr/local/bin -v /var/run/openvswitch/:/var/run/openvswitch/ -v /lib/modules/:/lib/modules openretriever/ubuntu1604-ovsdpdk bash
