#!/usr/bin/env bash

# Set variables
GIT_USER=<GIT-USER>
GIT_TOKEN=<GIT-TOKEN>
SEALEDSECRET_NAMESPACE=sealed-secrets

# Create Kubernetes Secret yaml
cat <<EOF > delete-gitops-cd-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: gitops-cd-secret
  annotations:
    tekton.dev/git-0: https://github.com 
type: kubernetes.io/basic-auth
stringData:
  username: ${GIT_USER}
  password: ${GIT_TOKEN}
EOF

# Encrypt the secret using kubeseal and private key from the cluster
kubeseal --scope cluster-wide --controller-name=sealedsecretcontroller-sealed-secrets --controller-namespace=${SEALEDSECRET_NAMESPACE} -o yaml < delete-gitops-cd-secret.yaml > gitops-cd-secret.yaml

# NOTE, do not check delete-ibm-entitled-key-secret.yaml into git!
rm delete-gitops-cd-secret.yaml