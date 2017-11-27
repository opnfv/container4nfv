#!/bin/bash
set -ex

DIR="$(dirname `readlink -f $0`)"

cd $DIR
sudo docker run -v $DIR:/src -v /tmp:/opt/vpp ubuntu:16.04 /src/install_vpp.sh
