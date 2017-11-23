Multus implementation for OPNFV
=======

About Multus
-------------

[Multus](https://github.com/Intel-Corp/multus-cni) is a CNI proxy and arbiter of other CNI plugins. 

Usually pods can host containers supporting service-provisioning applications or virtual network functions (VNFs) that are typically requiring connectivity to multiple network interfaces. Multus invokes other CNI plugins for network interface creation. In this way multus allow multi interface support in a pod.

Setup
-------------

Run `deploy.sh`. You can manage the number of worker nodes you need inside `Vagrantfile`..

