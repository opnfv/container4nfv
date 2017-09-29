FROM ubuntu:16.04

RUN apt-get update && apt-get install -y isc-dhcp-server
ADD dhcpd.conf /etc/dhcp/dhcpd.conf
ADD isc-dhcp-server /etc/default/isc-dhcp-server
