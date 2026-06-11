# Roadmap

## Phase 1 — Paved road + full shallow landscape  ✅ (this build)

- BIAN catalog as data (161 Service Domains, 5 business areas)
- Golden Spring Boot template (BIAN semantic API, health, metrics, resilience, Docker, Helm, mesh policy, CI)
- Generator → **one git repo per service domain** (Netflix-style multi-repo)
- Platform plane: kind, **Cilium** (CNI + eBPF mesh + Gateway API), namespaces per business area, default-deny policies, Prometheus/Grafana/Hubble
- Scripts: bootstrap, build-all, deploy-all, create-github-repos (push when ready)

**Definition of done:** any service domain can be built, deployed to the local cluster, reached through the gateway at `/sd-<name>/v1/...`, observed in Hubble/Grafana, and is policy-isolated by default.

## Phase 2 — Make the landscape real

### Phase 2a ✅ (done — the first judgment-heavy pass, run on Fable)

- **Three domains deep** (graduated from the template, ADR-0004): **Current Account** (overdraft rules, KYC gating, block/close, fraud feed), **Savings Account** (no overdraft, min balance, monthly withdrawal cap, interest accrue/capitalize), **Cheque Processing** (check clearance: LODGED→PRESENTED→CLEARED|RETURNED state machine, stop orders, beneficiary credit instruction). Real contracts (`api/openapi.yaml` + `api/events.yaml` per repo), unit + boot tests green.
- **Flagship event flows defined** (ADR-0005): payments, fraud, KYC — events flow through an `EventPublisher` port (logging adapter now, Kafka adapter later).
- **Postgres staged, not built** (user-gated): DDL + seeds per deep repo, one-instance-per-SD `hydrate.sh` behind `CONFIRM_HYDRATE=yes`.
- **Kafka staged, not built**: Strimzi install + flagship topics behind `CONFIRM_KAFKA=yes`.

### Phase 2b (next)

- Hydrate Postgres + wire JPA adapters (profile `postgres`) in the three deep domains — on explicit go-ahead
- Install Kafka; swap logging → Kafka adapters; turn the HTTP bridges (`cheque-credit`, `kyc-result`) into consumers
- Go deep on the flagship counterparties: **Fraud Detection** (consume `transaction.posted` + `cheque.lodged`, raise `bian.fraud.alerts`), **Know Your Customer** (consume `kyc.check.requested`, answer `kyc.assessment.*` — then flip `auto-approve=false`), **Payment Order / Payment Execution**
- Consumer-driven contract tests between interacting SDs; runtime-vs-contract compatibility checks in CI
- Interest-accrual scheduler; sandbox scenario seeding

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
