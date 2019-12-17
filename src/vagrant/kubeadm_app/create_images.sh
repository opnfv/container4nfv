#!/bin/bash

# Build images
git clone --recursive https://github.com/Metaswitch/clearwater-docker.git
cd clearwater-docker
for i in base astaire cassandra chronos bono ellis homer homestead homestead-prov ralf sprout
do
    docker build -t clearwater/$i $i
done

