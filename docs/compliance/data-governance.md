# Data governance (Phase 5)

## Retention

| Data | Where | Retention | Mechanism |
|---|---|---|---|
| Account transactions | per-SD Postgres | 7y (regulatory) | partition-by-year + archive job (staged) |
| Payment/cheque events | Kafka payments topics | 7 days hot | `retention.ms` on topics (already set) → long-term in the SD databases |
| Fraud alerts + KYC assessments | per-SD Postgres | 30 days hot on Kafka, 5y in DB | topic config (set) + DB policy |
| KYC documents | NOT stored — only document *types* | n/a | by design; doc storage would join via `sd-document-management` with its own policy |

## GDPR / DPDP erasure

Customer data is keyed by `customerReference` in exactly three deep stores (accounts ×2, KYC). Erasure flow:
1. Verify no open obligations (balance 0, no open fraud cases — both queryable).
2. Accounts: anonymize `customer_reference` (`ERASED-<hash>`); transactions keep amounts (financial record exemption) without the linkable key.
3. KYC: assessments carry the audit exemption for AML (retain reasons; anonymize reference where outcome ≠ REJECTED-watchlist).
4. Events: hot topics age out in ≤30 days by retention; no replayable PII after that.

## Lineage

`api/events.yaml` per repo IS the lineage map: every event names its producer, payload fields, and consumers. The docs-site explorer renders the registry; Phase 3's Backstage import turns contracts into a browsable graph.

## Classification

- `customerReference`, account refs: **pseudonymous identifiers** — allowed in events.
- Names/addresses/documents: **PII** — never put in events or logs; they live only in the owning SD's store (none modeled yet outside KYC document *types*).
