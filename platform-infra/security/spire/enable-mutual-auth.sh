#!/usr/bin/env bash
# Phase 3 — Cilium mutual authentication (SPIFFE/SPIRE).
# STAGED: CONFIRM_SPIRE=yes ./enable-mutual-auth.sh
#
# Flips the flag prepared in cilium/values.yaml since Phase 1: Cilium deploys
# a SPIRE server/agent pair, every endpoint gets a SPIFFE identity, and
# policies can then require authentication.mode: required per service pair.
set -euo pipefail
[[ "${CONFIRM_SPIRE:-}" == "yes" ]] || { echo "REFUSING: set CONFIRM_SPIRE=yes"; exit 1; }

helm upgrade cilium cilium/cilium -n kube-system --reuse-values \
  --set authentication.mutual.spire.enabled=true \
  --set authentication.mutual.spire.install.enabled=true
kubectl -n kube-system rollout status ds/cilium --timeout=300s

echo "Mutual auth enabled. Per-service enforcement example:"
cat <<'EOF'
  # In a CiliumNetworkPolicy ingress rule:
  - fromEndpoints:
      - matchLabels: { app.kubernetes.io/part-of: bian-platform }
    authentication:
      mode: required
EOF
