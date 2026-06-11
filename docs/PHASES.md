# Roadmap

## Phase 1 — Paved road + full shallow landscape  ✅ (this build)

- BIAN catalog as data (161 Service Domains, 5 business areas)
- Golden Spring Boot template (BIAN semantic API, health, metrics, resilience, Docker, Helm, mesh policy, CI)
- Generator → **one git repo per service domain** (Netflix-style multi-repo)
- Platform plane: kind, **Cilium** (CNI + eBPF mesh + Gateway API), namespaces per business area, default-deny policies, Prometheus/Grafana/Hubble
- Scripts: bootstrap, build-all, deploy-all, create-github-repos (push when ready)

**Definition of done:** any service domain can be built, deployed to the local cluster, reached through the gateway at `/sd-<name>/v1/...`, observed in Hubble/Grafana, and is policy-isolated by default.

## Phase 2 — Make the landscape real

- **Domain depth:** replace in-memory stores with per-domain persistence (one DB per service; Postgres by default), real control-record schemas per functional pattern, pattern-specific action terms (Execute for Process/Operate, Evaluate for Assess, …)
- **Event backbone:** Kafka; BIAN service-domain choreography (Payment Order → Payment Execution → Transaction Engine; Fraud Detection subscribing to card/payment streams)
- **Cross-domain sagas** for the flagship journeys: customer onboarding, payment lifecycle, loan origination
- **Contract-first, contract-per-repo:** every service owns its OpenAPI contract at `api/openapi.yaml` (shipped in Phase 1); Phase 2 deepens the schemas per domain and adds consumer-driven contract tests against them — no central contracts repo
- Sandbox data sets + scenario seeding
- *(This is the judgment-heavy generation pass — run it with Fable.)*

## Phase 3 — Security & delivery

- OIDC/OAuth2 (Keycloak), token propagation through the mesh
- Cilium mutual auth with **SPIFFE/SPIRE** (flip `authentication.mutual.spire.enabled`), tighten per-area policies to per-flow allowlists
- Secrets: Vault + external-secrets
- **GitOps:** ArgoCD ApplicationSets over the 161 repos; image registry, signing (cosign), SBOMs; CI pushes, Git promotes dev → staging → prod
- Developer portal: Backstage with the BIAN catalog as the software catalog

## Phase 4 — Resilience & scale

- HPA/KEDA autoscaling (KEDA on Kafka lag for event-driven SDs)
- Progressive delivery: Argo Rollouts canaries using Gateway API traffic splitting
- Chaos engineering (Chaos Mesh) — kill pods/links per business area, verify policy + retry behavior
- SLOs per service domain; alerting; load testing (k6) with realistic banking traffic mixes

## Phase 5 — Productionization

- Compliance hardening: PCI-DSS scope mapping per namespace, data residency, audit trails
- Data governance: lineage across SD events, retention policies, GDPR erasure flows
- DR / multi-region: cluster federation or per-region active-active with Cilium ClusterMesh
- Cost: rightsizing from Phase 4 telemetry, spot pools for stateless SDs
- Runbooks, on-call, production readiness reviews per business area
