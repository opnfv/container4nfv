#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y ruby-dev rubygems-integration python-pip rpm createrepo dpkg-dev
sudo gem install fpm
sudo pip install fuel-plugin-builder
cp -r /fuel-plugin /home/vagrant
cd /home/vagrant/fuel-plugin; fpb --debug --build .
cp /home/vagrant/fuel-plugin/*.rpm /vagrant
