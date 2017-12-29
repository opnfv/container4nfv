FROM ubuntu:16.04

RUN apt-get update && apt-get install -y isc-dhcp-server iproute2
ADD dhcpd.conf /etc/dhcp/dhcpd.conf
ADD isc-dhcp-server /etc/default/isc-dhcp-server
ADD start.sh /usr/local/bin/start.sh
