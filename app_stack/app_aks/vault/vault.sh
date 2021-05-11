#!/bin/bash
set -v

# Clone the repo
helm repo add hashicorp https://helm.releases.hashicorp.com

helm install vault hashicorp/vault -f values.yaml --debug

sleep 60s




