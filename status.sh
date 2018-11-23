#!/bin/bash

#************************************************************
# This script outputs the url of the service
#************************************************************

kubectl get pods -o wide

SERVICE_PORT=$(kubectl get svc http-canary-service -o go-template='{{range .spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}')
IP=$(minikube ip)

echo "Service available at http://$IP:$SERVICE_PORT"
