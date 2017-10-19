Installation
============

Vagrant is installed in Ubuntu 16.04.
vagrant is to create kubernetes cluster using kubeadm.
kubernetes installation by kubeadm can be refered to
https://kubernetes.io/docs/getting-started-guides/kubeadm.

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
