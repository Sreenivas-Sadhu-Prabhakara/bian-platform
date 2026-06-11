#!/usr/bin/env bash
# Push the local multi-repo landscape to GitHub — one repo per service domain
# (true Netflix-style), plus the bian-platform umbrella.
#
# DELIBERATELY MANUAL: creates 160+ repos under your account. Run when ready:
#   ./create-github-repos.sh --dry-run
#   ./create-github-repos.sh --yes [--private]
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICES_DIR="${SERVICES_DIR:-${HERE}/../../bian-services}"
PLATFORM_DIR="${HERE}/.."
VISIBILITY="--public"
CONFIRM=""
DRY=""

for arg in "$@"; do
  case "$arg" in
    --yes) CONFIRM=1 ;;
    --private) VISIBILITY="--private" ;;
    --dry-run) DRY=1 ;;
  esac
done

command -v gh >/dev/null || { echo "gh CLI required"; exit 1; }
mapfile -t repos < <(find "${SERVICES_DIR}" -maxdepth 1 -type d -name 'sd-*' -exec basename {} \; | sort)

echo "Would create ${#repos[@]} service repos + bian-platform (${VISIBILITY#--})."
[[ -n "${DRY}" ]] && { printf '  %s\n' bian-platform "${repos[@]:0:5}" "... (${#repos[@]} total)"; exit 0; }
[[ -n "${CONFIRM}" ]] || { echo "Refusing without --yes. Try --dry-run first."; exit 1; }

create_and_push() {
  local dir="$1" name="$2" desc="$3"
  if gh repo view "$name" >/dev/null 2>&1; then
    echo "exists: ${name}"
  else
    gh repo create "$name" ${VISIBILITY} --source="$dir" --remote=origin --description "$desc" >/dev/null
  fi
  git -C "$dir" push -u origin main -q
  echo "pushed: ${name}"
}

create_and_push "${PLATFORM_DIR}" "bian-platform" "BIAN platform umbrella: catalog, generator, K8s/Cilium infra"
for repo in "${repos[@]}"; do
  create_and_push "${SERVICES_DIR}/${repo}" "${repo}" "BIAN service domain microservice (${repo#sd-})"
done
