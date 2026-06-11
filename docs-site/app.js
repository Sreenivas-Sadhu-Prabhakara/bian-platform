/* BIAN Platform docs — interactivity. Vanilla JS; data from data.js (REGISTRY). */
(function () {
  "use strict";
  const $ = (s) => document.querySelector(s);
  const ghRepo = (r) => `https://github.com/${GH_OWNER}/${r}`;

  /* ── 01 journey ─────────────────────────────────────────────── */
  const JOURNEY = [
    { t: "The catalog", d: "<h4>One JSON file is the whole bank</h4><p><code>catalog/bian-service-landscape.json</code> holds 5 business areas → 22 business domains → 162 service domains, each with its BIAN functional pattern and asset type.</p><p>Adding a service domain to the bank is a JSON edit — not an engineering project.</p>" },
    { t: "The generator", d: "<h4>The paved road</h4><p><code>generator/generate.py</code> stamps one independent git repo per service domain from a golden Spring Boot template — BIAN semantic API, health probes, metrics, circuit breaker, Dockerfile, Helm chart, mesh policy, CI, and a per-repo OpenAPI contract.</p><p>Boilerplate is never hand-edited: fix the template, re-stamp 162 repos in ~45 seconds.</p>" },
    { t: "162 repos", d: "<h4>Netflix-style multi-repo</h4><p>Every service domain builds, versions, and deploys independently with its own CI. Contracts live <em>per repo</em> (<code>api/openapi.yaml</code> + <code>api/events.yaml</code>) — no central contracts repo, no lockstep releases.</p>" },
    { t: "Graduation", d: "<h4>Deep domains own their code</h4><p>When a domain gets real business logic it <em>graduates</em>: a <code>.bian-graduated</code> marker makes the generator skip it forever — even with <code>--force</code>. Seven domains have graduated so far, each with tested banking rules.</p>" },
    { t: "The mesh", d: "<h4>Cilium: CNI + mesh + gateway, zero sidecars</h4><p>One eBPF system replaces three: networking, kube-proxy, and the service mesh. North-south traffic enters through the Cilium Gateway (Gateway API) at <code>/sd-&lt;domain&gt;</code>; east-west is governed by identity-based default-deny policies. Hubble gives the live service map.</p>" },
    { t: "The gates", d: "<h4>Data + events, staged then opened</h4><p>Postgres (one instance per deep domain) and Kafka (Strimzi, flagship topics) were built as <em>gated scripts</em> — <code>CONFIRM_HYDRATE=yes</code> / <code>CONFIRM_KAFKA=yes</code> — and opened on explicit go-ahead. Domain code talks to ports; opening a gate swaps an adapter, never a redesign.</p>" },
    { t: "The flows", d: "<h4>Flagship choreography: payments · fraud · KYC</h4><p>Cheques clear into account credits; every posting feeds fraud scoring; account openings trigger KYC checks whose verdicts gate activation. Try all three interactively in <a href='#flows'>section 05</a>.</p>" },
  ];
  const steps = $("#journey-steps"), detail = $("#journey-detail");
  JOURNEY.forEach((j, i) => {
    const b = document.createElement("button");
    b.className = "jstep"; b.innerHTML = `<span class="jno">${String(i + 1).padStart(2, "0")}</span>${j.t}`;
    b.addEventListener("click", () => {
      steps.querySelectorAll(".jstep").forEach((x) => x.classList.remove("active"));
      b.classList.add("active"); detail.innerHTML = j.d;
    });
    steps.appendChild(b);
  });
  steps.firstChild.click();

  /* ── 02 architecture ────────────────────────────────────────── */
  const ARCH = {
    edge: "<h4>Cilium Gateway (north-south)</h4><p>Gateway API — the modern successor to Netflix Zuul. Every service ships its own <code>HTTPRoute</code> in its Helm chart; the external path prefix <code>/sd-&lt;domain&gt;</code> is rewritten away before the request reaches the pod.</p><ul><li>One <code>Gateway</code> in <code>bian-system</code></li><li>Routes attach only from labelled namespaces</li></ul>",
    ns: "<h4>One namespace per BIAN business area</h4><p>Policy and observability slice along BIAN lines: Reference Data (8), Sales &amp; Service (36), Operations &amp; Execution (60), Risk &amp; Compliance (24), Business Support (34).</p>",
    mesh: "<h4>Cilium eBPF mesh (east-west)</h4><p>Sidecar-free: at 162 services, sidecars would roughly double pod count. Identity-based <code>CiliumNetworkPolicy</code> per service over a cluster-wide default-deny baseline; only gateway ingress, same-platform peers, DNS, and Prometheus scrape are allowed.</p><ul><li>Hubble: flow-level visibility + service map</li><li>SPIFFE/SPIRE mutual auth staged for Phase 3</li></ul>",
    data: "<h4>Decentralized data — gate 1</h4><p>One Postgres instance per deep domain (no shared banking database). Each repo owns its DDL (<code>db/schema.sql</code>) with business invariants as CHECK constraints — the overdraft rule, no-self-deposit, returned-cheques-have-reasons.</p><p>Hydration: <code>CONFIRM_HYDRATE=yes hydrate.sh</code> → 7 instances, schemas, seeds.</p>",
    events: "<h4>Event backbone — gate 2</h4><p>Strimzi-operated Kafka with 8 flagship topics across payments, fraud, and KYC. Services publish through an <code>EventPublisher</code> port: logging adapter by default, Kafka adapter under the <code>kafka</code> profile — wire-identical event shapes either way.</p>",
  };
  const archDetail = $("#arch-detail");
  document.querySelectorAll(".arch-layer").forEach((b) => {
    b.addEventListener("click", () => {
      document.querySelectorAll(".arch-layer").forEach((x) => x.classList.remove("active"));
      b.classList.add("active");
      archDetail.innerHTML = ARCH[b.dataset.layer];
    });
  });
  document.querySelector('.arch-layer[data-layer="mesh"]').click();

  /* ── 03 explorer ────────────────────────────────────────────── */
  const exBody = $("#ex-body"), exCount = $("#ex-count");
  const exSearch = $("#ex-search"), exArea = $("#ex-area"), exPattern = $("#ex-pattern"), exDeep = $("#ex-deeponly");
  [...new Set(REGISTRY.map((s) => s.businessArea))].forEach((a) =>
    exArea.insertAdjacentHTML("beforeend", `<option>${a}</option>`));
  [...new Set(REGISTRY.map((s) => s.functionalPattern))].sort().forEach((p) =>
    exPattern.insertAdjacentHTML("beforeend", `<option>${p}</option>`));

  function renderExplorer() {
    const q = exSearch.value.trim().toLowerCase();
    const rows = REGISTRY.filter((s) =>
      (!q || (s.serviceDomain + s.repo + s.controlRecord + s.businessDomain).toLowerCase().includes(q)) &&
      (!exArea.value || s.businessArea === exArea.value) &&
      (!exPattern.value || s.functionalPattern === exPattern.value) &&
      (!exDeep.checked || s.deep));
    exCount.textContent = `${rows.length} of ${REGISTRY.length} service domains`;
    exBody.innerHTML = rows.map((s) => `
      <tr>
        <td><span class="sd-name">${s.serviceDomain}</span>${s.deep ? '<span class="badge-deep">DEEP</span>' : ""}</td>
        <td class="dim">${s.businessArea}<br/>${s.businessDomain}</td>
        <td class="dim">${s.functionalPattern}</td>
        <td class="dim">${s.controlRecord}</td>
        <td><a class="repo-link" href="${ghRepo(s.repo)}" target="_blank" rel="noopener">${s.repo} ↗</a></td>
      </tr>`).join("");
  }
  [exSearch, exArea, exPattern, exDeep].forEach((el) =>
    el.addEventListener(el === exSearch ? "input" : "change", renderExplorer));
  renderExplorer();

  /* ── 04 deep domains ────────────────────────────────────────── */
  const DEEP = [
    { repo: "sd-current-account", cr: "Current Account Facility Fulfillment Arrangement",
      rules: ["Overdraft usable to exactly the limit — one paisa more is a 409", "KYC gating: PENDING_KYC accounts can't transact", "Blocked = debits rejected, credits accepted", "Close requires balance exactly 0", "Every posting emits transaction.posted (fraud feed)"],
      curl: `curl -X POST $HOST/sd-current-account/v1/current-account-facility-fulfillment-arrangement/initiate \\\n  -H 'content-type: application/json' \\\n  -d '{"customerReference":"C-1","overdraftLimitMinor":10000}'` },
    { repo: "sd-savings-account", cr: "Savings Account Facility Fulfillment Arrangement",
      rules: ["No overdraft, ever (also a DB CHECK)", "Monthly withdrawal cap (default 6, UTC month)", "Daily interest accrual, floor arithmetic, basis points", "Capitalize moves accrued interest into balance", "Close needs balance AND accrued interest at 0"],
      curl: `curl -X POST $HOST/sd-savings-account/v1/savings-account-facility-fulfillment-arrangement/$ID/interest/accrue` },
    { repo: "sd-cheque-processing", cr: "Cheque Transaction Procedure",
      rules: ["State machine: LODGED → PRESENTED → CLEARED | RETURNED", "Stop orders honored only BEFORE presentment", "No self-deposits (drawer ≠ beneficiary)", "Returns require a reason", "cheque.cleared carries the beneficiary credit instruction"],
      curl: `curl -X POST $HOST/sd-cheque-processing/v1/cheque-transaction-procedure/$ID/clear` },
    { repo: "sd-fraud-detection", cr: "Fraud Alert Monitoring State",
      rules: ["Explainable scoring: LARGE +70 · VELOCITY +50 · ROUND +25", "Alert at score ≥ 60; every evaluation returns its reasons", "Sliding 10-minute velocity window", "Investigation: OPEN → CONFIRMED_FRAUD | FALSE_POSITIVE"],
      curl: `curl -X POST $HOST/sd-fraud-detection/v1/fraud-alert-monitoring-state/evaluate \\\n  -d '{"accountRef":"CA-1","amountMinor":5000000}'` },
    { repo: "sd-know-your-customer", cr: "KYC Assessment Procedure",
      rules: ["Watchlist hit → REJECTED (not API-overridable)", "Missing docs / high-risk country → REFERRED to an analyst", "Analyst decisions need a reason (audit)", "Verdicts deliver via HTTP callback in the accounts' kyc-result shape"],
      curl: `curl -X POST $HOST/sd-know-your-customer/v1/kyc-assessment-procedure/initiate \\\n  -d '{"customerReference":"C-1","documents":["ID","ADDRESS"]}'` },
    { repo: "sd-payment-order", cr: "Payment Order Procedure",
      rules: ["Intake validation with recorded rejection reasons", "Per-order limit (default ₹500,000)", "Auto-submit hand-off to Payment Execution", "Cancel only before submission"],
      curl: `curl -X POST $HOST/sd-payment-order/v1/payment-order-procedure/initiate \\\n  -d '{"debtorAccountRef":"CA-D","creditorAccountRef":"CA-C","amountMinor":250000}'` },
    { repo: "sd-payment-execution", cr: "Payment Transaction Procedure",
      rules: ["Debit-credit saga with compensation", "FAILED_SUSPENSE is loud, indexed, never auto-retried", "Idempotent on orderRef — money never moves twice", "Failure-injectable simulator: FAIL-DEBIT / FAIL-CREDIT / FAIL-COMPENSATE"],
      curl: `curl -X POST $HOST/sd-payment-execution/v1/payment-transaction-procedure/initiate \\\n  -d '{"orderRef":"PO-1","debtorAccountRef":"CA-D","creditorAccountRef":"CA-C","amountMinor":50000}'` },
  ];
  $("#deep-grid").innerHTML = DEEP.map((d) => `
    <div class="deep-card">
      <h4><a href="${ghRepo(d.repo)}" target="_blank" rel="noopener">${d.repo} ↗</a></h4>
      <p class="cr">${d.cr}</p>
      <ul>${d.rules.map((r) => `<li>${r}</li>`).join("")}</ul>
      <pre data-copy><code>${d.curl}</code></pre>
    </div>`).join("");

  /* ── 05a payment saga stepper ───────────────────────────────── */
  const SAGA = {
    happy: [
      { n: "RECEIVED", c: "on", m: "Order arrives from Payment Order." },
      { n: "DEBIT debtor", c: "good", m: "Leg 1: debit succeeds → DEBITED. payment.debited emitted." },
      { n: "CREDIT creditor", c: "good", m: "Leg 2: credit succeeds." },
      { n: "COMPLETED", c: "good", m: "payment.completed → Payment Order marks COMPLETED. Done." }],
    debit: [
      { n: "RECEIVED", c: "on", m: "Order arrives." },
      { n: "DEBIT debtor", c: "bad", m: "Insufficient funds — debit leg fails." },
      { n: "FAILED_DEBIT", c: "bad", m: "Clean failure: nothing moved, nothing to undo. payment.failed emitted." }],
    credit: [
      { n: "RECEIVED", c: "on", m: "Order arrives." },
      { n: "DEBIT debtor", c: "good", m: "Leg 1 succeeds — money has LEFT the debtor." },
      { n: "CREDIT creditor", c: "bad", m: "Creditor account closed — leg 2 fails. Money is in flight!" },
      { n: "COMPENSATE", c: "good", m: "Re-credit the debtor: compensation succeeds." },
      { n: "FAILED_COMPENSATED", c: "on", m: "Money is back where it started. payment.failed with the credit reason." }],
    suspense: [
      { n: "RECEIVED", c: "on", m: "Order arrives." },
      { n: "DEBIT debtor", c: "good", m: "Leg 1 succeeds." },
      { n: "CREDIT creditor", c: "bad", m: "Leg 2 fails." },
      { n: "COMPENSATE", c: "bad", m: "…and the compensating re-credit ALSO fails." },
      { n: "FAILED_SUSPENSE", c: "bad", m: "Funds in suspense. payment.suspense — ops queue, never auto-retried. The loudest state in the platform." }],
  };
  const track = $("#saga-track"), sagaMsgId = "saga-msg";
  let sagaIdx = 0;
  function sagaRender() {
    const sc = SAGA[$("#saga-scenario").value];
    track.innerHTML = sc.map((s, i) =>
      `<div class="saga-node ${i < sagaIdx ? s.c : ""}"><b>${i + 1}</b>${s.n}</div>`).join("") +
      `<div class="saga-msg" id="${sagaMsgId}" style="flex-basis:100%">${sagaIdx > 0 ? sc[sagaIdx - 1].m : "Press Step to begin."}</div>`;
  }
  $("#saga-step").addEventListener("click", () => {
    const sc = SAGA[$("#saga-scenario").value];
    if (sagaIdx < sc.length) sagaIdx++;
    sagaRender();
  });
  $("#saga-reset").addEventListener("click", () => { sagaIdx = 0; sagaRender(); });
  $("#saga-scenario").addEventListener("change", () => { sagaIdx = 0; sagaRender(); });
  sagaRender();

  /* ── 05b fraud calculator (mirrors FraudDetectionService) ───── */
  const frAmount = $("#fr-amount"), frVel = $("#fr-velocity"), frOut = $("#fraud-result"), frNote = $("#fr-amount-note");
  function fraudRender() {
    const amt = Math.max(0, Number(frAmount.value) || 0); // minor units (paise)
    frNote.textContent = `= ${amt.toLocaleString("en-IN")} paise (₹${(amt / 100).toLocaleString("en-IN")})`;
    const rules = [
      { code: "LARGE_AMOUNT", pts: 70, hit: amt >= 1_000_000, why: "amount ≥ ₹10,000" },
      { code: "VELOCITY", pts: 50, hit: frVel.checked, why: ">5 activities / 10 min" },
      { code: "ROUND_AMOUNT", pts: 25, hit: amt % 100_000 === 0 && amt >= 500_000, why: "round ×100k ≥ half threshold" },
    ];
    const score = rules.reduce((s, r) => s + (r.hit ? r.pts : 0), 0);
    const alert = score >= 60;
    frOut.innerHTML =
      `<div class="score-big ${alert ? "alert" : "clean"}">${score}<small style="font-size:.9rem"> / threshold 60</small></div>` +
      rules.map((r) => `<div class="rule-line ${r.hit ? "hit" : ""}"><span>${r.hit ? "●" : "○"} ${r.code} <small>(${r.why})</small></span><b>${r.hit ? "+" + r.pts : "—"}</b></div>`).join("") +
      `<div class="verdict">${alert ? "🚨 fraud.alert.raised → bian.fraud.alerts" : "✓ recorded as velocity evidence, no alert"}</div>`;
  }
  frAmount.addEventListener("input", fraudRender);
  frVel.addEventListener("change", fraudRender);
  fraudRender();

  /* ── 05c KYC pipeline ───────────────────────────────────────── */
  const kycOut = $("#kyc-result");
  function kycRender() {
    const wl = $("#kyc-watchlist").checked, docs = $("#kyc-docs").checked, hr = $("#kyc-country").checked;
    let outcome, cls, reasons, next;
    if (wl) { outcome = "REJECTED"; cls = "rejected"; reasons = ["WATCHLIST_HIT"]; next = "Terminal — not overridable through the API."; }
    else if (!docs || hr) {
      outcome = "REFERRED"; cls = "referred";
      reasons = [...(!docs ? ["MISSING_DOCUMENT:ADDRESS"] : []), ...(hr ? ["HIGH_RISK_COUNTRY:KP"] : [])];
      next = "An analyst decides via PUT /control — reason mandatory (audit).";
    } else { outcome = "APPROVED"; cls = "approved"; reasons = ["CLEAN"]; next = "kyc.assessment.completed → callback to the account's kyc-result endpoint."; }
    kycOut.innerHTML = `<div class="kyc-outcome ${cls}">${outcome}</div>` +
      `<div class="rule-line hit"><span>reasons</span><b>${reasons.join(", ")}</b></div>` +
      `<div class="verdict">${next}</div>`;
  }
  ["kyc-watchlist", "kyc-docs", "kyc-country"].forEach((id) =>
    document.getElementById(id).addEventListener("change", kycRender));
  kycRender();

  /* ── 06 phases ──────────────────────────────────────────────── */
  const PHASES = [
    { t: "Phase 1 — Paved road + full shallow landscape", pill: "run", items: [
      "Catalog as data (162 SDs)", "Golden template + generator", "162 independent repos + registry",
      "Cilium platform plane (kind, gateway, policies)", "Per-repo CI + Helm + contracts"] },
    { t: "Phase 2a–c — Judgment-heavy deep builds", pill: "run", items: [
      "Current Account · Savings Account · Cheque Processing", "Fraud Detection · KYC · Payment Order · Payment Execution",
      "Graduation model (ADR-0004)", "Flagship event contracts (ADR-0005)", "All tests green"] },
    { t: "Phase 2d — Open the gates", pill: "run", items: [
      "Cluster + Cilium running", "Postgres ×7 hydrated with schemas + seeds", "Kafka (Strimzi) + 8 flagship topics",
      "JDBC + Kafka adapters (pattern-set on current-account)", "Chart profile/env wiring fleet-wide"] },
    { t: "Phase 3 — Security & delivery", pill: "staged", items: [
      "Keycloak OIDC", "Cilium mutual auth (SPIFFE/SPIRE)", "Vault + external-secrets",
      "GitOps (ArgoCD ApplicationSets)", "Image signing + SBOM", "Backstage catalog"] },
    { t: "Phase 4 — Resilience & scale", pill: "staged", items: [
      "HPA/KEDA (Kafka-lag autoscaling)", "Argo Rollouts canaries via Gateway API", "Chaos Mesh experiments",
      "SLOs + alerting", "k6 load journeys"] },
    { t: "Phase 5 — Productionization", pill: "planned", items: [
      "PCI-DSS scope mapping per namespace", "Data governance + GDPR erasure flows", "DR / multi-region (ClusterMesh)",
      "Cost rightsizing", "Runbooks + production-readiness reviews"] },
  ];
  $("#timeline").innerHTML = PHASES.map((p) =>
    `<div class="phase"><h4>${p.t} <span class="pill ${p.pill}">${p.pill.toUpperCase()}</span></h4>
     <ul>${p.items.map((i) => `<li>${i}</li>`).join("")}</ul></div>`).join("");

  /* ── copy buttons ───────────────────────────────────────────── */
  document.querySelectorAll("pre[data-copy]").forEach((pre) => {
    const b = document.createElement("button");
    b.className = "copy-btn"; b.textContent = "copy";
    b.addEventListener("click", async () => {
      try { await navigator.clipboard.writeText(pre.querySelector("code").innerText); } catch (e) {}
      b.textContent = "copied"; b.classList.add("ok");
      setTimeout(() => { b.textContent = "copy"; b.classList.remove("ok"); }, 1300);
    });
    pre.appendChild(b);
  });
})();
