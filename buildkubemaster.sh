#!/bin/bash

# Install NFS server so we can access storage on the SAN

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

echo "Creating keyring directory"

# Meat of the k8s install starts here

# Create Keyring Directory
sudo mkdir -p -m 755 /etc/apt/keyrings

echo "Installing curl and apt-transport-https"

sudo apt -y install curl apt-transport-https

echo "Downloading public signing key"

# Download public signing key
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "Adding repository to APT sources"

# Add the repository to Apt sources:
# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Installing curl, vim, git, wget, kubeadm, kubectl"

sudo apt-get update
sudo apt -y install vim git curl wget kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "Enabling kernel modules"

# Enable kernel modules
sudo modprobe overlay
sudo modprobe br_netfilter

echo "Adding sysctl settings"

# Add some settings to sysctl
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload sysctl
sudo sysctl --system

###############################################################################
# containerd install section
###############################################################################

echo "Installing Containerd"

# Configure persistent loading of modules
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

# Load at runtime
sudo modprobe overlay
sudo modprobe br_netfilter

# Ensure sysctl params are set
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload configs
sudo sysctl --system

# Install required packages
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

# Add Docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install containerd
sudo apt update
sudo apt install -y containerd.io

# Configure containerd and start service
sudo mkdir -p /etc/containerd
sudo containerd config default|sudo tee /etc/containerd/config.toml
sudo sed -i 's/            SystemdCgroup = false/            SystemdCgroup = true/' /etc/containerd/config.toml

# restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd
systemctl status  containerd
sudo systemctl restart kubelet.service

###############################################
# Initialize Cluster
###############################################

echo "INITIALIZING KUBE MASTER"

lsmod | grep br_netfilter

sudo systemctl enable --now kubelet

sudo kubeadm config images pull

sudo kubeadm init \
  --pod-network-cidr=172.24.0.0/16 \
  --cri-socket unix:///run/containerd/containerd.sock

mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sleep 20

kubectl cluster-info

############################################################
# Install Flannel Networking
############################################################

echo "Installing Flannel"

# Needs manual creation of namespace to avoid helm error
kubectl create ns kube-flannel
kubectl label --overwrite ns kube-flannel pod-security.kubernetes.io/enforce=privileged

helm repo add flannel https://flannel-io.github.io/flannel/
helm install flannel --set podCidr="172.24.0.0/16" --namespace kube-flannel flannel/flannel

kubectl taint nodes --all node-role.kubernetes.io/control-plane-

echo "Kubernetes Master Build Completed"

