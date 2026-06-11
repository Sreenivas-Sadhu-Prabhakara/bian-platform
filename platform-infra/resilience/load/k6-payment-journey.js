// Phase 4 — load test: the full payment journey through the mesh gateway.
//   k6 run -e HOST=http://localhost:18080 k6-payment-journey.js
// Mix: 70% balance reads, 20% deposits, 10% full payment-order journeys.
import http from "k6/http";
import { check, sleep } from "k6";

const HOST = __ENV.HOST || "http://localhost:18080";
const CA = `${HOST}/sd-current-account/v1/current-account-facility-fulfillment-arrangement`;
const PO = `${HOST}/sd-payment-order/v1/payment-order-procedure`;
const params = { headers: { "Content-Type": "application/json" } };

export const options = {
  scenarios: {
    banking_mix: {
      executor: "ramping-vus",
      stages: [
        { duration: "1m", target: 20 },
        { duration: "3m", target: 20 },
        { duration: "1m", target: 0 },
      ],
    },
  },
  thresholds: {
    http_req_failed: ["rate<0.01"],          // availability SLO
    http_req_duration: ["p(99)<500"],        // latency SLO
  },
};

export function setup() {
  const res = http.post(`${CA}/initiate`,
    JSON.stringify({ customerReference: "C-K6", currency: "INR", overdraftLimitMinor: 0 }), params);
  const acct = res.json("accountId");
  http.post(`${CA}/${acct}/payments/deposit`,
    JSON.stringify({ amountMinor: 100_000_000, reference: "k6-seed" }), params);
  return { acct };
}

export default function (data) {
  const r = Math.random();
  if (r < 0.7) {
    check(http.get(`${CA}/${data.acct}/balance`), { "balance 200": (x) => x.status === 200 });
  } else if (r < 0.9) {
    check(http.post(`${CA}/${data.acct}/payments/deposit`,
      JSON.stringify({ amountMinor: 1000, reference: "k6" }), params),
      { "deposit 201": (x) => x.status === 201 });
  } else {
    const order = http.post(`${PO}/initiate`, JSON.stringify({
      debtorAccountRef: data.acct, creditorAccountRef: "CA-K6-PEER",
      amountMinor: 5000, currency: "INR", remittanceInfo: "k6 journey",
    }), params);
    check(order, { "order created": (x) => x.status === 201 });
  }
  sleep(0.5);
}
