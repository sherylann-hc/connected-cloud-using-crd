#!/bin/bash
set -v

kubectl config view -o json | jq -r '.contexts[].name'  >> KCONFIG.txt

kubectl config use-context $(grep 'aks$' KCONFIG.txt)

sleep 1

 cd app_stack/app_aks/

./full_stack_deploy.sh

  kubectl wait --timeout=120s --for=condition=Ready $(kubectl get pod --selector=app=k8s-tranist-app -o name)
 
 sleep 1s

 cd ../../

 kubectl config use-context $(grep gke KCONFIG.txt)

 sleep 1

 cd app_stack/app_gke/consul-mesh/

 ./consul.sh

 sleep 10

 cd ../../../

#   kubectl config use-context $(grep arn KCONFIG.txt)

#   sleep10

#  cd app_stack/app_eks/consul-mesh/

#  ./consul.sh

 sleep 10

 echo "mesh complete"

#  cd ../../../

#  rm "KCONFIG.txt" 
