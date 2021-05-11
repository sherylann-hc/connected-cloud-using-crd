#!/bin/bash
set -v

cd vault

./vault.sh

sleep 5

./vault_setup.sh

cd ..

kubectl apply -f ./application_deploy_sidecar

kubectl get svc k8s-transit-app

echo ""
echo "use the following command to get your demo IP, port is 5000"
echo "$ kubectl get svc k8s-transit-app"
