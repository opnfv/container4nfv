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

set -x

VBoxManage list vms | cut -f2 -d'"' | xargs -I {} VBoxManage controlvm {} poweroff
VBoxManage list vms | cut -f2 -d'"' | xargs -I {} VBoxManage unregistervm {} --delete
VBoxManage list hostonlyifs | grep "^Name:.*vboxnet" |\
    sed "s/^Name:.*vboxnet/vboxnet/" | xargs -I {} VBoxManage hostonlyif remove {}
sudo virsh list --name | xargs -I {} sudo virsh destroy {}
sudo virsh list --all --name | xargs -I {} sudo virsh undefine {}
sudo virsh net-list --name | xargs -I {} sudo virsh net-destroy --network {}
sudo virsh net-list --name | xargs -I {} sudo virsh undefine {}
sudo brctl show | awk 'NF>1 && NR>1 {print $1}' | xargs -I {} sudo bash -c "ifconfig {} down; brctl delbr {}"
sudo virsh vol-list default | awk 'NF>1 && NR>1 {print $1}' | xargs -I {} sudo virsh vol-delete {} default
