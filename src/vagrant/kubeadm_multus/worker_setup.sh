#!/bin/bash

set -ex
sudo timeout 600 kubeadm join --token 8c5adc.1cec8dbf339093f0 10.96.0.10:6443 || true
