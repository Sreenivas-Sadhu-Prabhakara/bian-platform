#!/usr/bin/env bash
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  POSTGRES HYDRATION — READY, BUT GATED.                                    ║
# ║  Per user decision (Phase 2a): scripts are READY TO HYDRATE but the        ║
# ║  databases are NOT to be built until explicit go-ahead.                    ║
# ║  Run with:  CONFIRM_HYDRATE=yes ./hydrate.sh                               ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
#
# What it does (one Postgres instance PER deep service domain — decentralized
# data, Netflix-style; no shared banking database):
#   1. helm-installs bitnami/postgresql per deep SD into its business-area namespace
#   2. applies the repo-owned db/schema.sql
#   3. applies the repo-owned db/seed.sql
#
# Wiring the services themselves (JPA adapter, spring profile 'postgres')
# is a separate, subsequent step — hydration alone changes nothing in the apps.
set -euo pipefail

if [[ "${CONFIRM_HYDRATE:-}" != "yes" ]]; then
  echo "REFUSING TO RUN: Postgres hydration is gated by user decision (Phase 2a)."
  echo "When the go-ahead is given:  CONFIRM_HYDRATE=yes $0"
  exit 1
fi

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICES_DIR="${SERVICES_DIR:-${HERE}/../../../bian-services}"

# repo:namespace:dbname — extend as more domains go deep
DEEP_SDS=(
  "sd-current-account:bian-operations:currentaccount"
  "sd-savings-account:bian-operations:savingsaccount"
  "sd-cheque-processing:bian-operations:chequeprocessing"
)

helm repo add bitnami https://charts.bitnami.com/bitnami >/dev/null
helm repo update bitnami >/dev/null

for entry in "${DEEP_SDS[@]}"; do
  IFS=: read -r repo ns db <<< "${entry}"
  release="pg-${repo}"
  echo "==> ${release} (db=${db}) in ${ns}"

  helm upgrade --install "${release}" bitnami/postgresql \
    --namespace "${ns}" \
    --set auth.database="${db}" \
    --set auth.username="${db}" \
    --set auth.password="${db}-localdev" \
    --set primary.persistence.size=1Gi \
    --wait --timeout 300s

  echo "    applying schema + seed from ${repo}/db/"
  for sqlfile in schema.sql seed.sql; do
    kubectl -n "${ns}" exec -i "statefulset/${release}-postgresql" -- \
      env PGPASSWORD="${db}-localdev" psql -U "${db}" -d "${db}" -v ON_ERROR_STOP=1 \
      < "${SERVICES_DIR}/${repo}/db/${sqlfile}"
  done
done

echo
echo "Hydration complete. Next (separate step): wire the JPA adapters"
echo "(spring profile 'postgres') in each deep repo and redeploy."
