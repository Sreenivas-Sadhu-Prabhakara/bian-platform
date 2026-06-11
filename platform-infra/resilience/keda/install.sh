#!/usr/bin/env bash
# Phase 4 — event-driven autoscaling. STAGED: CONFIRM_KEDA=yes ./install.sh
set -euo pipefail
[[ "${CONFIRM_KEDA:-}" == "yes" ]] || { echo "REFUSING: set CONFIRM_KEDA=yes"; exit 1; }
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

helm repo add kedacore https://kedacore.github.io/charts >/dev/null
helm repo update kedacore >/dev/null
helm upgrade --install keda kedacore/keda -n keda --create-namespace
kubectl -n keda rollout status deploy/keda-operator --timeout=300s
kubectl apply -f "${HERE}/scaledobject-fraud.yaml"
echo "KEDA up; fraud-detection scales on Kafka consumer lag."
