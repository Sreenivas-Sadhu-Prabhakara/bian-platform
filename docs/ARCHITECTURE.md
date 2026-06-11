# Architecture

## The shape

```
                        ┌─────────────────────────────────────────────┐
   curl / clients ────▶ │  Cilium Gateway (Gateway API, bian-system)  │   north-south
                        └──────────────────┬──────────────────────────┘
                       path /sd-<domain>   │  HTTPRoute per service (in its chart)
        ┌───────────────┬─────────────────┼──────────────────┬───────────────┐
        ▼               ▼                 ▼                  ▼               ▼
  bian-reference-  bian-sales-      bian-operations    bian-risk-      bian-business-
  data (8 SDs)     service (36)     (59 SDs)           compliance (24) support (34)
        │               │                 │                  │               │
        └───────────────┴─── Cilium eBPF mesh (sidecar-free) ┴───────────────┘
                 identity-based CiliumNetworkPolicies · default-deny baseline
                 Hubble (flows, service map, L7 metrics) · Prometheus · Grafana
```

- **One repo per Service Domain** (`bian-services/sd-*`), stamped from a golden template.
- **One K8s namespace per BIAN Business Area** — policy and observability slice along BIAN lines.
- **Each service**: Spring Boot 3 / Java 21, BIAN semantic API over its control record, actuator health probes, Prometheus metrics, Resilience4j circuit breaker, Dockerfile, Helm chart (Deployment, Service, HTTPRoute, CiliumNetworkPolicy), per-repo CI.

## Netflix-style — and what each piece became

The platform follows the Netflix microservices philosophy (independent repos, independent deploys, decentralized data, resilience as a first-class concern) with each Netflix-OSS component mapped to its modern in-cluster successor:

| Concern | Netflix OSS | Here |
|---|---|---|
| Service discovery | Eureka | K8s Services + DNS (Cilium eBPF datapath) |
| Edge routing | Zuul | Cilium **Gateway API** (`bian-gateway`) |
| Client load balancing | Ribbon | Cilium eBPF service LB (kube-proxy replacement) |
| Circuit breaking | Hystrix | **Resilience4j** in-process + mesh-level policy |
| Inter-service security | — | Cilium identity-based policy (mTLS/SPIFFE in Phase 3) |
| Telemetry | Atlas | Prometheus + Grafana + **Hubble** |
| Config | Archaius | Spring profiles + ConfigMaps (externalized config in Phase 3) |
| Multi-repo + paved road | Netflix's golden paths | `bian-platform/generator` golden template |

**Why Cilium (not Istio/Linkerd):** sidecar-free — the mesh lives in eBPF + one Envoy per node, so 161 service pods don't each carry a proxy container (at this fleet size, sidecars would roughly double the pod count and add ~16GB+ of proxy memory). Cilium is also the CNI and kube-proxy replacement, so the network stack is one system, not three. Trade-off: L7 features are younger than Istio's; revisit if Phase 3+ needs WASM filters or complex traffic mirroring.

## BIAN mapping

- **Business Area → namespace**, **Business Domain → label**, **Service Domain → microservice**.
- Each SD exposes the BIAN action-term API over its **control record**, whose name is derived BIAN-style from *asset type + functional-pattern noun* (e.g. Current Account: asset "Current Account Facility" + pattern Fulfill → control record **"Current Account Facility Fulfillment Arrangement"**).
- Endpoints: `initiate` / `retrieve` / `update` / `control` (+ pattern-specific terms in Phase 2).

## The generator is the architecture

`catalog/bian-service-landscape.json` (161 SDs) is the **source of truth**. The generator stamps every repo from `generator/templates/service/`. Boilerplate is *never* hand-edited in a service repo — fix the template, re-run with `--force`, and the whole landscape is consistent. This is how "all of BIAN" stays maintainable: the catalog is data, the landscape is output.

## Repo / deploy lifecycle

```
catalog ──generate.py──▶ bian-services/sd-* (161 git repos)
                              │ per-repo CI (mvn verify + docker build)
bootstrap-cluster.sh ─▶ kind + Cilium + namespaces + gateway + policies + observability
build-all.sh ─────────▶ images → kind load
deploy-all.sh ────────▶ helm install per namespace (reads registry.json)
create-github-repos.sh ▶ one GitHub repo per service (when you choose)
```
