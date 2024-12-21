#!/bin/bash
# Prepare server for kube install
echo "DOWNLOADING FILES"
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/buildkubemaster.sh && chmod 777 buildkubemaster.sh
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/metalLBinstall.sh && chmod 777 metalLBinstall.sh
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/kube-dashboard-install.sh && chmod 777 kube-dashboard-install.sh
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/dashboard-admin-account.yaml
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/chris_sudo
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/helmnfs.sh && chmod 777 helmnfs.sh
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/hosts
echo Med!ic8877a | sudo -S cp chris_sudo /etc/sudoers.d/chris_sudo
rm chris_sudo

sudo cp hosts /etc/hosts

echo "TURNING OFF SWAP"
# turn off swap
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab
sudo swapoff -a
sudo mount -a
free -h
echo "INSTALLING HELM"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
echo "UPDATING UBUNTU"
sudo apt update
echo "UPGRADING UBUNTU AND REBOOTING IF REQUIRED"
sudo apt -y full-upgrade
[ -f /var/run/reboot-required ] && sudo reboot -f
