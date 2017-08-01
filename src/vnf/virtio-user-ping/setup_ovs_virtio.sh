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

sudo sysctl -w vm.nr_hugepages=2048
sudo apt-get install -y docker.io
sudo docker build -t vpp /vagrant/
sudo docker run -itd -v /dev/hugepages/:/dev/hugepages/ -v /var/run/openvswitch:/var/run/openvswitch -v /vagrant:/vagrant vpp /root/setup_vpp.sh
sleep 20
ping -c4 192.168.3.2
