# Production readiness (Phase 5)

Per-service-domain checklist + the platform-level gaps between this reference implementation and production. RUN = verified here · STAGED = scripted, gated · GAP = needs real infrastructure.

## Per-SD gate (apply before any domain serves real traffic)

- [ ] Graduated + domain tests green (`mvn verify`) — RUN for the 7 deep SDs
- [ ] Contract (`api/openapi.yaml`) matches runtime `/v3/api-docs` (contract test) — Phase 2d-ii
- [ ] Postgres adapter on, hydration via migration tool (Flyway) not raw psql — STAGED
- [ ] SLO rules + dashboards wired (`resilience/slo`) — STAGED
- [ ] Runbook exists for every loud failure state (suspense ✓, fraud ✓; per-SD as they deepen)
- [ ] Canary rollout strategy (`resilience/rollouts`) — STAGED
- [ ] Chaos experiments passed (`resilience/chaos`) — STAGED

## Platform gaps to production

| Area | Local state | Production requirement |
|---|---|---|
| Cluster | single-node kind, 4GB | 3+ nodes/AZ, managed K8s; `kind/cluster.yaml` topology as baseline |
| DR | none | Cilium ClusterMesh active-active or region failover; Postgres PITR (WAL archiving) + cross-region replicas; Kafka MirrorMaker2 |
| Backups | none | Velero + per-SD `pg_dump` schedule; restore drills quarterly |
| Secrets | `*-localdev` literals | Vault (`security/vault`) + ExternalSecrets everywhere; no stringData secrets |
| Identity | none on APIs | Keycloak OIDC (`security/keycloak`) + SPIFFE mutual auth (`security/spire`) |
| Delivery | helm from laptop | ArgoCD ApplicationSets (`gitops/argocd`); signed images + SBOM in CI |
| Kafka | 1 broker, RF1 | 3+ brokers, RF3, `min.insync.replicas=2`, TLS + per-SD credentials |
| Cost | quotas (`production/quotas.yaml`) | requests from k6 + 4-week telemetry; spot pools for stateless SDs |

## Operating rules

1. The catalog is the API; the generator is the paved road; graduated repos own their code.
2. Suspense pages are never silenced; analyst decisions always carry reasons.
3. Threshold changes (fraud, limits, caps) are config PRs, never hotfixes.
