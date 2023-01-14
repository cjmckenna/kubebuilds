#!/bin/bash

echo "DOWNLOADING"
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/exports
echo "INSTALLING NFS"
sudo apt install -y nfs-server

echo "MAKE DIR"
sudo mkdir /kubedata
sudo chmod -R 777 /kubedata
echo "COPYING EXPORTS FILE"
sudo cp exports /etc/exports
echo "ENABLE NFS"
sudo systemctl enable --now nfs-server
echo "EXPORT FS"
sudo exportfs -ar

