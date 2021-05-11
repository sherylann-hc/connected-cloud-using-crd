#!/bin/bash
set -v


helm3 repo add hashicorp https://helm.releases.hashicorp.com

echo "applying secret for federation CA and mesh gateway address..."
kubectl apply -f consul-federation-secret.yaml

echo "Installing consul using latest helm chart "
helm install consul hashicorp/consul -f values.yaml --debug

sleep 10s

echo "Configuring Kube to forward consul DNS to consul..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    addonmanager.kubernetes.io/mode: EnsureExists
  name: kube-dns
  namespace: kube-system
data:
  stubDomains: |
    {"consul": ["$(kubectl get svc consul-dns -o jsonpath='{.spec.clusterIP}')"]}
EOF

sleep 2

kubectl delete pod --namespace kube-system -l k8s-app=kube-dns