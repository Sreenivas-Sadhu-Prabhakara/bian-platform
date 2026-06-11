# ADR-0004: Deep service domains "graduate" from the golden template

**Status:** accepted · Phase 2a

## Context

ADR-0001 forbids hand-editing generated boilerplate — the generator owns it. But Phase 2's deep domains must *replace* template internals (the generic control-record store becomes a real domain model). Those two rules collide.

## Decision

A repo containing a `.bian-graduated` marker file is **owned by its domain code, not the generator**. `generate.py` skips graduated repos unconditionally — even under `--force`. Graduated repos keep the same artifact ID, chart shape, CI, and registry entry; what changes is who maintains the files.

Graduated in Phase 2a: `sd-current-account`, `sd-savings-account`, `sd-cheque-processing`.

## Consequences

- Template improvements no longer flow to graduated repos automatically — by design; at deep maturity, blanket re-stamps would destroy domain logic. Cross-cutting changes to deep repos are deliberate per-repo edits.
- The shared scaffolding (events port, exception model) is intentionally *duplicated* per graduated repo rather than extracted to a shared library — keeping repos independently buildable and deployable (Netflix-style) is worth the few dozen duplicated lines. Revisit only if the scaffolding grows real logic.
- The fleet has two tiers: **generated** (shallow, 159 repos) and **graduated** (deep, 3 repos). The registry treats them identically.
