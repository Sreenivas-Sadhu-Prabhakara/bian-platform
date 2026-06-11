# ADR-0005: Event choreography — flagship flows and staged transport

**Status:** accepted · Phase 2a (user decision: flagships = payments, fraud, KYC)

## Decision

1. **Flagship event flows:** payments (cheque lifecycle → account credits → payment order/execution), fraud (account `transaction.posted` + `cheque.lodged` feeding Fraud Detection), and KYC (`kyc.check.requested` from account opening → `kyc.assessment.*` gating activation).
2. **Event contracts live per repo** (`api/events.yaml`), consistent with ADR-0003; the platform holds only the topic catalog (`platform-infra/kafka/topics.yaml`).
3. **Staged transport:** domain code publishes through an `EventPublisher` port. Phase 2a binds a logging adapter (wire-identical event shapes, visible in pod logs); the Kafka adapter binds when Strimzi is installed (`install.sh`, gated by `CONFIRM_KAFKA=yes`). Cross-domain effects ship as synchronous HTTP endpoints today (e.g. `payments/cheque-credit`, `kyc-result`) and become consumers without touching domain logic.
4. **KYC bridge:** until the KYC choreography is live, accounts default `bian.kyc.auto-approve=true` — honestly recorded by a `kyc.assessment.auto-approved` event. Flipping to real KYC is a config change.

## Why staged

The user directed: define the flagships now, don't build the broker yet. The port/adapter split means the choreography design is executable and testable today, and turning on Kafka is an infrastructure act, not a redesign.
