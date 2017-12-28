FROM ubuntu:16.04

WORKDIR /vpp
RUN apt-get update && apt-get -y install sudo
ADD 01-add-single-file.patch /vpp
ADD 02-fix-nohuge-option.patch /vpp
ADD virtio-user.patch /vpp
ADD build_vpp.sh /vpp
RUN /vpp/build_vpp.sh
