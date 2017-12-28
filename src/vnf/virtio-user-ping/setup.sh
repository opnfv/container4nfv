#!/bin/bash

sudo sysctl -w vm.nr_hugepages=1024
sudo mount -t hugetlbfs -o pagesize=2M none /dev/hugepages

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5EDB1B62EC4926EA
sudo apt-get update -y
sudo apt-get install software-properties-common -y
sudo apt-add-repository cloud-archive:ocata -y
sudo apt-get update -y
sudo apt-get install -y openvswitch-switch-dpdk
sudo update-alternatives --set ovs-vswitchd /usr/lib/openvswitch-switch-dpdk/ovs-vswitchd-dpdk

sudo sed -i "s/[# ]*\(NR_2M_PAGES=\).*/\10/" /etc/dpdk/dpdk.conf
sudo service dpdk restart

sudo ovs-vsctl --no-wait set Open_vSwitch . "other_config:dpdk-init=true"
sudo ovs-vsctl --no-wait set Open_vSwitch . "other_config:dpdk-lcore-mask=1"
sudo ovs-vsctl --no-wait set Open_vSwitch . "other_config:dpdk-alloc-mem=2048"
sudo service openvswitch-switch restart

sudo ovs-vsctl add-br br-dpdk -- set bridge br-dpdk datapath_type=netdev
sudo ovs-vsctl add-port br-dpdk vhost-user-1 -- set Interface vhost-user-1 type=dpdkvhostuser
sudo ifconfig br-dpdk 192.168.3.1/24 up

sudo apt-get install -y docker.io
/vagrant/build.sh

sudo ip link add dummy-1 type dummy
sudo mkdir -p /var/run/cni/
cat <<EOF | sudo tee /var/run/cni/netconf-1
:::::192.168.3.2
EOF
sudo sysctl -w vm.nr_hugepages=2048
sudo docker run -d --network=host -v /dev/hugepages/:/dev/hugepages/ -v /var/run/:/var/run virtio-user /vpp/setup_vpp.sh
sleep 30
ping 192.168.3.2
