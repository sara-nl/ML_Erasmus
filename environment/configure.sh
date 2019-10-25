#! /bin/bash
export KUBECONFIG="./.kube/kubeconfig"
export NAMESPACE=$(grep 'namespace' $KUBECONFIG | awk '{print $2}')
export TILLER_NAMESPACE=$NAMESPACE

export HELM_TLS_CA_CERT="./pki/${NAMESPACE:3}-ca-tiller-helm-cert.pem"
export HELM_TLS_CERT="./pki/${NAMESPACE:3}-helm-cert.pem"
export HELM_TLS_KEY="./pki/${NAMESPACE:3}-helm-key.pem"
helm init --client-only
