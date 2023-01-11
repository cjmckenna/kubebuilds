#!/bin/bash
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
kubectl wait pod --all  --all-namespaces --for=condition=ready
echo "Calico install completed"