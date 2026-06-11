# PCI-DSS scope mapping (Phase 5)

The namespace-per-business-area design makes scope a *topology* property, not a spreadsheet.

## Scope boundaries

| Zone | Namespaces / SDs | PCI relevance |
|---|---|---|
| **CDE (cardholder data environment)** | `sd-card-authorization`, `sd-card-transaction`, `sd-issued-device-administration`, `sd-card-clearing` (bian-operations) | In scope — when these go deep, they move to a dedicated `bian-cards` namespace with its own quota, stricter CiliumNetworkPolicies (no same-namespace blanket allow), and SPIFFE-required mutual auth |
| **Connected-to** | `sd-payment-*`, `sd-fraud-detection`, account SDs | Security-impacting: segmentation controls verified by the chaos partition experiments |
| **Out of scope** | reference data, sales/marketing, business support | Default-deny posture already prevents CDE reachability — Hubble flow logs are the segmentation evidence |

## Control mapping (selected)

| PCI-DSS v4 req | Platform control |
|---|---|
| 1 (network security) | Cilium default-deny + per-service allowlists; Hubble flow logs as evidence |
| 3 (protect stored data) | Per-SD Postgres; PAN tokenization required before any card SD persists (Phase 5 gate); no full PAN in events |
| 7/8 (access) | Keycloak OIDC, role per business area; `bian-ops-analyst` separation for fraud/KYC |
| 10 (logging) | Event history per SD + memory-version-style audit trails; alert resolution requires notes |
| 11 (testing) | k6 + Chaos Mesh segmentation tests scheduled |

## Hard rules already enforced in code

- Money in minor units only; no card primary account numbers modeled anywhere yet — **introducing PAN fields requires the tokenization gate above**.
- Fraud alert resolutions and KYC analyst decisions are unusable without recorded reasons (audit-by-construction).
