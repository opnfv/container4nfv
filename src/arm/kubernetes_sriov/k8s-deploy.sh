#!/bin/bash
set -e

#sudo apt-get install -y docker.io libvirt-bin virt-manager qemu qemu-efi

#!/bin/bash
cd compass4nfv

export ADAPTER_OS_PATTERN='(?i)CentOS-7.*arm.*'
export OS_VERSION="centos7"
export KUBERNETES_VERSION="v1.7.3"
export DHA="deploy/conf/vm_environment/k8-nosdn-nofeature-noha.yml"
export NETWORK="deploy/conf/network_cfg_sriov.yaml"
export VIRT_NUMBER=2 VIRT_CPUS=2 VIRT_MEM=4096 VIRT_DISK=50G

# enable sriov cni deployment
echo "Set sriov cni scenario"
sed -i.bak 's/^kube_network_plugin:.*$/kube_network_plugin: sriov/' \
    deploy/adapters/ansible/kubernetes/roles/kargo/files/extra-vars-aarch64.yml

./deploy.sh

set -ex

# basic test: ssh to master, check k8s node status
sshpass -p root ssh root@10.1.0.50 kubectl get nodes 2>/dev/null | grep -i ready

# scenario specific tests
# show two nics in container
sshpass -p root ssh root@10.1.0.50 \
   kubectl create -f /etc/kubernetes/sriov-test-pod.yml && \
   sleep 30 && \
   kubectl exec multus-test1 -- sh -c "ping -c 3 192.168.123.31"
