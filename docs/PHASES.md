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

### Phase 2d ✅ (gates opened + E2E proven on a live cluster)

kind + Cilium up; Postgres ×7 hydrated and verified; Strimzi 1.0.0 + 8 flagship topics Ready; one deposit proven end-to-end (API → rules → Postgres row → `transaction.posted` on the real topic, through the mesh). Operating model: start → test → stop (`scripts/platform-stop.sh` / `platform-start.sh`).

### Phase 2d-ii ✅ (loops closed in code, config-activated)

Every flagship choreography seam is now a config flip, not a code change:

- **KYC loop** — accounts gain a `KycGateway`: set `bian.kyc.url` (+ `callback-base-url`) and openings dispatch a real check with a callback URL, staying `PENDING_KYC` until the verdict lands; auto-approve only exists while unconfigured. Delivery failure leaves the account pending, never broken.
- **Payments loop** — PO's `ExecutionClient` returns the saga outcome **in-band** (PE's API is synchronous): set `bian.payments.execution-url` and orders complete/fail immediately; transport failure keeps the order VALIDATED and retryable. PE's `AccountsClient` HTTP adapter routes legs by prefix (CA-/SA-) to the real account SDs — a 409 (overdraft/blocked/KYC) is exactly the business failure that triggers compensation.
- **Event consumers** (profile `kafka`) — fraud consumes the account + cheque topics (the flagship feed, live); KYC consumes `kyc.check.requested`; both account SDs consume `kyc.assessment.completed` and `cheque.cleared`. Kafka publishers in all five event-bearing domains. Handlers skip malformed events — feeds never wedge.

### Phase 2e (next)

- Live multi-service rehearsal on the cluster (current-account + KYC + PO + PE simultaneously — needs the 8GB Docker bump or a real cluster)
- JDBC adapters for the remaining 6 deep domains (current-account is the pattern)
- Consumer-driven contract tests BETWEEN SDs (per-repo runtime↔contract suite already enforces within-repo)
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
