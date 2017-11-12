#!/bin/bash

set -ex
DIR="$(dirname `readlink -f $0`)"

cd $DIR
vagrant up
vagrant destroy -f
