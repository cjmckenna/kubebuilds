#!/bin/bash
kubectl create -f tigera-operator.yaml
kubectl create -f custom-resources.yaml
echo "waiting for all pods to start up"
watch kubectl get pods -n tigera-operator
echo "Calico install completed"
