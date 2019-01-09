#!/bin/bash

set -ex

bash /vagrant/kata/kata_setup.sh
sleep 120
sudo kubeadm join --discovery-token-unsafe-skip-ca-verification --token 8c5adc.1cec8dbf339093f0 192.168.1.10:6443
