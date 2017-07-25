#!/bin/bash

chmod 700 ~/.ssh
chmod 600 ~/.ssh
sudo service ssh restart
while true ; do sleep 10000; done
