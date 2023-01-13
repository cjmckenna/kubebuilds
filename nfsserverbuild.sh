#!/bin/bash

echo "DOWNLOADING"
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/exports
echo "INSTALLING NFS"
sudo apt install -y nfs-server

echo "MAKE DIR"
sudo mkdir /kubedata
echo "ENABLE NFS"
sudo systemctl enable --now nfs-server
echo "EXPORT FS"
sudo exportfs -ar

