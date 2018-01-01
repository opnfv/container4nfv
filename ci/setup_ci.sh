#!/bin/bash

set -e

echo "Please run it by jenkins account!"
cat << EOF | sudo tee /etc/sudoers.d/${USER}
${USER} ALL = (root) NOPASSWD:ALL
EOF
../src/vagrant/setup_vagrant.sh
echo "###########################################################"
echo "Please reboot to make effective for libvirt group adding!!!"
