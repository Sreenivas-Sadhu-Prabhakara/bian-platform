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

### Phase 2b-c ✅ (done — flagship counterparties deep)

Seven domains now graduated and deep. Added in this pass:

- **Fraud Detection** — explainable scoring engine (LARGE_AMOUNT +70 / VELOCITY +50 / ROUND_AMOUNT +25, alert ≥ 60), sliding velocity window, `/evaluate` ingest bridge, alert investigation lifecycle (`OPEN → CONFIRMED_FRAUD | FALSE_POSITIVE`), `bian.fraud.alerts`.
- **Know Your Customer** — screening pipeline (watchlist → REJECTED; missing docs / high-risk jurisdiction → REFERRED; analyst decisions with mandatory audit reason), watchlist maintenance, **HTTP callback in the account SDs' `kyc-result` shape** — the full KYC loop is wireable today.
- **Payment Order** — intake validation with recorded rejection reasons, per-order limit, auto-submit hand-off via `ExecutionClient` port, cancel-only-before-submission, execution-result callback.
- **Payment Execution** — the **debit-credit saga with compensation**: `COMPLETED` / `FAILED_DEBIT` / `FAILED_COMPENSATED` / `FAILED_SUSPENSE` (loud, never auto-retried), **idempotent on orderRef**, failure-injectable accounts simulator so every path is testable now.

### Phase 2d (next)

- **Open the gates** (user go-ahead): `CONFIRM_HYDRATE=yes` Postgres → wire JPA adapters; `CONFIRM_KAFKA=yes` Strimzi → swap logging adapters for Kafka producers/consumers
- **Close the loops live:** accounts call KYC `/initiate` with their callback URL → flip `bian.kyc.auto-approve=false`; Payment Order's `ExecutionClient` → HTTP/Kafka against Payment Execution; Payment Execution's `AccountsClient` simulator → real account-SD adapter; account/cheque events → Fraud `/evaluate` consumer
- Consumer-driven contract tests between the seven deep SDs; runtime-vs-contract checks in CI
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
