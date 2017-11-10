#!/bin/bash

set -ex
sudo timeout 3600 kubeadm join --token 8c5adc.1cec8dbf339093f0 192.168.1.10:6443 || true
