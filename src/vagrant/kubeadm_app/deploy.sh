#!/bin/bash

set -ex
DIR="$(dirname `readlink -f $0`)"

cd $DIR
../cleanup.sh
vagrant up
vagrant ssh master -c "/vagrant/clearwater_setup.sh"

# Run tests
vagrant ssh master -c "/vagrant/tests/clearwater-live-test.sh"
