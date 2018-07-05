sudo swapoff -a
sudo fallocate -l 50G /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon --show
