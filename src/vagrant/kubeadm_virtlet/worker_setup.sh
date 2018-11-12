#!/bin/bash

set -ex
sudo kubeadm join --discovery-token-unsafe-skip-ca-verification --token 8c5adc.1cec8dbf339093f0 192.168.1.10:6443

wget https://github.com/Mirantis/criproxy/releases/download/v0.12.0/criproxy_0.12.0_amd64.deb
sudo dpkg -i criproxy_0.12.0_amd64.deb
sudo sed -i "s/EnvironmentFile/#EnvironmentFile/" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo systemctl daemon-reload
sudo systemctl restart dockershim
sudo systemctl restart criproxy
sudo systemctl restart kubelet
