#!/bin/bash
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/exports
sudo cp exports /etc/exports
sudo apt install -y nfs-server
sudo mkdir /kubedata
sudo systemctl enable --now nfs-server
sudo exportfs -ar

