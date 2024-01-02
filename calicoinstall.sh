#!/bin/bash
kubectl create -f tigera-operator.yaml
kubectl create -f custom-resources.yaml
echo "waiting for all pods to start up"
kubectl wait pod --all  --all-namespaces --for=condition=ready --timeout=-300s
echo "Calico install completed"
