# Clearwater implementation for OPNFV


This repository contains instructions and resources for deploying Metaswitch's Clearwater project with Kubernetes.


If you need more information please checkout Clearwater's
[documentation](https://github.com/opnfv/container4nfv/blob/master/docs/release/userguide/clearwater-project.rst)
or the [official repository](https://github.com/Metaswitch/clearwater-docker).

## Pre requisites
Container4nfv setup a Kubernetes cluster on VMs running with Vagrant and kubeadm.
Kubernetes bootstrapped with kubeadm is known to work on the following Linux distributions:

    Ubuntu 16.04
    Fedora release 25

   Sadly, **we only support Ubuntu 16.04.** We are trying to add more support. You are welcome
to contribute via Pull Requests if you can.

## Quick start Guide
1. **Install Docker and Vagrant**


Container4nfv uses `setup_vagrant.sh` script to install vagrant, libvirt and virtualBox.

```
container4nfv/src/vagrant# ./setup_vagrant.sh -b libvirt
```

2. **Deploy Clearwater**

Check `clearwater_setup.sh` for details about k8s deployment.


```
container4nfv/src/vagrant/kubeadm_clearwater# ./deploy.sh
```
3. **Making calls through Clearwater** [0]

-  First, connect to *Ellis* web server to generate the SIP username, password and domain.


Ellis URL: `<master_ip>:30080`. If you need help finding  `<master_ip>` try:
```
kubeadm_clearwater# vagrant ssh master
master@vagrant# ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1
192.168.121.3
```

- After that, sign up and generate two users. The sign up key is `secret`. Ellis will automatically
allocate you a new number and display its password to you. Remember this password as it will only be
displayed once.

- Finally, configure and install two SIP clients. From one client, dial the <username> of the other
client to make the call. Answer the call and check you have two-way media.

4. **Destroy**
```
container4nfv/src/vagrant# ./cleanup.sh
```


# Exposed Services


The deployment exposes:

    - the Ellis web UI on port 30080 for self-provisioning.
    - STUN/TURN on port 3478 for media relay.
    - SIP on port 5060 for service.
    - SIP/WebSocket on port 5062 for service.

SIP devices can register with bono.:5060 and the Ellis provisioning interface can be accessed at port 30080.

[0]: [Clearwater official documentation](http://clearwater.readthedocs.io/en/stable/Making_your_first_call.html)
