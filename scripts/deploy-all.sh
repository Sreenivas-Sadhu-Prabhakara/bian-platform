#!/usr/bin/env bash
# Deploy service domains via Helm into their business-area namespaces,
# driven by bian-services/registry.json (emitted by the generator).
#
#   ./deploy-all.sh                            # everything in the registry
#   ./deploy-all.sh --only sd-current-account sd-payment-order
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICES_DIR="${SERVICES_DIR:-${HERE}/../../bian-services}"
REGISTRY="${SERVICES_DIR}/registry.json"
[[ -f "${REGISTRY}" ]] || { echo "registry.json not found — run the generator first"; exit 1; }

only=()
if [[ "${1:-}" == "--only" ]]; then shift; only=("$@"); fi

# repo<TAB>namespace pairs from the registry
while IFS=$'\t' read -r repo ns; do
  if ((${#only[@]})) ; then
    [[ " ${only[*]} " == *" ${repo} "* ]] || continue
  fi
  echo "── ${repo} -> ${ns}"
  helm upgrade --install "${repo}" "${SERVICES_DIR}/${repo}/helm" \
    --namespace "${ns}" \
    --wait --timeout 120s
done < <(python3 -c "
import json
for s in json.load(open('${REGISTRY}'))['services']:
    print(s['repo'] + '\t' + s['namespace'])
")

echo
echo 'Smoke test through the mesh gateway (kind maps it to localhost:8080):'
echo '  kubectl -n bian-system port-forward svc/cilium-gateway-bian-gateway 18080:80 &'
echo '  curl localhost:18080/sd-current-account/v1/service-domain'
