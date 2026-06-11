#!/usr/bin/env bash
# Phase 4 — progressive delivery. STAGED: CONFIRM_ROLLOUTS=yes ./install.sh
# Argo Rollouts with Gateway API traffic splitting (Cilium implements the
# HTTPRoute weight updates) — canary per service domain.
set -euo pipefail
[[ "${CONFIRM_ROLLOUTS:-}" == "yes" ]] || { echo "REFUSING: set CONFIRM_ROLLOUTS=yes"; exit 1; }

kubectl create namespace argo-rollouts --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
kubectl -n argo-rollouts rollout status deploy/argo-rollouts --timeout=300s

cat <<'EOF'
Canary pattern (convert a Deployment to a Rollout in a deep repo's chart):
  strategy:
    canary:
      trafficRouting:
        plugins:
          argoproj-labs/gatewayAPI:
            httpRoute: sd-current-account     # the chart's HTTPRoute
            namespace: bian-operations
      steps:
        - setWeight: 10
        - pause: { duration: 2m }   # watch error rate in Prometheus
        - setWeight: 50
        - pause: { duration: 2m }
EOF
