#!/bin/bash
#
# Copyright (c) 2017 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -ex

# http://clearwater.readthedocs.io/en/latest/Running_the_live_tests.html
sudo apt-get install build-essential bundler git --yes
sudo apt install gnupg2 --yes
gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -L https://get.rvm.io | bash -s stable

source ~/.rvm/scripts/rvm
rvm autolibs enable
rvm install 1.9.3
rvm use 1.9.3


# Setup ruby and gems
git clone https://github.com/Metaswitch/clearwater-live-test.git
cd clearwater-live-test/
cd quaff/ && git clone https://github.com/Metaswitch/quaff.git
cd ..
bundle install

# Get Ellis ip
ellisip=$(kubectl get services ellis  -o json | grep clusterIP | cut -f4 -d'"') 

# Get Ellis ip
bonoip=$(kubectl get services bono  -o json | grep clusterIP | cut -f4 -d'"') 

# Run the tests
rake test[default.svc.cluster.local] SIGNUP_CODE=secret PROXY=$bonoip ELLIS=$ellisip
