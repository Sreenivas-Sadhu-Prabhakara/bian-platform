#!/usr/bin/env bash
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  KAFKA (Strimzi) — READY, NOT YET INSTALLED.                               ║
# ║  Flagship choreography (user decision, Phase 2a): PAYMENTS, FRAUD, KYC.    ║
# ║  Run with:  CONFIRM_KAFKA=yes ./install.sh                                 ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
#
#   1. Strimzi operator into namespace 'kafka'
#   2. a single-node KRaft cluster 'bian-kafka' (local sizing)
#   3. the flagship topics from topics.yaml
#
# Until this runs, deep services publish through their logging adapter —
# identical event shapes, visible in pod logs. Flipping to real Kafka is an
# adapter swap, not a domain change.
set -euo pipefail

if [[ "${CONFIRM_KAFKA:-}" != "yes" ]]; then
  echo "REFUSING TO RUN: Kafka install is staged but not yet approved to build."
  echo "When ready:  CONFIRM_KAFKA=yes $0"
  exit 1
fi

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# 1.0.0+ required: older operators (≤0.45) cannot detect Kubernetes ≥1.33
STRIMZI_VERSION="${STRIMZI_VERSION:-1.0.0}"

kubectl create namespace kafka --dry-run=client -o yaml | kubectl apply -f -

echo "==> Strimzi operator ${STRIMZI_VERSION}"
helm repo add strimzi https://strimzi.io/charts >/dev/null
helm repo update strimzi >/dev/null
helm upgrade --install strimzi strimzi/strimzi-kafka-operator \
  --namespace kafka --version "${STRIMZI_VERSION}" --wait

echo "==> Kafka cluster + flagship topics"
kubectl apply -f "${HERE}/cluster.yaml"
kubectl -n kafka wait kafka/bian-kafka --for=condition=Ready --timeout=600s
kubectl apply -f "${HERE}/topics.yaml"

echo "Kafka up. Bootstrap (in-cluster): bian-kafka-kafka-bootstrap.kafka:9092"
