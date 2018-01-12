# Clearwater implementation for OPNFV


This repository contains instructions and resources for deploying Metaswitch's Clearwater project with Kubernetes.


If you need more information about Clearwater project please checkout our [documentation](https://github.com/opnfv/container4nfv/blob/master/docs/release/userguide/clearwater-project.rst) or the [official repository](https://github.com/Metaswitch/clearwater-docker).



1. Install Docker and Vagrant
CONTAINER4NFV uses `setup_vagrant.sh` to install all resource used by this repository.

```
container4nfv/src/vagrant# ./setup_vagrant.sh -b libvirt

```

2. Deploy Clearwater with kubeadm

Check `clearwater/clearwater_setup.sh` for details about k8s deployment.


```
container4nfv/src/vagrant/kubeadm_clearwater# ./deploy.sh
```

3. Destroy
```
container4nfv/src/vagrant# ./cleanup.sh

```

Exposed Services
---

The deployment exposes:

    - the Ellis web UI on port 30080 for self-provisioning.
    - STUN/TURN on port 3478 for media relay.
    - SIP on port 5060 for service.
    - SIP/WebSocket on port 5062 for service.

SIP devices can register with bono.:5060 and the Ellis provisioning interface can be accessed at port 30080.


Making calls through Clearwater
----


1. Config the SIP client


First, connect to Ellis service to generate the SIP username, password and domain. To connect to Ellist you need:
 - Ellis URL
Use your master ip addres + port 30080 (k8s default port). If you need help finding the ip, try:


```
kubeadm_clearwater# vagrant ssh master
master@vagrant# ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1
```


In your browser connect to `<master_ip>:30080`. Example: 192.168.121.3:30080.
.


After that, signup and generate two users. The signup key is **secret**. Ellis will automatically allocate you a new number and display its password to you. Remember this password as it will only be displayed once. From now on, we will use <username> to refer to the SIP username (e.g. 6505551234) and <password> to refer to the password.


2. Config and install two SIP clients

[WIP]


3. From one client, dial the <username> of the other client to make the call. Answer the call and check you have two-way media.
