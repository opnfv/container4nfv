=================================================================
Linux Kernel Build Guide on MACCHIATObin for Edge Infrastructure
=================================================================

The Marvell MACCHIATObin is a family of cost-effective and high-performance networking community boards targeting ARM64bit high end networking and storage applications.
With a offering that include a fully open source software that include U-Boot, Linux, ODP and DPDK, the Marvell MACCHIATObin are optimal platforms for community developers and Independent Software Vendors (ISVs) to develop networking and storage applications.
The default kernel configuration provided by Marvell does not meet the container's system requirements.
We provide a kernel configuration file that has been verified on the MACCHIATObin board for developers to use, as well as a verified kernel image for the edge infrastructure deployment.


Build From Source
=================

The procedures to build kernel from source is almost the same, but there are still some points you need to pay attention to on MACCHIATObin board.

Download Kernel Source::

	mkdir -p ~/kernel/4.14.22
	cd ~/kernel/4.14.22
	git clone https://github.com/MarvellEmbeddedProcessors/linux-marvell .
	git checkout linux-4.14.22-armada-18.09

Download MUSDK Package
Marvell User-Space SDK(MUSDK) is a light-weight user-space I/O driver for Marvell's Embedded Networking SoC's. The MUSDK library provides a simple and direct access to Marvell's SoC blocks to networking applications and networking infrastrucutre::

	mkdir -p ~/musdk
	git clone https://github.com/MarvellEmbeddedProcessors/musdk-marvell .
	git checkout musdk-armada-18.09

Patch Kernel
Linux Kernel needs to be patched and built in order to run MUSDK on the MACCHIATObin board::

	cd ~/kernel/4.14.22/
	git am ~/musdk/patches/linux-4.14/*.patch

Build & Install
First, replace the default kernel configuration file with defconfig-mcbin-edge::

	cp defconfig-mcbin-edge   ~/kernel/4.14.22/arch/arm64/configs/mvebu_v8_lsp_defconfig

and then compile the kernel::

	export ARCH=arm64
	make mvebu_v8_lsp_defconfig
	make -j$(($(nproc)+1))

	make modules_install
	cp ./arch/arm64/boot/Image /boot/
	cp ./arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtb  /boot/

Script is provided to facilitate the build of the kernel image, the developer needs to run with root privileges::

	./setup-macbin-kernel.sh

Quick Deployment
================

The image file in the compressed package can also quickly build the edge system, you need to execute the following instructions::
	git clone https://github.com/Jianlin-lv/Kernel-for-Edge-System.git
	tar zxvf mcbin-double-shot-linux-4.14.22.tar.gz
	cd mcbin-double-shot-linux-4.14.22
	cp Image  /boot/Image
	cp armada-8040-mcbin.dtb  /boot/armada-8040-mcbin.dtb
	cp -rf ./lib/modules/4.14.22-armada-18.09.3-ge9aff6a-dirty/ /lib/modules/

Other
=====
Marvell provides guidance on the build toolchain, file system and bootloader, which can be found at the link below:
http://wiki.macchiatobin.net/tiki-index.php?page=Wiki+Home

