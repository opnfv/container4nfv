#!/bin/bash

set -ex

for i in {1..10}
do
    sysctl -w vm.nr_hugepages=2048; sleep 1
done

apt-get update
apt-get install -y openvswitch-switch-dpdk pciutils vim
update-alternatives --set ovs-vswitchd /usr/lib/openvswitch-switch-dpdk/ovs-vswitchd-dpdk
modprobe uio_pci_generic
ip=$(ip a s eth2 | grep inet | grep -v inet6 | sed "s/.*inet//" | cut -f2 -d' ')
ip address flush eth2
/usr/share/dpdk/tools/dpdk_nic_bind.py --bind=uio_pci_generic eth2
sysctl -w vm.nr_hugepages=1024
mount -t hugetlbfs -o pagesize=2M none /dev/hugepages
cp /usr/bin/ovs-vsctl /usr/local/bin
memory=$(grep HugePages_Total /proc/meminfo | cut -f2 -d:)
echo "DPDK_OPTS='--dpdk -c 0x1 -n 2 -m $memory'" | tee -a /etc/default/openvswitch-switch
service dpdk restart
service openvswitch-switch restart
pkill ovs-vswitchd
ovs-vswitchd --dpdk -c 0x1 -n 2 -m $memory -- unix:/var/run/openvswitch/db.sock -vconsole:emer -vsyslog:err -vfile:info --mlockall --no-chdir --log-file=/var/log/openvswitch/ovs-vswitchd.log --pidfile=/var/run/openvswitch/ovs-vswitchd.pid --detach --monitor
ovs-vsctl add-br br-dpdk -- set bridge br-dpdk datapath_type=netdev
ovs-vsctl add-port br-dpdk dpdk0 -- set Interface dpdk0 type=dpdk
ip a a $ip dev br-dpdk
ip link set dev br-dpdk up
while true; do sleep 3600; done
echo docker build -t openretriever/ubuntu1604-ovsdpdk .
echo docker run -ti --privileged --net=host -v /dev:/dev -v /usr/local/bin:/usr/local/bin -v /var/run/openvswitch/:/var/run/openvswitch/ -v /lib/modules/:/lib/modules openretriever/ubuntu1604-ovsdpdk bash
