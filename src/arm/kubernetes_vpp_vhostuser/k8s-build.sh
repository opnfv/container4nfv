#!/bin/bash
set -e


sudo apt-get install -y docker.io libvirt-bin virt-manager qemu qemu-efi

WORKSPACE=`pwd`
if [ ! -d "$WORKSPACE/compass4nfv" ]; then
        git clone https://gerrit.opnfv.org/gerrit/compass4nfv
fi

#rm -rf compass4nfv
#git clone https://gerrit.opnfv.org/gerrit/compass4nfv

cd compass4nfv

COMPASS_WORK_DIR=$WORKSPACE/../compass-work
mkdir -p $COMPASS_WORK_DIR
ln -s $COMPASS_WORK_DIR work

sudo docker rm -f `docker ps | grep compass | cut -f1 -d' '` || true

curl -s http://people.linaro.org/~yibo.cai/compass/compass4nfv-arm64-fixup.sh | bash || true

./build.sh
