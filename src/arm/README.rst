.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) OPNFV, arm Limited.

.. _Compass4nfv: https://wiki.opnfv.org/display/compass4nfv/Compass4nfv
.. _repo: https://gerrit.opnfv.org/gerrit/#/admin/projects/container4nfv
.. _Flannel: https://github.com/coreos/flannel

===============================================
Kubernetes Deployment on arm Installation Guide
===============================================

Kubernetes deployement on arm64 server is now supported. This document give the basic installation
guide for common things between different scenarios. The user can refer the installation script in each
scenario for details.
Kubernetes deployment scenarios on arm is based on Compass4nfv_. Arm has given patches to enable some certain
scenarios to the Compass4nfv repo_.
Typically it would deploy 2 VMs(hosts) in which one(host1) is deployed as Kubernetes Master and node,
the other(host2) as Kubernetes node.
The basic Kubernetes cluster would use Flannel_ as the container networking scheme. 


Installation Enviroment Preparation
===================================

.. _architecture: https://github.com/opnfv/compass4nfv/blob/master/docs/release/installation/k8s-deploy.rst

The installed Kubernetes cluster architecture could refer the deployment architecture_ of Compass4nfv.

Jumphost: Ubuntu16.04(xenial) aarch64

* *1* Enable password-less sudo for current user
* *2* Disable DHCP of libvirt default network

::
     Libvirt creates a default network at intallation, which enables DHCP and occupies port 67.
     It conflicts with compass-cobbler container.
     $ sudo virsh net-edit default
     <!-- remove below lines and save/quit ->
     <dhcp>
     <range start='192.168.122.2' end='192.168.122.254'/>
     </dhcp>
     $ sudo virsh net-destroy default
     $ sudo virsh net-start default

* *3* Make sure ports 67,69,80,443 are free

::
    Compass-cobber requires ports 67, 69 to provide DHCP and TFTP services. Compass-deck provides
    HTTP and HTTPS through ports 80, 443. All these ports should be free before deployment.

* *4* Teardown apparmo "sudo service apparmor teardown"


Installation Steps
==================

Run the setup script to deploy your needed scenario:

./setup.sh

which would call k8s-build.sh and k8s-deploy.sh to deploy a Kubernetes cluster

Or you can run them separately:

./k8s-build.sh
./k8s-deploy.sh

The whole installation would take 30min~2hours which mainly depends on how long you get the needed
images from the network.


Contacts
========

Trevor Tao(Zijin Tao), Yibo Cai, Di Xu and Bin Lu from Arm have made contributions to this document.

Trevor Tao: trevor.tao@arm.com
Yibo Cai:   yibo.cai@arm.com
Di Xu:      di.xu@arm.com
Bin Lu:     bin.lu@arm.com

