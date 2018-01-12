Kata Containers implementation for OPNFV
========================================

Kata Containers is a new open source project building extremely lightweight virtual machines that seamlessly plug into the containers ecosystem.

CONTAINER4NFV setup a Kubernetes cluster on VMs running with Vagrant and kubeadm.

kubeadm assumes you have a set of machines (virtual or bare metal) that are up and running. In this way we can get a cluster with one master node and 2 workers (default). If you want to increase the number of workers nodes, please check the Vagrantfile inside the project.

About Kata Containers
---------------------

[Kata Containers](https://katacontainers.io/) is an open source project and community working to build a standard implementation of lightweight Virtual Machines (VMs) that feel and perform like containers, but provide the workload isolation and security advantages of VMs.

The Kata Containers project will initially comprise six components, including the Agent, Runtime, Proxy, Shim, Kernel and packaging of QEMU 2.9. It is designed to be architecture agnostic, run on multiple hypervisors and be compatible with the OCI specification for Docker containers and CRI for Kubernetes.

Kata Containers combines technology from Intel Clear Containers and Hyper runV. The code is hosted on Github under the Apache 2 license and the project is managed by the OpenStack Foundation.
