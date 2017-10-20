FROM ubuntu:16.04

WORKDIR /ovsdpdk
RUN apt-get update && apt-get install -y sudo
ADD install.sh .
RUN bash ./install.sh
ADD start.sh .
RUN chmod 755 start.sh
