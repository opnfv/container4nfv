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

# Scenario sequence rules:
#     - stable first
#     - less time consuming first
SCENARIOS="kubeadm_basic
    kubeadm_virtlet
    kubeadm_ovsdpdk
    kubeadm_istio
    kubeadm_kata
"

DEFAULT_TIMEOUT=3600

for SCENARIO in $SCENARIOS; do
    START=$(date +%s)
    timeout ${DEFAULT_TIMEOUT} ../src/vagrant/${SCENARIO}/deploy.sh
    END=$(date +%s)
    DIFF=$(( $END - $START ))
    echo "Scenario $SCENARIO tooks $DIFF seconds."
done
