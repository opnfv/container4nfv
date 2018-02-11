#!/bin/bash

set -ex

sudo apt-get install -y putty-tools python-openstackclient
mkdir ~/.kube
r=0
while [ "$r" == "0" ]
do
    sleep 30
    echo "y\n" | plink -ssh -pw vagrant vagrant@master "cat ~/.kube/config" > ~/.kube/config || true
    r=$(kubectl get pods -n kube-system  | grep "tiller-deploy.*Run" | wc -l)
done

curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
git clone http://gerrit.onap.org/r/oom
cd oom; git checkout amsterdam
source /vagrant/openstack/openrc
cat <<EOF | tee ~/oom/kubernetes/config/onap-parameters.yaml
OPENSTACK_UBUNTU_14_IMAGE: "ubuntu1404"
OPENSTACK_PUBLIC_NET_ID: "e8f51956-00dd-4425-af36-045716781ffc"
OPENSTACK_OAM_NETWORK_ID: "d4769dfb-c9e4-4f72-b3d6-1d18f4ac4ee6"
OPENSTACK_OAM_SUBNET_ID: "191f7580-acf6-4c2b-8ec0-ba7d99b3bc4e"
OPENSTACK_OAM_NETWORK_CIDR: "10.0.0.0/16"
OPENSTACK_USERNAME: "admin"
OPENSTACK_API_KEY: "adim"
OPENSTACK_TENANT_NAME: "admin"
OPENSTACK_TENANT_ID: "47899782ed714295b1151681fdfd51f5"
OPENSTACK_REGION: "RegionOne"
OPENSTACK_KEYSTONE_URL: "http://192.168.0.30:5000/v2.0"
OPENSTACK_FLAVOUR_MEDIUM: "m1.medium"
OPENSTACK_SERVICE_TENANT_NAME: "service"
DMAAP_TOPIC: "AUTO"
DEMO_ARTIFACTS_VERSION: "1.1.0-SNAPSHOT"
EOF
cd ~/oom/kubernetes/oneclick && ./deleteAll.bash -n onap || true
(kubectl delete ns onap; helm del --purge onap-config) || true
echo "y\n" | plink -ssh -pw vagrant vagrant@worker1 "sudo rm -rf /dockerdata-nfs/onap"
cd ~/oom/kubernetes/config && ./createConfig.sh -n onap
while true; do sleep 30; kubectl get pods --all-namespaces | grep onap | wc -l | grep "^0$" && break; done
source ~/oom/kubernetes/oneclick/setenv.bash
sed -i "s/aaiServiceClusterIp:.*/aaiServiceClusterIp: 10.96.0.254/" ~/oom/kubernetes/aai/values.yaml
cd ~/oom/kubernetes/oneclick && ./createAll.bash -n onap
