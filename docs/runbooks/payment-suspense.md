# Runbook: Payment in SUSPENSE (`FAILED_SUSPENSE`)

**Severity: PAGE — never silence.** A debit succeeded, the credit failed, AND the compensating re-credit failed. **Customer money has left an account and reached no one.**

## Detect

- Alert `PaymentSuspense` (PrometheusRule `bian-payments`), or event `payment.suspense` on `bian.payments.payment-execution`.
- Queue query (indexed):
  ```sql
  -- in paymentexecution DB
  SELECT execution_id, order_ref, debtor_account_ref, amount_minor, failure_reason, finished_at
  FROM payment_execution WHERE status = 'FAILED_SUSPENSE' ORDER BY finished_at;
  ```

## Triage (do in order)

1. **Confirm the debit leg actually posted** — in the debtor's account DB:
   `SELECT * FROM account_transaction WHERE reference = 'PAY:<execution_id>';`
   If absent → the suspense is *bookkeeping-only*; mark resolved with notes, done.
2. **Read `failure_reason`** — it carries both legs: `CREDIT_FAILED:<why> AND COMPENSATION_FAILED:<why>`.
3. **Check the debtor account state** — `BLOCKED`/`CLOSED` between debit and compensation is the most common compensation-failure cause. Credits are accepted on BLOCKED accounts by design, so a failed compensation usually means CLOSED or an outage.

## Resolve

- **Debtor account reachable again** → re-run the compensation manually:
  `POST /v1/.../{debtorAccount}/payments/deposit` with reference `COMPENSATE:<execution_id>` — then update the execution row to `FAILED_COMPENSATED` with an audit note.
- **Creditor account became valid** (e.g. unblocked) → complete the original intent instead: credit the creditor with reference `PAY:<execution_id>`, set status `COMPLETED`.
- **Neither possible** → funds move to the bank's suspense GL account per treasury policy; escalate to operations lead. **Never delete the row.**

## Never

- Never auto-retry suspense executions (double-credit risk — the saga is idempotent on *orderRef*, not on manual replays).
- Never resolve without writing the audit note.
