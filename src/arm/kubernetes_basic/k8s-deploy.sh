#!/bin/bash
set -e

#sudo apt-get install -y docker.io libvirt-bin virt-manager qemu qemu-efi

dir=`pwd`
echo "Current dir: "$dir
curdir=${dir##*/}
result=$(echo $curdir | grep "compass4nfv")
if [[ "$result" == "" ]]
then
    cd compass4nfv
fi


#export CONTAINER4NFV_SCENARIO={scenario}

export ADAPTER_OS_PATTERN='(?i)CentOS-7.*arm.*'
export OS_VERSION="centos7"
export KUBERNETES_VERSION="v1.7.3"
export DHA="deploy/conf/vm_environment/k8-nosdn-nofeature-noha.yml"
export NETWORK="deploy/conf/vm_environment/network.yml"
export VIRT_NUMBER=2 VIRT_CPUS=2 VIRT_MEM=4096 VIRT_DISK=50G

./deploy.sh

set -ex

# basic test: ssh to master, check k8s node status
sshpass -p root ssh root@10.1.0.50 kubectl get nodes 2>/dev/null | grep -i ready

# Copy examples to master, run the example of nginx
sshpass -p root scp -r ./examples root@10.1.0.50:~
sshpass -p root ssh root@10.1.0.50 ~/examples/nginx-app.sh
