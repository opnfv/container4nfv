Multus implementation for OPNFV
===============================

This quickstart shows you how to easily install a Kubernetes cluster on VMs running with Vagrant and VirtualBox. The installation uses a tool called kubeadm which is part of Kubernetes.

_kubeadm_ assumes you have a set of machines (virtual or real) that are up and running. In this way we can get a cluster with one master node and 2 workers (default). If you want to increase the number of workers nodes, please check the Vagrantfile.


About Multus
-------------

[Multus](https://github.com/Intel-Corp/multus-cni) is a CNI proxy and arbiter of other CNI plugins. 

With the help of Multus CNI plugin, multiple interfaces can be added at the same time when deploying a pod. Notably, Virtual Network Functions (VNFs) are typically requiring connectivity to multiple network interfaces.

The Multus CNI has the following features:
- It is a contact between the container runtime and other plugins, and it doesn't have any of its own net configuration, it calls other plugins like flannel/calico to do the real net conf job.
- Multus reuses the concept of invoking the delegates in flannel, it groups the multi plugins into delegates and invoke each other in sequential order, according to the JSON scheme in the cni configuration.
- Number of plugins supported is dependent upon the number of delegates in the conf file.
Master plugin invokes "eth0" interface in the pod, rest of plugins(Mininon plugins eg: sriov,ipam) invoke interfaces as "net0", "net1".. "netn"
- The "masterplugin" is the only net conf option of Multus cni, it identifies the primary network. The default route will point to the primary network.

Multus example
--------------

.. image:: img/multus_pod_example.png
   :width: 800px
   :alt: Multus Pod example


Quickstart
----------

1. Generate vagrant box opnfv/container4nfv
(Only available for linux environments)
If your host machine use a debian distribution, you won't have problems to run: `containers4nfv/ci/setup_vagrant.sh` script and generate the vagrant-box.

2. Setup
Run `deploy.sh`.
You can manage the number of worker nodes you need inside `Vagrantfile`.
