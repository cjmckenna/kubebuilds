#!/bin/bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/custom-resources.yaml
echo "waiting for all pods to start up"
kubectl wait pod --all  --all-namespaces --for=condition=ready --timeout=-300s
echo "Calico install completed"
