#!/bin/bash

set -e

echo "Please run it by jenkins account!"
cat << EOF | sudo tee /etc/sudoers.d/${USER}
${USER} ALL = (root) NOPASSWD:ALL
EOF
sudo apt-get update > /dev/null
sudo apt install -y qemu-kvm libvirt-bin 2>1 /dev/null
echo "Plsease reboot/logout to make effective for libvirt group adding"
