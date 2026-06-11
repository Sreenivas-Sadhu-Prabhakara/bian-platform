# __SD_NAME__

BIAN Service Domain microservice — part of the [bian-platform](../../bian-platform/) landscape.

| | |
|---|---|
| **Business Area** | __BUSINESS_AREA__ |
| **Business Domain** | __BUSINESS_DOMAIN__ |
| **Functional Pattern** | __FUNCTIONAL_PATTERN__ |
| **Asset Type** | __ASSET_TYPE__ |
| **Control Record** | __CONTROL_RECORD__ |
| **K8s Namespace** | `__NAMESPACE__` |
| **Stack** | Java 21 · Spring Boot 3 · Resilience4j · Cilium mesh |

> ⚠️ **Phase 1 (shallow):** real REST API over an in-memory store. Phase 2 replaces the store with per-domain persistence and real domain logic. This repo was stamped from `bian-platform/generator` — regenerate rather than hand-editing boilerplate.

## BIAN Semantic API

| Method | Path | BIAN action term |
|---|---|---|
| GET | `/v1/service-domain` | — (SD metadata) |
| POST | `/v1/__CR_SLUG__/initiate` | Initiate |
| GET | `/v1/__CR_SLUG__` | Retrieve (list) |
| GET | `/v1/__CR_SLUG__/{crId}/retrieve` | Retrieve |
| PUT | `/v1/__CR_SLUG__/{crId}/update` | Update |
| PUT | `/v1/__CR_SLUG__/{crId}/control` | Control — body `{"action": "suspend"\|"resume"\|"terminate"}` |

OpenAPI UI: `/swagger-ui.html` · Health: `/actuator/health` · Metrics: `/actuator/prometheus`

**API contract:** [`api/openapi.yaml`](api/openapi.yaml) — owned by **this repo** (contract-per-repo; no central contracts repo). The runtime spec at `/v3/api-docs` must stay compatible with it; Phase 2 adds contract tests that enforce this.

## Run locally

```bash
mvn spring-boot:run
curl localhost:8080/v1/service-domain

# lifecycle smoke test
curl -X POST localhost:8080/v1/__CR_SLUG__/initiate -H 'content-type: application/json' -d '{"note":"hello"}'
```

## Build & containerize

```bash
mvn -B verify
docker build -t bian/__ARTIFACT_ID__:0.1.0 .
```

## Deploy (Helm → K8s with Cilium mesh)

```bash
helm upgrade --install __ARTIFACT_ID__ ./helm -n __NAMESPACE__
```

Exposed through the platform Gateway at path prefix `/__ARTIFACT_ID__` (Cilium Gateway API). Mesh policy (`CiliumNetworkPolicy`) allows: gateway ingress, same-area peers, Prometheus — everything else denied.
