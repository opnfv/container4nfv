***********************************
Clearwater implementation for OPNFV
***********************************

CONTAINER4NFV setup a Kubernetes cluster on VMs running with Vagrant and kubeadm.

kubeadm assumes you have a set of machines (virtual or bare metal) that are up and running. In this way we can get a cluster with one master node and 2 workers (default). If you want to increase the number of workers nodes, please check the Vagrantfile inside the project.


*Is Clearwater suitable for Network Functions Virtualization?*

Network Functions Virtualization or NFV is, without any doubt, the hottest topic in the telco network space right now.  It’s an approach to building telco networks that moves away from proprietary boxes wherever possible to use software components running on industry-standard virtualized IT infrastructures.  Over time, many telcos expect to run all their network functions operating at Layer 2 and above in an NFV environment, including IMS.  Since Clearwater was designed from the ground up to run in virtualized environments and take full advantage of the flexibility of the Cloud, it is extremely well suited for NFV.  Almost all of the ongoing trials of Clearwater with major network operators are closely associated with NFV-related initiatives.


About Clearwater
################

`Clearwater <http://www.projectclearwater.org/about-clearwater/>`_ follows `IMS <https://en.wikipedia.org/wiki/IP_Multimedia_Subsystem>`_ architectural principles and supports all of the key standardized interfaces expected of an IMS core network.  But unlike traditional implementations of IMS, Clearwater was designed from the ground up for the Cloud.  By incorporating design patterns and open source software components that have been proven in many global Web applications, Clearwater achieves an unprecedented combination of massive scalability and exceptional cost-effectiveness.

Clearwater provides SIP-based call control for voice and video communications and for SIP-based messaging applications.  You can use Clearwater as a standalone solution for mass-market VoIP services, relying on its built-in set of basic calling features and standalone susbscriber database, or you can deploy Clearwater as an IMS core in conjunction with other elements such as Telephony Application Servers and a Home Subscriber Server.

Clearwater was designed from the ground up to be optimized for deployment in virtualized and cloud environments. It leans heavily on established design patterns for building and deploying massively scalable web applications, adapting these design patterns to fit the constraints of SIP and IMS. `The Clearwater architecture <http://www.projectclearwater.org/technical/clearwater-architecture/>`_ therefore has some similarities to the traditional IMS architecture but is not identical.

- All components are horizontally scalable using simple, stateless load-balancing.
- All long lived state is stored on dedicated “Vellum” nodes which make use of cloud-optimized storage technologies such as Cassandra. No long lived state is stored on other production nodes, making it quick and easy to dynamically scale the clusters and minimizing the impact if a node is lost.
- Interfaces between the front-end SIP components and the back-end services use RESTful web services interfaces.
- Interfaces between the various components use connection pooling with statistical recycling of connections to ensure load is spread evenly as nodes are added and removed from each layer.


Clearwater Architecture
#######################

.. image:: img/clearwater_architecture.png
   :width: 800px
   :alt: Clearwater Architecture


**********
Quickstart
**********

This repository contains instructions and resources for deploying Metaswitch's Clearwater project with Kubernetes.


If you need more information about Clearwater project please checkout our
[documentation](https://github.com/opnfv/container4nfv/blob/master/docs/release/userguide/clearwater-project.rst)
or the `official repository <https://github.com/Metaswitch/clearwater-docker>`_.


Exposed Services
################


The deployment exposes:

    - the Ellis web UI on port 30080 for self-provisioning.
    - STUN/TURN on port 3478 for media relay.
    - SIP on port 5060 for service.
    - SIP/WebSocket on port 5062 for service.

SIP devices can register with bono.:5060 and the Ellis provisioning interface can be accessed at port 30080.


Prerequirement
##############

Install Docker and Vagrant
********************************************

CONTAINER4NFV uses ``setup_vagrant.sh`` to install all resource used by this repository.

::

    container4nfv/src/vagrant# ./setup_vagrant.sh -b libvirt

Instalation
##############

Deploy Clearwater with kubeadm
********************************************

Check ``clearwater/clearwater_setup.sh`` for details about k8s deployment.


::

    container4nfv/src/vagrant/kubeadm_clearwater# ./deploy.sh


Destroy
##########

::

    container4nfv/src/vagrant# ./cleanup.sh


Making calls through Clearwater
###############################


Connect to Ellis service
********************************************
It's important to connect to Ellis to generate the SIP username, password and domain we will use with the SIP client.
Use your <master ip addres> + port 30080 (k8s default port). If you are not which Ellis's url is, please check inside your master node.

::

    kubeadm_clearwater# vagrant ssh master
    master@vagrant# ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1
    192.168.121.3

In your browser connect to `<master_ip>:30080` (ex. 192.168.121.3:30080).


After that, signup and generate two users. The signup key is **secret**. Ellis will automatically allocate you a new number and display
its password to you. Remember this password as it will only be displayed once.
From now on, we will use <username> to refer to the SIP username (e.g. 6505551234) and <password> to refer to the password.


Config and install two SIP clients
********************************************
We'll use both Twinkle and Blink SIP client. , since we are going to try this out inside a LAN network.
This is, of course, only a local test inside a LAN network. Configure the clients may be a little bit trickie, so we add some screenshots:


Blink setup
********************************************
1. Add <username> and <password>.

.. image:: img/blink01.png
   :width: 800px
   :alt: Blink SIP client


2. Configure a proxy to k8s.


.. image:: img/blink02.png
   :width: 800px
   :alt: Blink SIP client


3. Configure the network to use TCP only.


.. image:: img/blink03.png
   :width: 800px
   :alt: Blink SIP client


.. image:: img/blink04.png
   :width: 800px
   :alt: Blink SIP client


Twinkle setup
********************************************

1. Configure a proxy to k8s.


.. image:: img/twinkle01.png
   :width: 800px
   :alt: Twinkle SIP client


2. Add <username> and <password>.


.. image:: img/twinkle02.png
   :width: 800px
   :alt: Twinkle SIP client


3. Configure the network to use TCP only.


.. image:: img/twinkle03.png
   :width: 800px
   :alt: Twinkle SIP client


Make the call
********************************************


.. image:: img/call.png
   :width: 800px
   :alt: Call
