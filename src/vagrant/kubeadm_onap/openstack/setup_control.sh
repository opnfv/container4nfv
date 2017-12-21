#!/usr/bin/env bash
set -ex

sudo pvcreate /dev/vdb
sudo vgextend  ubuntubox-vg /dev/vdb
sudo lvextend -L+500G /dev/mapper/ubuntubox--vg-root
sudo resize2fs /dev/mapper/ubuntubox--vg-root

cd devstack
cp /vagrant/control.conf  local.conf
./stack.sh

sudo pvcreate /dev/vdc
sudo vgextend stack-volumes-lvmdriver-1 /dev/vdc

source /vagrant/openrc

#openstack network create public --external --provider-network-type=flat --provider-physical-network=public
#openstack subnet create --network=public --subnet-range=192.168.1.0/24 --allocation-pool start=192.168.1.200,end=192.168.1.250 --gateway 192.168.1.1 public-subnet
openstack security group list -f value | cut -f1 -d" " | xargs -I {} openstack security group rule create --ingress --ethertype=IPv4 --protocol=0 {}

wget https://cloud-images.ubuntu.com/releases/14.04.1/release/ubuntu-14.04-server-cloudimg-amd64-disk1.img
wget https://cloud-images.ubuntu.com/releases/16.04/release/ubuntu-16.04-server-cloudimg-amd64-disk1.img
wget https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2
openstack image create ubuntu1404 --file ubuntu-14.04-server-cloudimg-amd64-disk1.img --disk-format qcow2
openstack image create ubuntu1604 --file ubuntu-16.04-server-cloudimg-amd64-disk1.img --disk-format qcow2
openstack image create centos7 --file CentOS-7-x86_64-GenericCloud.qcow2 --disk-format qcow2

openstack quota set admin --instances 32
openstack quota set admin --cores 128
openstack quota set admin --ram 409600

openstack flavor delete m1.medium  || true
openstack flavor create --public m1.medium --id auto --ram 4096 --vcpus 2 --disk 40
openstack flavor delete m1.large || true
openstack flavor create --public m1.large --id auto --ram  8192 --vcpus 2 --disk 40
openstack flavor delete m1.xlarge || true
openstack flavor create --public m1.xlarge --id auto --ram 12288 --vcpus 4 --disk 40
openstack flavor delete m1.xxlarge || true
openstack flavor create --public m1.xxlarge --id auto --ram 16384 --vcpus 4 --disk 40
