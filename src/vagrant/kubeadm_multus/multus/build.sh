#!/bin/bash

wget -qO- https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz | sudo tar -C /usr/local -xz
echo 'export GOPATH=/go; export PATH=/usr/local/go/bin:$GOPATH/bin:$PATH' >> ~/.bashrc
export GOPATH=/go; export PATH=/usr/local/go/bin:$GOPATH/bin:$PATH
git clone https://github.com/Intel-Corp/multus-cni
cd multus-cni; bash ./build
