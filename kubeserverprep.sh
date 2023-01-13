#!/bin/bash
# Prepare server for kube install
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/kubemasterbuild.sh && chmod 777 kubemasterbuild.sh
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/kubemasterbuild.sh && chmod 777 kubenodebuild.sh
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/exports
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/nfsserverbuild.sh && chmod 777 nfsserverbuild.sh
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/calicoinstall.sh && chmod 777 calicoinstall.sh
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/chris_sudo
echo medic8877 | sudo -S cp chris_sudo /etc/sudoers.d/chris_sudo
rm chris_sudo
# turn off swap
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab
sudo swapoff -a
sudo mount -a
free -h
sudo apt update
sudo apt -y full-upgrade
[ -f /var/run/reboot-required ] && sudo reboot -f