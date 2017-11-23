Installation
============

This quickstart shows you how to easily install a Kubernetes cluster on VMs running with Vagrant. You can find the four projects inside `container4nfv/src/vagrant` and their documentation:
- kubeadm_basic: weave.rst
- kubeadm_multus: multus.rst
- kubeadm_ovsdpdk: ovs-dpdk.rst
- kubeadm_virtlet: virtlet.rst

Vagrant is installed in Ubuntu 16.04 64bit.
vagrant is to create kubernetes cluster using kubeadm.
kubernetes installation by kubeadm can be refered to
https://kubernetes.io/docs/getting-started-guides/kubeadm.

e release
=========

Vagrant Setup
-------------

sudo apt-get install -y virtualbox
wget --no-check-certificate https://releases.hashicorp.com/vagrant/1.8.7/vagrant_1.8.7_x86_64.deb
sudo dpkg -i vagrant_1.8.7_x86_64.deb

K8s Setup
---------

git clone http://gerrit.opnfv.org/gerrit/container4nfv -b stable/euphrates
cd container4nfv/src/vagrant/k8s_kubeadm/
vagrant up

Run K8s Example
---------------
vagrant ssh master -c "kubectl apply -f /vagrant/examples/virtio-user.yaml"


K8s Cleanup
-----------

vagrant destroy -f

f release
=========

Vagrant Setup
-------------
1. `setup_vagrant.sh` may install all for you. The project uses vagrant with libvirt as default because of performance.

```
container4nfv/src/vagrant# ./setup_vagrant.sh
```

Consequently, we need to reboot to make libvirtd group effective.

2. Deploy:

To test all the projects inside `vagrant/` just run the next script:

```
container4nfv/ci# ./deploy.sh
```
