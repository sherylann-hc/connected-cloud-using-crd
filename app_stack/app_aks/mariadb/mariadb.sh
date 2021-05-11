#!/bin/bash

#helm install mariadb -f values.yaml bitnami/mariadb

kubectl apply -f mysql.yaml
