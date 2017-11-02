#!/bin/bash

set -ex
HOME="$(dirname `readlink -f $0`)"

cd $HOME
vagrant up
vagrant destroy -f
