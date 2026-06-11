# Postgres — ready to hydrate, deliberately not built

**User decision (Phase 2a):** the database layer is *staged*, not *running*.

| Piece | Where | Status |
|---|---|---|
| DDL per deep domain | `bian-services/sd-*/db/schema.sql` | ✅ ready (invariants as CHECK constraints) |
| Seed data | `bian-services/sd-*/db/seed.sql` | ✅ ready |
| Provisioning (one Postgres **per** SD) | [`hydrate.sh`](hydrate.sh) | ✅ ready — **gated by `CONFIRM_HYDRATE=yes`** |
| JPA adapters in services | — | ⏳ Phase 2b (the repos use port/adapter; swap is localized) |

Until hydration, deep services run on their in-memory adapters — fully functional, tests green, just non-durable.

```bash
# when the go-ahead is given:
CONFIRM_HYDRATE=yes ./hydrate.sh
```
