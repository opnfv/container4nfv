Virlet implementation for OPNFV
=================================

This quickstart shows you how to easily install a Kubernetes cluster on VMs running with Vagrant. The installation uses a tool called kubeadm which is part of Kubernetes.

kubeadm assumes you have a set of machines (virtual or bare metal) that are up and running. In this way we can get a cluster with one master node and 2 workers (default). If you want to increase the number of workers nodes, please check the Vagrantfile inside the project.

About Virlet
------------

(Virlet)[https://github.com/Mirantis/virtlet] is a Kubernetes runtime server / (CRI)[http://blog.kubernetes.io/2016/12/container-runtime-interface-cri-in-kubernetes.html] that enables you to run VM workloads based on QCOW2 images. (CRI is what enables Kubernetes to run non-Docker flavors of containers, such as Rkt.) 

Virlet gives NFV a new direction. Virtlet itself runs as a DaemonSet, essentially acting as a hypervisor and making the CRI proxy available to run the actual VMs. This way, it’s possible to have both Docker and non-Docker pods run on the same node.
