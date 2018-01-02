#!/bin/bash

set -ex

for i in {1..10}
do
    sysctl -w vm.nr_hugepages=2048; sleep 1
done

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5EDB1B62EC4926EA
apt-get update -y
apt-get install software-properties-common -y
apt-add-repository cloud-archive:ocata -y
apt-get update -y
apt-get install -y openvswitch-switch-dpdk pciutils iproute2
update-alternatives --set ovs-vswitchd /usr/lib/openvswitch-switch-dpdk/ovs-vswitchd-dpdk

cp /usr/bin/ovs-vsctl /usr/local/bin

sed -i "s/[# ]*\(NR_2M_PAGES=\).*/\10/" /etc/dpdk/dpdk.conf
modprobe uio_pci_generic
ip=$(ip a s eth2 | grep inet | grep -v inet6 | sed "s/.*inet//" | cut -f2 -d' ')
ip address flush eth2
/usr/share/dpdk/tools/dpdk_nic_bind.py --bind=uio_pci_generic eth2

sysctl -w vm.nr_hugepages=1024
mount -t hugetlbfs -o pagesize=2M none /dev/hugepages
service dpdk restart
ovs-vsctl --no-wait set Open_vSwitch . "other_config:dpdk-init=true"
ovs-vsctl --no-wait set Open_vSwitch . "other_config:dpdk-lcore-mask=1"
ovs-vsctl --no-wait set Open_vSwitch . "other_config:dpdk-alloc-mem=2048"
service openvswitch-switch restart

ovs-vsctl add-br br-dpdk -- set bridge br-dpdk datapath_type=netdev
ovs-vsctl add-port br-dpdk dpdk0 -- set Interface dpdk0 type=dpdk
ip a a $ip dev br-dpdk
ip link set dev br-dpdk up
while true; do sleep 3600; done
echo docker build -t openretriever/ubuntu1604-ovsdpdk .
echo docker run -ti --privileged --net=host -v /dev:/dev -v /usr/local/bin:/usr/local/bin -v /var/run/openvswitch/:/var/run/openvswitch/ -v /lib/modules/:/lib/modules openretriever/ubuntu1604-ovsdpdk bash
