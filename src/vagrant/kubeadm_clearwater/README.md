# Clearwater implementation for OPNFV


This repository contains instructions and resources for deploying Metaswitch's Clearwater project with Kubernetes.


If you need more information about Clearwater project please checkout our
[documentation](https://github.com/opnfv/container4nfv/blob/master/docs/release/userguide/clearwater-project.rst)
or the [official repository](https://github.com/Metaswitch/clearwater-docker).


## Exposed Services


The deployment exposes:

    - the Ellis web UI on port 30080 for self-provisioning.
    - STUN/TURN on port 3478 for media relay.
    - SIP on port 5060 for service.
    - SIP/WebSocket on port 5062 for service.

SIP devices can register with bono.:5060 and the Ellis provisioning interface can be accessed at port 30080.


## Prerequirement

### Install Docker and Vagrant
CONTAINER4NFV uses `setup_vagrant.sh` to install all resource used by this repository.


```
container4nfv/src/vagrant# ./setup_vagrant.sh -b libvirt

```


## Instalation
### Deploy Clearwater with kubeadm

Check `clearwater/clearwater_setup.sh` for details about k8s deployment.


```
container4nfv/src/vagrant/kubeadm_clearwater# ./deploy.sh
```

## Destroy


```
container4nfv/src/vagrant# ./cleanup.sh

```


### Making calls through Clearwater


## Connect to Ellis service
It's important to connect to Ellis to generate the SIP username, password and domain we will use with the SIP client.
Use your <master ip addres> + port 30080 (k8s default port). If you are not which Ellis's url is, please check inside your master node.

```
kubeadm_clearwater# vagrant ssh master
master@vagrant# ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1
192.168.121.3
```

In your browser connect to `<master_ip>:30080` (ex. 192.168.121.3:30080).


After that, signup and generate two users. The signup key is **secret**. Ellis will automatically allocate you a new number and display
its password to you. Remember this password as it will only be displayed once.
From now on, we will use <username> to refer to the SIP username (e.g. 6505551234) and <password> to refer to the password.


## Config and install two SIP clients
We'll use both Twinkle and Blink SIP client. , since we are going to try this out inside a LAN network.
This is, of course, only a local test inside a LAN network. Configure the clients may be a little bit trickie, so we add some screenshots:

#### Blink setup
1. Add <username> and <password>.


![Alt text](imgs/blink01.png?raw=true "Blink")


2. Configure a proxy to k8s.


![Alt text](imgs/blink02.png?raw=true "Blink")


3. Configure the network to use TCP only.


![Alt text](imgs/blink03.png?raw=true "Blink")

![Alt text](imgs/blink04.png?raw=true "Blink")


#### Twinkle setup
1. Configure a proxy to k8s.


![Alt text](imgs/twinkle01.png?raw=true "Twinkle")


2. Add <username> and <password>.


![Alt text](imgs/twinkle02.png?raw=true "Twinkle")


3. Configure the network to use TCP only.


![Alt text](imgs/twinkle03.png?raw=true "Twinkle")


#### Make the call
![Alt text](imgs/call.png?raw=true "SIP call")




