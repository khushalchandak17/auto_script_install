#!/bin/bash
configure_ubuntu() {
  echo "Configuring Ubuntu OS for Rancher Ready..."
# Ubuntu instructions
# stop the software firewall
systemctl disable --now ufw

# get updates, install nfs, and apply

apt-mark hold linux-image-*
apt update
apt install nfs-common curl -y
apt upgrade -y
apt-mark unhold linux-image-*
# clean up

#Install curl
sudo apt install -y curl

# Install jq
sudo apt install -y jq

# Install yq
sudo add-apt-repository ppa:rmescandon/yq
sudo apt update
sudo apt install -y yq


apt autoremove -y

}
configure_ubuntu
