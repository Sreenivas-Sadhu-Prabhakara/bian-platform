#!/usr/bin/env bash
# Phase 4 — chaos engineering. STAGED: CONFIRM_CHAOS=yes ./install.sh
set -euo pipefail
[[ "${CONFIRM_CHAOS:-}" == "yes" ]] || { echo "REFUSING: set CONFIRM_CHAOS=yes"; exit 1; }
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

helm repo add chaos-mesh https://charts.chaos-mesh.org >/dev/null
helm repo update chaos-mesh >/dev/null
helm upgrade --install chaos-mesh chaos-mesh/chaos-mesh -n chaos-mesh --create-namespace \
  --set chaosDaemon.runtime=containerd \
  --set chaosDaemon.socketPath=/run/containerd/containerd.sock
kubectl -n chaos-mesh rollout status deploy/chaos-controller-manager --timeout=300s
echo "Chaos Mesh up. Experiments (apply deliberately, one at a time):"
echo "  kubectl apply -f ${HERE}/experiments.yaml"
