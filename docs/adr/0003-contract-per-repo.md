# ADR-0003: API contracts live in each service repo

**Status:** accepted · Phase 1 (user decision, 2026-06-11)

## Decision

Every service domain owns its OpenAPI contract at `api/openapi.yaml` inside its own repo. There is **no** central `bian-api-contracts` repo.

## Why

- Consistent with the Netflix-style autonomy model: the repo is the unit of ownership — code, chart, policy, CI, **and contract** travel together and version together.
- A central contracts repo reintroduces lockstep coupling (one PR queue, one release cadence) for 161 independently-deployed services.

## Consequences

- Cross-domain consumers discover contracts via the service repo (and the registry, which knows every repo). Phase 3's Backstage catalog surfaces them in one pane without centralizing ownership.
- Contract compatibility is enforced per-repo: Phase 2 adds tests asserting the runtime `/v3/api-docs` stays compatible with `api/openapi.yaml`, plus consumer-driven contract tests between interacting SDs.
