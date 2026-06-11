#!/usr/bin/env bash
# Phase 3 — OIDC identity provider (Keycloak). STAGED: CONFIRM_KEYCLOAK=yes ./install.sh
# Imports the 'bian' realm (client bian-api, roles per business area).
set -euo pipefail
[[ "${CONFIRM_KEYCLOAK:-}" == "yes" ]] || { echo "REFUSING: set CONFIRM_KEYCLOAK=yes (heavy on small hosts)"; exit 1; }
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl create namespace bian-security --dry-run=client -o yaml | kubectl apply -f -
kubectl -n bian-security create configmap keycloak-realm \
  --from-file=realm.json="${HERE}/realm-bian.json" --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata: { name: keycloak, namespace: bian-security, labels: { app: keycloak } }
spec:
  replicas: 1
  selector: { matchLabels: { app: keycloak } }
  template:
    metadata: { labels: { app: keycloak } }
    spec:
      containers:
        - name: keycloak
          image: quay.io/keycloak/keycloak:26.0
          args: ["start-dev", "--import-realm"]
          env:
            - { name: KC_BOOTSTRAP_ADMIN_USERNAME, value: admin }
            - { name: KC_BOOTSTRAP_ADMIN_PASSWORD, value: bian-localdev }   # dev only; Vault in prod
          ports: [{ containerPort: 8080 }]
          volumeMounts: [{ name: realm, mountPath: /opt/keycloak/data/import }]
          resources: { requests: { cpu: 100m, memory: 512Mi }, limits: { memory: 1Gi } }
      volumes:
        - name: realm
          configMap: { name: keycloak-realm }
---
apiVersion: v1
kind: Service
metadata: { name: keycloak, namespace: bian-security }
spec:
  selector: { app: keycloak }
  ports: [{ port: 8080 }]
EOF
kubectl -n bian-security rollout status deploy/keycloak --timeout=300s
echo "Keycloak up. Issuer: http://keycloak.bian-security:8080/realms/bian"
echo "Services opt in via Spring profile 'secure':"
echo "  spring.security.oauth2.resourceserver.jwt.issuer-uri=http://keycloak.bian-security:8080/realms/bian"
