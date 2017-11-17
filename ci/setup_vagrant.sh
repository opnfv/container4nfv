#!/bin/bash

set -ex

cat << EOF | sudo tee /etc/sudoers.d/${USER}
${USER} ALL = (root) NOPASSWD:ALL
EOF

sudo apt-get update -y
sudo apt-get install -y openssh-server git virtualbox unzip
wget https://releases.hashicorp.com/vagrant/1.8.7/vagrant_1.8.7_x86_64.deb
sudo dpkg -i vagrant_1.8.7_x86_64.deb
rm -rf vagrant_1.8.7_x86_64.deb

# Thanks Bento's great effort
# Bento project(https://github.com/chef/bento) is released by Apache 2.0 License

rm -rf bento
git clone https://github.com/chef/bento
cd bento; git checkout 05d98910d835b503e7be3d2e4071956f66fbbbc4
wget https://releases.hashicorp.com/packer/1.1.2/packer_1.1.2_linux_amd64.zip
unzip packer_1.1.2_linux_amd64.zip
patch -p1 < ../bento.k8s.diff
cd ubuntu
../packer build -var 'headless=true' -only=virtualbox-iso ubuntu-16.04-amd64.json
vagrant box remove -f opnfv/container4nfv --all || true
vagrant box add --box-version 1 opnfv/container4nfv ../builds/ubuntu-16.04.virtualbox.box
