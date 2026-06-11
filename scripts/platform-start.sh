#!/usr/bin/env bash
# Resume the local BIAN platform after ./platform-stop.sh
# Brings back: cluster, Cilium, the pattern-setter service + its Postgres.
# Scale up more PGs / Kafka only as a test needs them (4GB-host discipline).
set -euo pipefail

echo "==> unfreezing the kind node"
docker start bian-control-plane
until kubectl get --raw /readyz >/dev/null 2>&1; do sleep 5; done
echo "    API up"

echo "==> core slice: current-account DB + service"
kubectl -n bian-operations scale statefulset pg-sd-current-account --replicas=1
kubectl -n bian-operations rollout status statefulset/pg-sd-current-account --timeout=300s
kubectl -n bian-operations scale deploy sd-current-account --replicas=1

cat <<'EOF'
Resumed (minimal slice). Optional extras, one at a time on a 4GB host:
  # another deep domain's DB:
  kubectl -n bian-operations scale statefulset pg-sd-payment-order --replicas=1
  # Kafka back (operator resumes the broker):
  kubectl -n kafka scale deploy strimzi-cluster-operator --replicas=1
  kubectl -n kafka annotate kafka bian-kafka strimzi.io/pause-reconciliation- --overwrite
Smoke test:
  kubectl -n bian-operations port-forward svc/sd-current-account 18088:8080 &
  curl localhost:18088/v1/service-domain
EOF
