#!/bin/bash

# Prepare server for kube install

wget https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/kubemasterbuild.sh

wget https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/sudoers

sudo cp sudoers /etc/sudoers

rm sudoers

# turn off swap

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

sudo sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab

sudo swapoff -a

sudo mount -a

free -h

sudo apt update
sudo apt -y full-upgrade
[ -f /var/run/reboot-required ] && sudo reboot -f