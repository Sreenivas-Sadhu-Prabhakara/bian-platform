#!/usr/bin/env python3
"""Generate MASTER-CATALOG.md — the one document that explains every service
domain in the landscape: what it is, who uses it (3+ use cases), what kind of
banking it serves, which backend providers it typically integrates with, and
how to run it. Regenerate after catalog changes:

    python3 scripts/generate-master-catalog.py
"""
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
REGISTRY = json.loads((HERE / "../../bian-services/registry.json").read_text())
OUT = HERE / "../MASTER-CATALOG.md"
GH = "https://github.com/Sreenivas-Sadhu-Prabhakara"

# ── per-business-domain banking metadata ─────────────────────────────────────
DOMAIN_META = {
    "Reference Data": dict(
        kind="Universal banking (shared backbone for every line of business)",
        providers=["Core banking: Temenos Transact, Infosys Finacle, Mambu, Thought Machine Vault",
                   "Market data: Refinitiv/LSEG, Bloomberg, SIX Financial",
                   "Registries & identity: GLEIF (LEI), SWIFTRef, national ID/address validators (DigiLocker, Loqate)"],
        cases=["Serve golden-source {asset} data to every other service domain with full audit history",
               "Synchronize {sd} records bi-directionally with the core banking system of record",
               "Provide point-in-time lookups for regulatory reporting and reconciliation"]),
    "Customer Management": dict(
        kind="Retail & corporate banking (customer lifecycle)",
        providers=["CRM: Salesforce Financial Services Cloud, Microsoft Dynamics 365",
                   "CIAM: Keycloak, Okta, ForgeRock",
                   "Credit bureaus: CIBIL, Experian, Equifax",
                   "KYC utilities & registries"],
        cases=["Maintain a single view of the customer across products, channels, and entities",
               "Drive onboarding, servicing, and offboarding journeys for {asset} records",
               "Feed customer analytics, consent, and entitlement decisions to channel applications"]),
    "Sales": dict(
        kind="Retail banking (sales & origination)",
        providers=["CRM & lead engines: Salesforce, HubSpot",
                   "Pricing/offer engines: Earnix, Nomis",
                   "Origination platforms: nCino, FinnOne"],
        cases=["Run {sd} workflows from lead capture through fulfilled product agreement",
               "Match customers to eligible products using bureau + behavioral data",
               "Track conversion funnels and hand off won opportunities to fulfillment domains"]),
    "Marketing": dict(
        kind="Retail banking (engagement)",
        providers=["Martech: Adobe Experience Cloud, Salesforce Marketing Cloud, Braze",
                   "Analytics/CDP: Segment, Amplitude"],
        cases=["Design and launch {asset} programs targeted by segment and channel",
               "Measure campaign attribution against account-opening and usage events",
               "Coordinate brand, promotion, and survey activity across markets"]),
    "Channels": dict(
        kind="Retail & universal banking (distribution)",
        providers=["Digital banking: Backbase, Temenos Infinity",
                   "ATM/POS: NCR, Diebold Nixdorf, Verifone, Ingenico",
                   "Contact center: Genesys, Twilio Flex, Amazon Connect"],
        cases=["Operate the {asset} touchpoint and expose its sessions/events to the bank",
               "Route customer contacts and service orders to the right fulfillment domain",
               "Capture channel telemetry for fraud signals and experience analytics"]),
    "Account Management": dict(
        kind="Retail core banking (deposits & current accounts)",
        providers=["Core ledgers: Thought Machine Vault, Mambu, Temenos, Finacle",
                   "Statements/comms: Quadient, OpenText Exstream",
                   "Billing: Zuora, SAP BRIM"],
        cases=["Open, service, block, and close {asset} records with full posting history",
               "Post deposits/withdrawals with balance and overdraft/minimum rules enforced",
               "Stream transaction events to fraud monitoring and customer notifications",
               "Drive interest accrual/fees and feed the general ledger"]),
    "Payments": dict(
        kind="Payments / transaction banking",
        providers=["Rails: SWIFT, SEPA, ACH/NACHA, UPI (NPCI), NEFT/RTGS/IMPS, FedNow, TARGET2",
                   "Payment hubs: Volante, ACI Worldwide, FIS, Finastra",
                   "Sanctions screening: Fircosoft, LexisNexis Bridger"],
        cases=["Accept, validate, and route {asset} instructions to the correct rail",
               "Execute transfers with debit/credit atomicity and compensation on failure",
               "Provide payment status tracking to channels and corporate clients (gpi-style)",
               "Screen instructions against sanctions lists before release"]),
    "Cards": dict(
        kind="Cards & consumer finance",
        providers=["Networks: Visa, Mastercard, RuPay, Amex",
                   "Processors: FIS, TSYS, Fiserv, Marqeta, M2P",
                   "3-D Secure & tokenization: Cardinal, MDES/VTS"],
        cases=["Authorize and clear {asset} activity within network SLAs",
               "Manage card issuance, activation, blocking, and re-issuance lifecycles",
               "Feed every authorization to fraud scoring in real time"]),
    "Loans and Deposits": dict(
        kind="Retail & corporate credit",
        providers=["LOS/LMS: nCino, FinnOne Neo, Pennant, Temenos",
                   "Bureaus & registries: CIBIL/Experian, CERSAI (collateral)",
                   "Valuers & insurers for collateral assets"],
        cases=["Originate and service {asset} facilities from application to closure",
               "Schedule disbursements, repayments, and restructuring events",
               "Track collateral, guarantees, and covenant compliance against exposures"]),
    "Trade Banking": dict(
        kind="Corporate banking (trade finance)",
        providers=["SWIFT MT 7xx / ISO 20022 trade messages",
                   "Trade platforms: Finastra Trade Innovation, China Systems",
                   "e-Docs: Bolero, essDOCS; ECAs & credit insurers"],
        cases=["Issue and manage {asset} instruments through their documentary lifecycle",
               "Exchange structured trade messages with counterparty banks",
               "Track shipment/document milestones and trigger payment events"]),
    "Securities": dict(
        kind="Investment banking & wealth",
        providers=["Custodians: BNY Mellon, Citi; CSDs: NSDL/CDSL, Euroclear",
                   "OMS/PMS: Charles River, BlackRock Aladdin",
                   "Connectivity: FIX, SWIFT securities messages"],
        cases=["Maintain {asset} positions and process settlements/corporate actions",
               "Service portfolios for wealth and institutional clients",
               "Reconcile holdings against custodian and CSD records daily"]),
    "Markets and Treasury": dict(
        kind="Treasury & financial markets",
        providers=["Trading & risk: Murex, Calypso, FIS Quantum",
                   "Venues & clearing: CLS, LCH, CCIL; Bloomberg/Refinitiv data"],
        cases=["Manage {asset} books with intraday position and P&L visibility",
               "Execute funding, FX, and hedging workflows under limit controls",
               "Feed risk engines and regulatory trade repositories"]),
    "Operations": dict(
        kind="Universal banking back office",
        providers=["Reconciliation: Duco, SmartStream TLM",
                   "Messaging: SWIFT Alliance, IBM MQ, Kafka",
                   "GL & sub-ledgers: SAP, Oracle"],
        cases=["Process {asset} workloads reliably at end-of-day and intraday",
               "Reconcile internal ledgers against external statements and networks",
               "Surface breaks and exceptions to case management with full lineage"]),
    "Credit Risk": dict(
        kind="Risk management (credit)",
        providers=["Models: Moody's Analytics, SAS; spreading: FIS Optimist",
                   "Bureaus and rating agencies; limits engines"],
        cases=["Assess and refresh {asset} scores/limits across the credit lifecycle",
               "Aggregate exposures across products for single-obligor views",
               "Feed IFRS 9 / Basel capital calculations with current risk data"]),
    "Market and Operational Risk": dict(
        kind="Risk management (market, liquidity, operational)",
        providers=["MSCI RiskMetrics, Murex MLC, SAS",
                   "ALM: QRM, FIS BancWare"],
        cases=["Compute and monitor {asset} measures against board limits",
               "Run stress scenarios and feed ICAAP/ILAAP reporting",
               "Alert treasury and risk committees on threshold breaches"]),
    "Financial Crime": dict(
        kind="Compliance / financial crime prevention",
        providers=["AML & monitoring: NICE Actimize, SAS AML, Oracle FCCM",
                   "Screening: Refinitiv World-Check, Dow Jones; device intel: BioCatch",
                   "Case management platforms"],
        cases=["Detect suspicious {asset} patterns in real time and raise scored alerts",
               "Run KYC/CDD checks at onboarding and on trigger events",
               "Manage investigations end-to-end with audit-grade decision trails",
               "File STRs/SARs to the FIU with supporting evidence"]),
    "Compliance": dict(
        kind="Regulatory compliance & audit",
        providers=["GRC: RSA Archer, MetricStream",
                   "Reg reporting: AxiomSL, Wolters Kluwer OneSumX, Vermeg",
                   "Records: OpenText, Veritas"],
        cases=["Track {asset} obligations and evidence their fulfilment",
               "Produce and submit regulator-ready reports on schedule",
               "Support internal/external audits with complete records retrieval"]),
    "Finance": dict(
        kind="Enterprise finance (the bank's own books)",
        providers=["ERP: SAP S/4HANA, Oracle Financials",
                   "Close & disclosure: Workiva, BlackLine; tax: Vertex"],
        cases=["Operate {asset} processes for the bank's own financial management",
               "Consolidate entity results and produce statutory statements",
               "Plan capital and funding against regulatory ratios"]),
    "Human Resources": dict(
        kind="Enterprise (people operations)",
        providers=["HCM: Workday, SAP SuccessFactors",
                   "Payroll: ADP; learning: Cornerstone, Degreed"],
        cases=["Manage {asset} records through hire-to-retire events",
               "Run payroll/benefits cycles with finance integration",
               "Track certifications and role-based training compliance (critical in regulated banking)"]),
    "Corporate Services": dict(
        kind="Enterprise (facilities, legal, procurement, documents)",
        providers=["DMS: OpenText, SharePoint, iManage (legal)",
                   "Procurement: SAP Ariba, Coupa; IWMS: Archibus"],
        cases=["Administer {asset} services for the organization",
               "Maintain compliant document/records lifecycles with retention rules",
               "Run procurement and vendor management with spend controls"]),
    "Technology and Operations": dict(
        kind="Enterprise IT operations",
        providers=["ITSM: ServiceNow, Jira Service Management",
                   "Observability: Datadog, Grafana stack; CI/CD: ArgoCD, Jenkins"],
        cases=["Operate {asset} processes for the bank's technology estate",
               "Coordinate releases/changes with audit trails (SOX-friendly)",
               "Track incidents and service health against SLOs"]),
    "Business Command and Control": dict(
        kind="Enterprise strategy & architecture",
        providers=["EA: LeanIX, Ardoq; planning: Anaplan",
                   "BI: Power BI, Tableau"],
        cases=["Maintain {asset} artifacts that steer investment and change",
               "Map business capabilities (BIAN landscape!) to systems and initiatives",
               "Monitor strategic KPIs and feed executive decision cycles"]),
}

# ── curated entries for the deep (graduated) domains ─────────────────────────
DEEP_CASES = {
    "sd-current-account": [
        "Open current accounts with KYC gating — no transactions until the customer clears screening",
        "Post deposits/withdrawals with the overdraft facility enforced to the exact limit (one paisa over → rejected)",
        "Freeze (block) accounts that accept credits but reject debits — standard court-order semantics",
        "Stream every posting as `transaction.posted` to Fraud Detection in real time",
        "Credit cleared cheques arriving from Cheque Processing"],
    "sd-savings-account": [
        "Operate no-overdraft savings products with minimum-balance floors enforced at API and DB layers",
        "Apply the classic monthly withdrawal cap (default 6/month, deposits never capped)",
        "Accrue daily interest (basis-point precise, floor arithmetic) and capitalize on demand",
        "Gate activation on KYC outcomes; feed fraud monitoring with every posting"],
    "sd-cheque-processing": [
        "Lodge cheques with instrument validation (no self-deposits, plausible cheque numbers)",
        "Clear through the strict LODGED → PRESENTED → CLEARED | RETURNED state machine",
        "Honor stop orders only before presentment — exactly like a real clearing house",
        "Emit beneficiary credit instructions on clearance for account domains to post"],
    "sd-fraud-detection": [
        "Score every account transaction and cheque lodgement with explainable rules (LARGE/VELOCITY/ROUND)",
        "Raise alerts past a configurable threshold, with reasons attached — never a black box",
        "Run investigator workflows: confirm fraud or dismiss with mandatory notes",
        "Auto-scale on Kafka consumer lag during transaction storms (KEDA profile)"],
    "sd-know-your-customer": [
        "Screen customers at onboarding: watchlist → reject; missing docs / high-risk country → refer",
        "Route referred cases to analysts with audit-mandatory decision reasons",
        "Deliver verdicts back to the requesting account domain via callback (closing the loop)",
        "Maintain the sanctions/PEP watchlist with immediate effect on new assessments"],
    "sd-payment-order": [
        "Accept and validate payment instructions (limits, self-transfer, currency) with recorded rejection reasons",
        "Auto-submit validated orders to Payment Execution; cancel only before the hand-off",
        "Track order outcomes (completed/failed) from execution callbacks",
        "Expose rejected orders as queryable audit records — nothing is silently dropped"],
    "sd-payment-execution": [
        "Move money with a two-leg debit→credit saga and automatic compensation",
        "Guarantee idempotency on order reference — the same order can never execute twice",
        "Surface FAILED_SUSPENSE (funds in flight) loudly to an indexed ops queue, never auto-retried",
        "Exercise every failure path locally via the failure-injectable accounts simulator"],
}


def slugify(t):
    return t.lower().replace(" ", "-").replace("&", "and")


def entry(svc):
    name, repo = svc["serviceDomain"], svc["repo"]
    meta = DOMAIN_META[svc["businessDomain"]]
    deep = svc.get("deep")
    what = (f"BIAN **{svc['functionalPattern']}** service domain operating on the "
            f"**{svc['controlRecord']}** control record — the system of record for "
            f"*{svc['assetType']}* within {svc['businessDomain']}.")
    if deep:
        what += " **DEEP build:** real, tested banking rules (graduated from the template — see the repo README)."
        cases = DEEP_CASES[repo]
    else:
        cases = [c.format(sd=name, asset=svc["assetType"]) for c in meta["cases"]]
    lines = [f"#### [{name}]({GH}/{repo})" + ("  `DEEP`" if deep else ""),
             "",
             f"`{repo}` · namespace `{svc['namespace']}` · gateway path `/{repo}`",
             "",
             what,
             "",
             f"- **Banking type:** {meta['kind']}",
             "- **Typical use cases:**"]
    lines += [f"  {i + 1}. {c}" for i, c in enumerate(cases)]
    lines += ["- **Integrates with (typical backend providers):**"]
    lines += [f"  - {p}" for p in meta["providers"]]
    lines.append("")
    return "\n".join(lines)


def main():
    svcs = REGISTRY["services"]
    by_area = {}
    for s in svcs:
        by_area.setdefault(s["businessArea"], {}).setdefault(s["businessDomain"], []).append(s)

    out = [f"""# 📒 BIAN Platform — Master Catalog

**Every service domain in the landscape, explained.** {len(svcs)} independent microservice repositories — one per BIAN service domain — each with its link, purpose, typical use cases, banking classification, and the backend providers it typically integrates with.

> Interactive version: **https://sreenivas-sadhu-prabhakara.github.io/bian-platform/** (searchable explorer, flagship flow walkthroughs).

---

## 🚀 Run anything in 5 commands

Every repository follows the same paved road — these commands work for **all {len(svcs)} domains** (substitute any repo name):

```bash
# 0. prerequisites (macOS):  brew install docker kind helm kubectl maven
git clone https://github.com/Sreenivas-Sadhu-Prabhakara/bian-platform

# 1. one-time platform bring-up: kind + Cilium mesh + gateway + namespaces
./bian-platform/scripts/bootstrap-cluster.sh

# 2. pick a domain — run it standalone in 10 seconds…
git clone https://github.com/Sreenivas-Sadhu-Prabhakara/sd-current-account
mvn -f sd-current-account spring-boot:run    # → http://localhost:8080/swagger-ui.html

# 3. …or build + deploy it onto the mesh
./bian-platform/scripts/build-all.sh  --only sd-current-account
./bian-platform/scripts/deploy-all.sh --only sd-current-account

# 4. call it through the gateway
kubectl -n bian-system port-forward svc/cilium-gateway-bian-gateway 18080:80 &
curl localhost:18080/sd-current-account/v1/service-domain
```

Optional data/event layers (gated): `CONFIRM_HYDRATE=yes ./bian-platform/platform-infra/postgres/hydrate.sh` · `CONFIRM_KAFKA=yes ./bian-platform/platform-infra/kafka/install.sh`

**Quality bar in every repo:** OpenAPI + event contracts owned per repo (`api/`), a contract test suite that fails the build if code and contract drift, Helm chart with mesh policy, CI on every push.

---

## 🧭 How to read each entry

- **Banking type** — which line of banking the domain serves (retail, corporate, payments, risk, …)
- **Use cases** — at least 3 concrete things you'd build with it
- **Integrates with** — the class of commercial/market backends this domain typically fronts or feeds; the BIAN semantic API is the stable layer you keep while swapping these providers

---
"""]
    # TOC
    out.append("## 📚 Contents\n")
    for area, domains in by_area.items():
        n = sum(len(v) for v in domains.values())
        out.append(f"- **{area}** ({n} domains)")
        for d in domains:
            out.append(f"  - [{d}](#{slugify(d)}) ({len(domains[d])})")
    out.append("\n---\n")

    for area, domains in by_area.items():
        out.append(f"\n## {area}\n")
        for dname, ss in domains.items():
            meta = DOMAIN_META[dname]
            out.append(f"\n### {dname}\n")
            out.append(f"*{meta['kind']}.*\n")
            for s in ss:
                out.append(entry(s))

    out.append(f"""
---

## 🕌 Islamic Banking Landscape

A **separate, fully isolated** Shariah-compliant landscape (its own catalog, template, repos, and master catalog — no code shared with this one) lives at
**[islamic-banking-platform](https://github.com/Sreenivas-Sadhu-Prabhakara/islamic-banking-platform)**.

---

*Generated from `bian-services/registry.json` by `scripts/generate-master-catalog.py` — regenerate after catalog changes. BIAN® is a registered trademark of the Banking Industry Architecture Network; this independent project models its service-landscape concepts.*
""")
    OUT.write_text("\n".join(out))
    print(f"MASTER-CATALOG.md written: {len(svcs)} entries, {len(OUT.read_text().splitlines())} lines")

    # ── structured data for the interactive catalog (docs-site/catalog.html) ──
    records = []
    for s in svcs:
        meta = DOMAIN_META[s["businessDomain"]]
        deep = bool(s.get("deep"))
        cases = DEEP_CASES[s["repo"]] if deep else \
            [c.format(sd=s["serviceDomain"], asset=s["assetType"]) for c in meta["cases"]]
        records.append(dict(
            name=s["serviceDomain"], repo=s["repo"], deep=deep,
            area=s["businessArea"], domain=s["businessDomain"],
            pattern=s["functionalPattern"], asset=s["assetType"],
            cr=s["controlRecord"], ns=s["namespace"],
            kind=meta["kind"], cases=cases, providers=meta["providers"]))
    js = ("// Generated by scripts/generate-master-catalog.py — do not hand-edit.\n"
          "const GH_OWNER = 'Sreenivas-Sadhu-Prabhakara';\n"
          "const CATALOG = " + json.dumps(records, indent=1) + ";\n")
    (HERE / "../docs-site/catalog-data.js").write_text(js)
    print(f"docs-site/catalog-data.js written: {len(records)} records")


if __name__ == "__main__":
    main()
