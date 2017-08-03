#!/bin/bash
sudo apt-get update
sudo apt-get -y install sudo apt-transport-https devscripts git wget vim net-tools
cd /root
git clone https://gerrit.fd.io/r/vpp
cd vpp
git checkout stable/1707
cp  ../01-add-single-file.patch  dpdk/dpdk-17.05_patches
cp  ../02-fix-nohuge-option.patch  dpdk/dpdk-17.05_patches
patch -p1 < ../virtio-user.patch
make UNATTENDED=yes install-dep || true
make bootstrap
make build; find . -type f | grep "install.*bin" | xargs -I {} cp {} /usr/bin/
