#!/bin/bash

set -ex

cat << EOF | sudo tee /etc/sudoers.d/${USER}
${USER} ALL = (root) NOPASSWD:ALL
EOF

sudo apt-get update -y
sudo apt-get install -y openssh-server git virtualbox
wget https://releases.hashicorp.com/vagrant/1.8.7/vagrant_1.8.7_x86_64.deb
sudo dpkg -i vagrant_1.8.7_x86_64.deb
rm -rf vagrant_1.8.7_x86_64.deb
sudo apt-get install -y ruby-libvirt
sudo apt-get install -y qemu libvirt-bin ebtables dnsmasq
sudo apt-get install -y libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev
vagrant plugin install vagrant-libvirt
sudo adduser ${USER} libvirtd
sudo service libvirtd restart
