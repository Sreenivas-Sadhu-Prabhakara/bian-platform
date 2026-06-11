#!/usr/bin/env bash
# Phase 3 — GitOps: ArgoCD + an ApplicationSet spanning every sd-* repo on GitHub.
# STAGED: CONFIRM_ARGOCD=yes ./install.sh
# After this, deploys flow from Git: CI pushes an image tag bump; ArgoCD syncs.
set -euo pipefail
[[ "${CONFIRM_ARGOCD:-}" == "yes" ]] || { echo "REFUSING: set CONFIRM_ARGOCD=yes"; exit 1; }
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl -n argocd rollout status deploy/argocd-server --timeout=600s

kubectl apply -f "${HERE}/applicationset.yaml"
echo "ArgoCD up: kubectl -n argocd port-forward svc/argocd-server 8443:443"
echo "Initial admin password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
