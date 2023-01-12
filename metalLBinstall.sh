#!/bin/bash
mkdir ~/metallb
cd ~/metallb
curl -O https://raw.githubusercontent.com/cjmckenna/kubebuilds/main/ipaddress_pools.yaml
MetalLB_RTAG=$(curl -s https://api.github.com/repos/metallb/metallb/releases/latest|grep tag_name|cut -d '"' -f 4|sed 's/v//')
echo $MetalLB_RTAG
wget https://raw.githubusercontent.com/metallb/metallb/v$MetalLB_RTAG/config/manifests/metallb-native.yaml
kubectl apply -f metallb-native.yaml
kubectl wait pod --all  -n metallb-system --for=condition=ready
kubectl apply -f  ~/metallb/ipaddress_pools.yaml
kubectl describe ipaddresspools.metallb.io production -n metallb-system
cd ~