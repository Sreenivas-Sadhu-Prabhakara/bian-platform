#!/usr/bin/env bash
# Install Cilium (CNI + mesh + Gateway API) into the current kube context.
# Assumes a kind cluster created from ../kind/cluster.yaml (no CNI, no kube-proxy).
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CILIUM_VERSION="${CILIUM_VERSION:-1.16.5}"

# Gateway API CRDs must exist BEFORE Cilium starts, or gatewayAPI.enabled is a no-op.
GATEWAY_API_VERSION="${GATEWAY_API_VERSION:-v1.2.1}"
echo "==> Installing Gateway API CRDs ${GATEWAY_API_VERSION}"
for crd in gateways gatewayclasses httproutes referencegrants grpcroutes; do
  kubectl apply -f "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${GATEWAY_API_VERSION}/config/crd/standard/gateway.networking.k8s.io_${crd}.yaml"
done

echo "==> Installing Cilium ${CILIUM_VERSION}"
helm repo add cilium https://helm.cilium.io >/dev/null
helm repo update cilium >/dev/null

# kind: the API server from inside the cluster
API_HOST="$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}' | awk '{print $1}')"

helm upgrade --install cilium cilium/cilium \
  --version "${CILIUM_VERSION}" \
  --namespace kube-system \
  -f "${HERE}/values.yaml" \
  --set k8sServiceHost="${API_HOST}" \
  --set k8sServicePort=6443

echo "==> Waiting for Cilium to be ready"
kubectl -n kube-system rollout status ds/cilium --timeout=300s
echo "==> Cilium installed. Hubble UI: kubectl -n kube-system port-forward svc/hubble-ui 12000:80"
