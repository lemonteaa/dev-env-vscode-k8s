#!/bin/bash

ytt -f schema.yaml -f patch-svc.yaml --data-value-yaml port=$1 | kubectl patch svc test-serv --type json -p "$(cat -)"
ytt -f schema.yaml -f ingress.yaml --data-value-yaml port=$1 | kubectl apply -f -
