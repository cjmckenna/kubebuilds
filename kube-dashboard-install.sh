#!/bin/bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl patch service kubernetes-dashboard -p '{"spec":{"type":"LoadBalancer"}}' -n kubernetes-dashboard
kubectl apply -f dashboard-admin-account.yaml
kubectl -n kubernetes-dashboard create token admin-user