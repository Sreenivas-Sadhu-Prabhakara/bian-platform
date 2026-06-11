#!/usr/bin/env bash
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  POSTGRES HYDRATION — gate opened by user 2026-06-11 ("open the gates").  ║
# ║  Still requires:  CONFIRM_HYDRATE=yes ./hydrate.sh                        ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
#
# One Postgres instance PER deep service domain (decentralized data — no shared
# banking database). Uses the OFFICIAL postgres image via plain manifests:
# no chart-repo dependency (the bitnami catalog breakage of 2025 made helm
# charts for this unreliable).
#
#   1. Secret + Service + StatefulSet per deep SD, sized for small hosts
#   2. applies the repo-owned db/schema.sql
#   3. applies the repo-owned db/seed.sql
set -euo pipefail

if [[ "${CONFIRM_HYDRATE:-}" != "yes" ]]; then
  echo "REFUSING TO RUN: set CONFIRM_HYDRATE=yes to hydrate."
  exit 1
fi

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICES_DIR="${SERVICES_DIR:-${HERE}/../../../bian-services}"
PG_IMAGE="${PG_IMAGE:-postgres:16-alpine}"

# repo:namespace:dbname — every graduated (deep) service domain
DEEP_SDS=(
  "sd-current-account:bian-operations:currentaccount"
  "sd-savings-account:bian-operations:savingsaccount"
  "sd-cheque-processing:bian-operations:chequeprocessing"
  "sd-payment-order:bian-operations:paymentorder"
  "sd-payment-execution:bian-operations:paymentexecution"
  "sd-fraud-detection:bian-risk-compliance:frauddetection"
  "sd-know-your-customer:bian-risk-compliance:knowyourcustomer"
)

for entry in "${DEEP_SDS[@]}"; do
  IFS=: read -r repo ns db <<< "${entry}"
  name="pg-${repo}"
  echo "==> ${name} (db=${db}) in ${ns}"

  kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: ${name}
  namespace: ${ns}
  labels: { app.kubernetes.io/part-of: bian-platform, bian/database: "${db}" }
stringData:
  POSTGRES_DB: ${db}
  POSTGRES_USER: ${db}
  POSTGRES_PASSWORD: ${db}-localdev
---
apiVersion: v1
kind: Service
metadata:
  name: ${name}
  namespace: ${ns}
  labels: { app.kubernetes.io/part-of: bian-platform }
spec:
  selector: { app: ${name} }
  ports: [{ name: pg, port: 5432, targetPort: 5432 }]
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: ${name}
  namespace: ${ns}
  labels: { app.kubernetes.io/part-of: bian-platform }
spec:
  serviceName: ${name}
  replicas: 1
  selector:
    matchLabels: { app: ${name} }
  template:
    metadata:
      labels: { app: ${name}, app.kubernetes.io/part-of: bian-platform }
    spec:
      containers:
        - name: postgres
          image: ${PG_IMAGE}
          envFrom: [{ secretRef: { name: ${name} } }]
          ports: [{ containerPort: 5432 }]
          resources:
            requests: { cpu: 25m, memory: 64Mi }
            limits: { memory: 192Mi }
          readinessProbe:
            exec: { command: ["pg_isready", "-U", "${db}"] }
            initialDelaySeconds: 5
            periodSeconds: 5
          volumeMounts: [{ name: data, mountPath: /var/lib/postgresql/data }]
  volumeClaimTemplates:
    - metadata: { name: data }
      spec:
        accessModes: [ReadWriteOnce]
        resources: { requests: { storage: 500Mi } }
EOF
done

echo "==> waiting for all instances to be ready"
for entry in "${DEEP_SDS[@]}"; do
  IFS=: read -r repo ns db <<< "${entry}"
  kubectl -n "${ns}" rollout status "statefulset/pg-${repo}" --timeout=300s
done

echo "==> applying schemas + seeds"
for entry in "${DEEP_SDS[@]}"; do
  IFS=: read -r repo ns db <<< "${entry}"
  for sqlfile in schema.sql seed.sql; do
    echo "    ${repo}/db/${sqlfile}"
    kubectl -n "${ns}" exec -i "pg-${repo}-0" -- \
      env PGPASSWORD="${db}-localdev" psql -q -U "${db}" -d "${db}" -v ON_ERROR_STOP=1 \
      < "${SERVICES_DIR}/${repo}/db/${sqlfile}"
  done
done

echo "Hydration complete: 7 databases up, schemas applied, seeds loaded."
