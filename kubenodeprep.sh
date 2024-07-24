#!/bin/bash
# Prepare server for kube install
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/kubenodebuild.sh && chmod 777 kubenodebuild.sh
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/chris_sudo
echo medic8877 | sudo -S cp chris_sudo /etc/sudoers.d/chris_sudo
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/hosts

sudo cp hosts /etc/hosts

rm chris_sudo
# turn off swap
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab
sudo swapoff -a
sudo mount -a
free -h
sudo apt install -y nfs-common
sudo apt update
sudo apt -y full-upgrade
[ -f /var/run/reboot-required ] && sudo reboot -f
