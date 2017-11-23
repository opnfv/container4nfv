Quickstart
----------

This quickstart shows you how to easily install a Kubernetes cluster on VMs running with Vagrant. You can find the four projects inside `container4nfv/src/vagrant` and their documentation: 
- kubeadm_basic: nginx.rst
- kubeadm_multus: multus.rst
- kubeadm_ovsdpdk: ovs-dpdk.rst
- kubeadm_virtlet: virtlet.rst

We recommend to use *Ubuntu 16.04*.
1. `setup_vagrant.sh` may install all for you. The project uses vagrant with libvirt as default because of performance. 

```
container4nfv/src/vagrant# ./setup_vagrant.sh
``` 

2. Deploy:

To test all the projects inside `vagrant/` just run the next script:

```
container4nfv/ci# ./deploy.sh
```

