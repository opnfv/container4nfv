#!/bin/bash

sudo sysctl -w vm.nr_hugepages=1024
sudo mount -t hugetlbfs -o pagesize=2M none /dev/hugepages

sudo apt-get update -y
sudo apt-get install -y openvswitch-switch-dpdk
sudo update-alternatives --set ovs-vswitchd /usr/lib/openvswitch-switch-dpdk/ovs-vswitchd-dpdk

echo "DPDK_OPTS='--dpdk -c 0x1 -n 4 -m 1024 --vhost-owner docker --vhost-perm 0664'" | sudo tee -a /etc/default/openvswitch-switch
sudo service dpdk restart
sudo service openvswitch-switch restart
sleep 10

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
