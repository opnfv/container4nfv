FROM ubuntu:16.04

WORKDIR /vpp
RUN apt-get update && apt-get -y install sudo vim net-tools iproute2 python
ADD bin /vpp/bin
ADD startup.conf /vpp
ADD setup_vpp.sh /vpp
