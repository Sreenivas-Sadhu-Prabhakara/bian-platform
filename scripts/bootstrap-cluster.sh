#!/usr/bin/env bash
# One-shot local platform bring-up:
#   kind cluster -> Cilium (CNI+mesh+gateway) -> namespaces -> gateway -> policies -> observability
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INFRA="${HERE}/../platform-infra"

command -v kind >/dev/null || { echo "kind not installed:  brew install kind"; exit 1; }
command -v helm >/dev/null || { echo "helm not installed:  brew install helm"; exit 1; }
command -v kubectl >/dev/null || { echo "kubectl not installed: brew install kubectl"; exit 1; }

echo "==> [1/5] kind cluster 'bian'"
kind get clusters | grep -qx bian || kind create cluster --config "${INFRA}/kind/cluster.yaml"

echo "==> [2/5] Cilium (CNI + eBPF mesh + Gateway API)"
bash "${INFRA}/cilium/install.sh"

echo "==> [3/5] Namespaces (one per BIAN business area)"
kubectl apply -f "${INFRA}/namespaces.yaml"

echo "==> [4/5] Gateway + baseline default-deny policy"
kubectl apply -f "${INFRA}/gateway/gateway.yaml"
kubectl apply -f "${INFRA}/policies/baseline.yaml"

echo "==> [5/5] Observability (Prometheus + Grafana; Hubble came with Cilium)"
bash "${INFRA}/observability/install.sh"

echo
echo "Platform is up. Next:"
echo "  ./build-all.sh    # build + kind-load service images (start with --only ...)"
echo "  ./deploy-all.sh   # helm-install service domains into their namespaces"
