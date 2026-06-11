#!/usr/bin/env bash
# Phase 3 — Secrets: HashiCorp Vault (dev mode locally) + External Secrets Operator.
# STAGED: CONFIRM_VAULT=yes ./install.sh
#
# Replaces the *-localdev passwords (Postgres secrets, Keycloak admin, GitHub
# tokens) with Vault-sourced ExternalSecrets. Dev mode here; HA + auto-unseal
# is a production-cluster concern (docs/production-readiness.md).
set -euo pipefail
[[ "${CONFIRM_VAULT:-}" == "yes" ]] || { echo "REFUSING: set CONFIRM_VAULT=yes"; exit 1; }

helm repo add hashicorp https://helm.releases.hashicorp.com >/dev/null
helm repo add external-secrets https://charts.external-secrets.io >/dev/null
helm repo update hashicorp external-secrets >/dev/null

helm upgrade --install vault hashicorp/vault -n bian-security --create-namespace \
  --set server.dev.enabled=true \
  --set server.resources.requests.memory=128Mi
helm upgrade --install external-secrets external-secrets/external-secrets \
  -n bian-security --set resources.requests.memory=64Mi

kubectl -n bian-security rollout status statefulset/vault --timeout=300s
echo "Vault (dev) up. Wire a per-namespace SecretStore + ExternalSecret, e.g.:"
cat <<'EOF'
  apiVersion: external-secrets.io/v1
  kind: ExternalSecret
  metadata: { name: pg-sd-current-account, namespace: bian-operations }
  spec:
    secretStoreRef: { name: vault, kind: ClusterSecretStore }
    target: { name: pg-sd-current-account }
    data:
      - secretKey: POSTGRES_PASSWORD
        remoteRef: { key: bian/data/pg/currentaccount, property: password }
EOF
