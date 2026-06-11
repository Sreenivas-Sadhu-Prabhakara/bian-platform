#!/usr/bin/env bash
# Build service-domain images: mvn package -> docker build -> kind load.
#
#   ./build-all.sh                            # ALL services (161 images — hours; be sure)
#   ./build-all.sh --only sd-current-account sd-payment-order
#   SKIP_KIND_LOAD=1 ./build-all.sh --only ...   # build images only
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICES_DIR="${SERVICES_DIR:-${HERE}/../../bian-services}"
TAG="0.1.0"

repos=()
if [[ "${1:-}" == "--only" ]]; then
  shift; repos=("$@")
else
  while IFS= read -r d; do repos+=("$(basename "$d")"); done \
    < <(find "${SERVICES_DIR}" -maxdepth 1 -type d -name 'sd-*' | sort)
fi

echo "Building ${#repos[@]} service(s)…"
fail=0
for repo in "${repos[@]}"; do
  dir="${SERVICES_DIR}/${repo}"
  [[ -f "${dir}/pom.xml" ]] || { echo "SKIP ${repo}: no pom.xml"; continue; }
  echo "── ${repo}"
  mvn -B -q -f "${dir}/pom.xml" package -DskipTests || { echo "FAIL build ${repo}"; fail=1; continue; }
  docker build -q -t "bian/${repo}:${TAG}" "${dir}" || { echo "FAIL image ${repo}"; fail=1; continue; }
  if [[ -z "${SKIP_KIND_LOAD:-}" ]] && command -v kind >/dev/null && kind get clusters | grep -qx bian; then
    kind load docker-image "bian/${repo}:${TAG}" --name bian
  fi
done
exit $fail
