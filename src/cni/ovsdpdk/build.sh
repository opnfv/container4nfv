#!/bin/bash
set -ex

DIR="$(dirname `readlink -f $0`)"

cd $DIR
sudo docker run -v $DIR:/build ubuntu:16.04 /build/install_cni.sh
