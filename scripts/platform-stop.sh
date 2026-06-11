#!/usr/bin/env bash
# Stop the local BIAN platform and give the machine back to other work.
# Everything survives: hydrated Postgres data (PVCs), Kafka topics, helm
# releases, images. Restart with ./platform-start.sh
set -euo pipefail

echo "==> scaling workloads to zero (data persists in PVCs)"
kubectl -n bian-operations scale deploy --all --replicas=0 2>/dev/null || true
kubectl -n bian-risk-compliance scale deploy --all --replicas=0 2>/dev/null || true
for ns in bian-operations bian-risk-compliance; do
  kubectl -n $ns scale statefulset --all --replicas=0 2>/dev/null || true
done
kubectl -n kafka scale deploy --all --replicas=0 2>/dev/null || true
# the broker is operator-managed; pause it by annotation + delete its pod
kubectl -n kafka annotate kafka bian-kafka strimzi.io/pause-reconciliation=true --overwrite 2>/dev/null || true
kubectl -n kafka delete pod -l strimzi.io/cluster=bian-kafka --ignore-not-found 2>/dev/null || true

echo "==> freezing the cluster itself (kind node container)"
docker stop bian-control-plane

echo "Platform stopped. CPU/RAM released to other services."
echo "Resume: ./platform-start.sh"
