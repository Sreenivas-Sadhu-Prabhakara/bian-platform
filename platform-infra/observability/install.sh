#!/usr/bin/env bash
# Observability stack: kube-prometheus-stack (Prometheus + Grafana) wired to
# scrape every service domain's /actuator/prometheus, plus Hubble (installed
# with Cilium) for mesh-level flow visibility.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null
helm repo update prometheus-community >/dev/null

helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f "${HERE}/prometheus-values.yaml"

echo "==> Grafana:    kubectl -n monitoring port-forward svc/monitoring-grafana 3000:80   (admin / bian-platform)"
echo "==> Prometheus: kubectl -n monitoring port-forward svc/monitoring-kube-prometheus-prometheus 9090"
echo "==> Hubble UI:  kubectl -n kube-system port-forward svc/hubble-ui 12000:80"
