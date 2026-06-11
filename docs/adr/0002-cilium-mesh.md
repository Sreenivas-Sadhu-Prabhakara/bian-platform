# ADR-0002: Cilium (eBPF) as CNI, mesh, and gateway

**Status:** accepted · Phase 1

## Decision

Cilium provides the CNI, kube-proxy replacement, service mesh (sidecar-free), Gateway API implementation, and network observability (Hubble). No Istio/Linkerd.

## Why

- **Fleet size:** 161 service pods. Sidecar meshes add a proxy container per pod — roughly doubling container count and adding GBs of proxy memory before any business logic runs. Cilium's mesh is eBPF + one Envoy per node.
- **One networking system** instead of three (CNI + kube-proxy + mesh): fewer moving parts, one upgrade surface.
- Identity-based `CiliumNetworkPolicy` gives default-deny with per-service allowlists that align cleanly with BIAN business areas (namespace = area).
- Hubble gives the service map and L7 flow metrics that Netflix used Atlas/Vizceral for.

## Trade-offs / revisit triggers

- Istio's L7 feature set (WASM plugins, rich traffic mirroring, mature multi-cluster) is deeper. Revisit if Phase 3+ needs them; Gateway API keeps north-south portable either way.
- mTLS story: Cilium mutual auth (SPIFFE/SPIRE) is flagged off in Phase 1; enabling it is a Phase 3 task (`authentication.mutual.spire.enabled=true`).
