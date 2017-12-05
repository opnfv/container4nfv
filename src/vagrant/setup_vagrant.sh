#!/bin/bash
#
# Copyright (c) 2017 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -ex

DIR="$(dirname `readlink -f $0`)"

usage() {
  echo "Usage: $0 -b virtualbox|libvirt"
}

install_packages()
{
    cat << EOF | sudo tee /etc/sudoers.d/${USER}
${USER} ALL = (root) NOPASSWD:ALL
EOF
    sudo apt-get update -y
    sudo apt-get install -y git unzip
    wget https://releases.hashicorp.com/vagrant/1.8.7/vagrant_1.8.7_x86_64.deb
    sudo dpkg -i vagrant_1.8.7_x86_64.deb
    rm -rf vagrant_1.8.7_x86_64.deb

    sudo apt-get install -y virtualbox

    #refer to https://github.com/vagrant-libvirt/vagrant-libvirt
    sudo sed -i 's/^# deb-src/deb-src/g' /etc/apt/sources.list
    sudo apt-get update
    sudo apt-get build-dep vagrant ruby-libvirt -y
    sudo apt-get install -y bridge-utils qemu libvirt-bin ebtables dnsmasq
    sudo apt-get install -y libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev
    vagrant plugin install vagrant-libvirt
    sudo adduser ${USER} libvirtd
    sudo service libvirtd restart
}

install_box_builder()
{
    # Thanks Bento's great effort
    # Bento project(https://github.com/chef/bento) is released by Apache 2.0 License
    cd $DIR
    rm -rf bento
    git clone https://github.com/chef/bento
    cd bento; git checkout 05d98910d835b503e7be3d2e4071956f66fbbbc4
    cp ../update.sh ubuntu/scripts/
    wget https://releases.hashicorp.com/packer/1.1.2/packer_1.1.2_linux_amd64.zip
    unzip packer_1.1.2_linux_amd64.zip
    cd ubuntu
    sed -i 's/"disk_size": "40960"/"disk_size": "409600"/' ubuntu-16.04-amd64.json
}

build_virtualbox() {
    cd $DIR/bento/ubuntu
    rm -rf ~/'VirtualBox VMs'/ubuntu-16.04-amd64
    ../packer build -var 'headless=true' -only=virtualbox-iso ubuntu-16.04-amd64.json
    vagrant box remove -f opnfv/container4nfv --all || true
    vagrant box add opnfv/container4nfv ../builds/ubuntu-16.04.virtualbox.box
}

build_libvirtbox() {
    cd $DIR/bento/ubuntu
    ../packer build -var 'headless=true' -only=qemu ubuntu-16.04-amd64.json
    vagrant box remove -f opnfv/container4nfv.kvm --all || true
    vagrant box add opnfv/container4nfv.kvm ../builds/ubuntu-16.04.libvirt.box
}

install_packages

set +x
while getopts "b:h" OPTION; do
    case $OPTION in
    b)
        if [ ${OPTARG} == "virtualbox" ]; then
            install_box_builder
            build_virtualbox
        elif [ ${OPTARG} == "libvirt" ]; then
            install_box_builder
            build_kvmbox
        fi
        ;;
    h)
        usage;
        ;;
    esac
done
