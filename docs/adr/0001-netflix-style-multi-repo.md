# ADR-0001: Netflix-style multi-repo, generated from a catalog

**Status:** accepted · Phase 1

## Decision

One git repository per BIAN Service Domain (161 at Phase 1), all stamped from a single golden template by `generator/generate.py`, with the BIAN landscape held as data in `catalog/bian-service-landscape.json`.

## Why

- **Netflix-style autonomy:** each service builds, versions, and deploys independently; per-repo CI; no lockstep releases.
- **161 hand-written repos is unmaintainable;** 161 *generated* repos from one template is one artifact to maintain. Boilerplate fixes go to the template + `--force` regenerate, never to individual repos.
- The catalog-as-data approach means extending toward the full official BIAN landscape (~320 SDs) is a JSON edit, not an engineering project.

## Consequences

- Hand edits to generated boilerplate are forbidden by convention (they'd be lost on regenerate). Domain logic added in Phase 2 must live in files the template doesn't own, or regeneration must become AST-aware/merge-based (acceptable cost, deferred).
- A workspace-level registry (`bian-services/registry.json`) is required for fleet operations (deploy-all, GitHub push).
