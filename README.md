# bian-platform

The umbrella repo for a **BIAN-aligned core-banking microservice landscape** — Netflix-style (one repo per service), Java 21 / Spring Boot 3, deployed on Kubernetes with a **Cilium eBPF service mesh**.

> **Phase 1 — full landscape, shallow.** All **161 BIAN Service Domains** are generated as independent, deployable microservices with real REST APIs over in-memory stores. Depth (persistence, events, domain logic) is Phase 2 — see [docs/PHASES.md](docs/PHASES.md).

## What's here

| Path | What |
|---|---|
| `catalog/bian-service-landscape.json` | **Source of truth** — 5 business areas → 22 business domains → 161 service domains |
| `generator/` | Stamps one git repo per service domain from the golden template |
| `generator/templates/service/` | The golden Spring Boot service: BIAN semantic API, actuator, Prometheus, Resilience4j, Dockerfile, Helm (incl. HTTPRoute + CiliumNetworkPolicy), CI |
| `platform-infra/` | kind cluster config, Cilium values + install, Gateway, namespaces, default-deny policies, Prometheus/Grafana |
| `scripts/` | `bootstrap-cluster.sh` · `build-all.sh` · `deploy-all.sh` · `create-github-repos.sh` |
| `docs/` | [Architecture](docs/ARCHITECTURE.md) · [Phase roadmap](docs/PHASES.md) · ADRs |

The generated landscape lives in **`../bian-services/`** — 161 sibling git repos (`sd-current-account`, `sd-payment-order`, …) plus `registry.json` / `REGISTRY.md`.

## Quick start

```bash
# 0. prerequisites: docker, kind, helm, kubectl  (brew install kind helm kubectl)

# 1. (re)generate the landscape from the catalog
python3 generator/generate.py            # add --force to re-stamp

# 2. bring up the platform: kind + Cilium + gateway + observability
./scripts/bootstrap-cluster.sh

# 3. build + deploy a slice (all 161 builds take hours — start small)
./scripts/build-all.sh  --only sd-current-account sd-payment-order sd-fraud-detection
./scripts/deploy-all.sh --only sd-current-account sd-payment-order sd-fraud-detection

# 4. hit a service through the mesh gateway
kubectl -n bian-system port-forward svc/cilium-gateway-bian-gateway 18080:80 &
curl localhost:18080/sd-current-account/v1/service-domain
curl -X POST localhost:18080/sd-current-account/v1/current-account-facility-fulfillment-arrangement/initiate \
     -H 'content-type: application/json' -d '{"customer":"C-001"}'
```

Observability: Hubble UI (service map) `kubectl -n kube-system port-forward svc/hubble-ui 12000:80` · Grafana `kubectl -n monitoring port-forward svc/monitoring-grafana 3000:80`.

## Publishing to GitHub (when ready)

Everything is local-only by design. When you want the true Netflix multi-repo on GitHub:

```bash
./scripts/create-github-repos.sh --dry-run   # see what would be created
./scripts/create-github-repos.sh --yes       # 161 service repos + this umbrella
```

## Rules of the road

1. **Never hand-edit generated boilerplate** in a service repo — fix the template, re-run `generate.py --force`.
2. **The catalog is the API** — adding/renaming service domains happens in JSON, then regenerate.
3. One namespace per business area; default-deny mesh posture; every service ships its own policy.
