#!/usr/bin/env bash
set -ex

sudo pvcreate /dev/vdb
sudo vgextend  ubuntubox-vg /dev/vdb
sudo lvextend -L+500G /dev/mapper/ubuntubox--vg-root
sudo resize2fs /dev/mapper/ubuntubox--vg-root

cd devstack
cp /vagrant/compute.conf local.conf
host=$(hostname)
ip=$(ifconfig | grep 192.168.0 | cut -f2 -d: | cut -f1 -d' ')
sed -i -e "s/HOSTIP/$ip/" -e "s/HOSTNAME/$host/" local.conf
./stack.sh


sudo apt-get update -y
sudo apt-get install -y putty
echo y | plink -ssh -l vagrant -pw vagrant 192.168.0.30 "bash /vagrant/setup_cell.sh"
