#!/bin/bash
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
helm install nfs-subdir-external-provisioner \
nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
--set nfs.server=10.101.10.5 \
--set nfs.path=/kubedata \
--set storageClass.onDelete=true
kubectl get storageclass nfs-client
