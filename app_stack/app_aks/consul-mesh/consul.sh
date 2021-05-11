#!/bin/bash
set -v

echo "hello"

helm repo add hashicorp https://helm.releases.hashicorp.com

echo "Creating gossip encryption key..."
kubectl create secret generic consul-gossip-encryption-key --from-literal=key="$(consul keygen)"

echo "Installing consul using latest helm chart "
helm install consul hashicorp/consul -f values.yaml --debug
 
echo "As this is the primary datacenter for federation, fetch the federation secret and store in local file.."
kubectl get secret  consul-federation -o yaml > consul-federation-secret.yaml

cp consul-federation-secret.yaml ../../app_gke/consul-mesh 

cp consul-federation-secret.yaml ../../app_EKS/consul-mesh 

echo "Configuring Kube to forward consul DNS to consul..."

kubectl apply -f customdns.yaml

sleep 10

cat <<EOF | kubectl apply -f -
apiVersion: consul.hashicorp.com/v1alpha1
kind: ServiceIntentions
metadata:
  name: consul-intentions
spec:
  destination:
    name: '*'
  sources:
    - name: '*'
      action: allow
EOF

kubectl get secrets/consul-bootstrap-acl-token --template={{.data.token}} | base64 -d > bootstrap_token.txt

# kubectl run -i --tty --image busybox:1.28 dns-test --restart=Never --rm nslookup  consul.service.consul
