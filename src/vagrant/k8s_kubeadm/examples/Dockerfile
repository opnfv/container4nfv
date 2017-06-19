FROM opnfv/yardstick

RUN apt-get install -y apt-transport-https
RUN curl -s http://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
RUN echo "deb http://apt.kubernetes.io/ kubernetes-trusty main" | tee /etc/apt/sources.list.d/kubernetes.list

RUN apt-get update -y
RUN apt-get install -y sudo openssh-server inetutils-ping kubectl
