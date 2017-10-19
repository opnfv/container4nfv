#!/bin/bash

BUILD=`pwd`

sudo docker build -t multus.build . -f Dockerfile.build
sudo docker run -v $BUILD:/build -ti multus.build cp multus-cni/bin/multus /build 
sudo docker build -t openretriever/cnimultus . -f Dockerfile.multus
sudo docker push openretriever/cnimultus
rm -rf multus
