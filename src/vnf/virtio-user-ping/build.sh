#!/bin/bash

set -ex
cd $(dirname `readlink -f $0`)

sudo docker build -t vppbuild build
sudo docker run --rm vppbuild bash -c "cd /vpp; tar -c bin" | tar -C . -xv
sudo docker build -t virtio-user .
