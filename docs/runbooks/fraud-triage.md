# Runbook: Fraud alert triage

**Severity: ticket (backlog alert at >50 OPEN).** Alerts are explainable by construction — every alert carries its `riskScore` and `reasons`.

## Work the queue

```bash
curl -s "$HOST/sd-fraud-detection/v1/fraud-alert-monitoring-state?status=OPEN" | jq .
```

Per alert, by triggered rule:

| Reasons | First check |
|---|---|
| `LARGE_AMOUNT` only | Customer history: is this in pattern? Salary/property transactions false-positive often. |
| `VELOCITY` (+anything) | Pull the account's recent postings — bursts of small debits = card testing pattern. |
| `ROUND_AMOUNT` + `LARGE_AMOUNT` | Structuring signal — check for sibling transactions just under thresholds on linked accounts. |
| Source `CHEQUE` | Verify drawer account standing + cheque number sequence (duplicate/stolen book). |

## Decide (terminal — reason is recorded)

```bash
# confirmed fraud → block the account at its SD, then:
curl -X PUT "$HOST/sd-fraud-detection/v1/fraud-alert-monitoring-state/$ID/control" \
  -H 'content-type: application/json' -d '{"action":"confirm","notes":"<evidence>"}'
# false positive:
curl -X PUT ... -d '{"action":"dismiss","notes":"verified with customer via registered phone"}'
```

On `confirm`, also: `PUT .../{account}/control {"action":"block"}` on the account SD, and open a Financial Crime case (Phase 2 catalog: `sd-case-management-financial-crime`).

## Tuning

False-positive rate too high → adjust `bian.fraud.*` thresholds in the service config (per-environment), never by editing scoring code in a hotfix. Threshold changes are config-reviewed like code.
