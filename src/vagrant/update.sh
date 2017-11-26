#!/bin/sh -eux
export DEBIAN_FRONTEND=noninteractive

ubuntu_version="`lsb_release -r | awk '{print $2}'`";
ubuntu_major_version="`echo $ubuntu_version | awk -F. '{print $1}'`";

# Disable release-upgrades
sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades;

# Update the package list
apt-get -y update;

# update package index on boot
cat <<EOF >/etc/init/refresh-apt.conf;
description "update package index"
start on networking
task
exec /usr/bin/apt-get update
EOF

# Disable periodic activities of apt
cat <<EOF >/etc/apt/apt.conf.d/10disable-periodic;
APT::Periodic::Enable "0";
EOF

# Upgrade all installed packages incl. kernel and kernel headers
apt-get -y dist-upgrade -o Dpkg::Options::="--force-confnew";

apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
apt-key adv -k 58118E89F3A912897C070ADBF76221572C52609D
cat << EOF | tee /etc/apt/sources.list.d/docker.list
deb [arch=amd64] https://apt.dockerproject.org/repo ubuntu-xenial main
EOF

curl -s http://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF | tee /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y --allow-downgrades docker-engine=1.12.6-0~ubuntu-xenial kubelet=1.7.0-00 kubeadm=1.7.0-00 kubectl=1.7.0-00 kubernetes-cni=0.5.1-00

docker pull gcr.io/google_containers/kube-proxy-amd64:v1.7.10
docker pull gcr.io/google_containers/kube-apiserver-amd64:v1.7.10
docker pull gcr.io/google_containers/kube-controller-manager-amd64:v1.7.10
docker pull gcr.io/google_containers/kube-scheduler-amd64:v1.7.10
docker pull gcr.io/google_containers/k8s-dns-sidecar-amd64:1.14.4
docker pull gcr.io/google_containers/k8s-dns-kube-dns-amd64:1.14.4
docker pull gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.4
docker pull gcr.io/google_containers/etcd-amd64:3.0.17
docker pull gcr.io/google_containers/pause-amd64:3.0
docker pull ubuntu:16.04
docker pull nginx:1.13.6
docker pull busybox:1.27.2
docker pull weaveworks/weave-npc:2.0.5
docker pull weaveworks/weave-kube:2.0.5
docker pull quay.io/coreos/flannel:v0.9.0-amd64
docker pull quay.io/calico/cni:v1.8.0
docker pull quay.io/calico/node:v1.1.3
