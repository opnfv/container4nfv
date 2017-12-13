Ovsdpdk implementation for OPNFV
=================================

This quickstart shows you how to easily install a Kubernetes cluster on VMs running with Vagrant. The installation uses a tool called kubeadm which is part of Kubernetes.

kubeadm assumes you have a set of machines (virtual or bare metal) that are up and running. In this way we can get a cluster with one master node and 2 workers (default). If you want to increase the number of workers nodes, please check the Vagrantfile inside the project.

About OvS-dpdk
--------------

Open vSwitch* with the Data Plane Development Kit [OvS-DPDK](http://openvswitch.org/) is a high performance, open source virtual switch.

Using DPDK with OVS gives us tremendous performance benefits. Similar to other DPDK-based applications, we see a huge increase in network packet throughput and much lower latencies.
