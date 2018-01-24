#!/bin/bash
set -e

sudo apt-get install -y docker.io libvirt-bin virt-manager qemu qemu-efi

WORKSPACE=`pwd`
if [ ! -d "$WORKSPACE/compass4nfv" ]; then
	git clone https://gerrit.opnfv.org/gerrit/compass4nfv
fi

cd compass4nfv

WORKSPACE=`pwd`

COMPASS_WORK_DIR=$WORKSPACE/../compass-work
mkdir -p $COMPASS_WORK_DIR
if [ ! -d "$WORKSPACE/work" ]; then
	ln -s $COMPASS_WORK_DIR work
fi

#TODO: remove workaround after patches merged
if [ ! -f "$WORKSPACE/patched" ]; then

	git checkout a360411cb8c775dffa24a4157cec2b566cbde6f3
	curl http://people.linaro.org/~yibo.cai/compass/0001-deploy-cobbler-drop-tcp_tw_recycle-in-sysctl.conf.patch | git apply || true
	curl http://people.linaro.org/~yibo.cai/compass/0002-docker-compose-support-aarch64.patch | git apply || true
	touch "$WORKSPACE/patched"
fi

# build tarball
COMPASS_ISO_REPO='http://people.linaro.org/~yibo.cai/compass' ./build.sh
