#!/bin/bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/custom-resources.yaml
echo "waiting for all pods to start up"
watch kubectl get pods -n calico-system
echo "Calico install completed"
