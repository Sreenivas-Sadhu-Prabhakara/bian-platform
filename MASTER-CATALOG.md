# 📒 BIAN Platform — Master Catalog

**Every service domain in the landscape, explained.** 162 independent microservice repositories — one per BIAN service domain — each with its link, purpose, typical use cases, banking classification, and the backend providers it typically integrates with.

> Interactive version: **https://sreenivas-sadhu-prabhakara.github.io/bian-platform/** (searchable explorer, flagship flow walkthroughs).

---

## 🚀 Run anything in 5 commands

Every repository follows the same paved road — these commands work for **all 162 domains** (substitute any repo name):

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

## 📚 Contents

- **Reference Data** (8 domains)
  - [Reference Data](#reference-data) (8)
- **Sales and Service** (36 domains)
  - [Customer Management](#customer-management) (10)
  - [Sales](#sales) (6)
  - [Marketing](#marketing) (6)
  - [Channels](#channels) (14)
- **Operations and Execution** (60 domains)
  - [Account Management](#account-management) (6)
  - [Payments](#payments) (11)
  - [Cards](#cards) (7)
  - [Loans and Deposits](#loans-and-deposits) (9)
  - [Trade Banking](#trade-banking) (5)
  - [Securities](#securities) (9)
  - [Markets and Treasury](#markets-and-treasury) (7)
  - [Operations](#operations) (6)
- **Risk and Compliance** (24 domains)
  - [Credit Risk](#credit-risk) (5)
  - [Market and Operational Risk](#market-and-operational-risk) (5)
  - [Financial Crime](#financial-crime) (7)
  - [Compliance](#compliance) (7)
- **Business Support** (34 domains)
  - [Finance](#finance) (6)
  - [Human Resources](#human-resources) (7)
  - [Corporate Services](#corporate-services) (9)
  - [Technology and Operations](#technology-and-operations) (7)
  - [Business Command and Control](#business-command-and-control) (5)

---


## Reference Data


### Reference Data

*Universal banking (shared backbone for every line of business).*

#### [Party Reference Data Directory](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-party-reference-data-directory)

`sd-party-reference-data-directory` · namespace `bian-reference-data` · gateway path `/sd-party-reference-data-directory`

BIAN **Catalog** service domain operating on the **Party Reference Data Directory Entry** control record — the system of record for *Party Reference Data* within Reference Data.

- **Banking type:** Universal banking (shared backbone for every line of business)
- **Typical use cases:**
  1. Serve golden-source Party Reference Data data to every other service domain with full audit history
  2. Synchronize Party Reference Data Directory records bi-directionally with the core banking system of record
  3. Provide point-in-time lookups for regulatory reporting and reconciliation
- **Integrates with (typical backend providers):**
  - Core banking: Temenos Transact, Infosys Finacle, Mambu, Thought Machine Vault
  - Market data: Refinitiv/LSEG, Bloomberg, SIX Financial
  - Registries & identity: GLEIF (LEI), SWIFTRef, national ID/address validators (DigiLocker, Loqate)

#### [Customer Reference Data Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-customer-reference-data-management)

`sd-customer-reference-data-management` · namespace `bian-reference-data` · gateway path `/sd-customer-reference-data-management`

BIAN **Maintain** service domain operating on the **Customer Reference Data Maintenance Agreement** control record — the system of record for *Customer Reference Data* within Reference Data.

- **Banking type:** Universal banking (shared backbone for every line of business)
- **Typical use cases:**
  1. Serve golden-source Customer Reference Data data to every other service domain with full audit history
  2. Synchronize Customer Reference Data Management records bi-directionally with the core banking system of record
  3. Provide point-in-time lookups for regulatory reporting and reconciliation
- **Integrates with (typical backend providers):**
  - Core banking: Temenos Transact, Infosys Finacle, Mambu, Thought Machine Vault
  - Market data: Refinitiv/LSEG, Bloomberg, SIX Financial
  - Registries & identity: GLEIF (LEI), SWIFTRef, national ID/address validators (DigiLocker, Loqate)

#### [Product Directory](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-product-directory)

`sd-product-directory` · namespace `bian-reference-data` · gateway path `/sd-product-directory`

BIAN **Catalog** service domain operating on the **Product Reference Data Directory Entry** control record — the system of record for *Product Reference Data* within Reference Data.

- **Banking type:** Universal banking (shared backbone for every line of business)
- **Typical use cases:**
  1. Serve golden-source Product Reference Data data to every other service domain with full audit history
  2. Synchronize Product Directory records bi-directionally with the core banking system of record
  3. Provide point-in-time lookups for regulatory reporting and reconciliation
- **Integrates with (typical backend providers):**
  - Core banking: Temenos Transact, Infosys Finacle, Mambu, Thought Machine Vault
  - Market data: Refinitiv/LSEG, Bloomberg, SIX Financial
  - Registries & identity: GLEIF (LEI), SWIFTRef, national ID/address validators (DigiLocker, Loqate)

#### [Location Data Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-location-data-management)

`sd-location-data-management` · namespace `bian-reference-data` · gateway path `/sd-location-data-management`

BIAN **Maintain** service domain operating on the **Location Reference Data Maintenance Agreement** control record — the system of record for *Location Reference Data* within Reference Data.

- **Banking type:** Universal banking (shared backbone for every line of business)
- **Typical use cases:**
  1. Serve golden-source Location Reference Data data to every other service domain with full audit history
  2. Synchronize Location Data Management records bi-directionally with the core banking system of record
  3. Provide point-in-time lookups for regulatory reporting and reconciliation
- **Integrates with (typical backend providers):**
  - Core banking: Temenos Transact, Infosys Finacle, Mambu, Thought Machine Vault
  - Market data: Refinitiv/LSEG, Bloomberg, SIX Financial
  - Registries & identity: GLEIF (LEI), SWIFTRef, national ID/address validators (DigiLocker, Loqate)

#### [Financial Market Reference Data](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-financial-market-reference-data)

`sd-financial-market-reference-data` · namespace `bian-reference-data` · gateway path `/sd-financial-market-reference-data`

BIAN **Catalog** service domain operating on the **Market Reference Data Directory Entry** control record — the system of record for *Market Reference Data* within Reference Data.

- **Banking type:** Universal banking (shared backbone for every line of business)
- **Typical use cases:**
  1. Serve golden-source Market Reference Data data to every other service domain with full audit history
  2. Synchronize Financial Market Reference Data records bi-directionally with the core banking system of record
  3. Provide point-in-time lookups for regulatory reporting and reconciliation
- **Integrates with (typical backend providers):**
  - Core banking: Temenos Transact, Infosys Finacle, Mambu, Thought Machine Vault
  - Market data: Refinitiv/LSEG, Bloomberg, SIX Financial
  - Registries & identity: GLEIF (LEI), SWIFTRef, national ID/address validators (DigiLocker, Loqate)

#### [Market Data Switch Operation](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-market-data-switch-operation)

`sd-market-data-switch-operation` · namespace `bian-reference-data` · gateway path `/sd-market-data-switch-operation`

BIAN **Operate** service domain operating on the **Market Data Feed Operating Session** control record — the system of record for *Market Data Feed* within Reference Data.

- **Banking type:** Universal banking (shared backbone for every line of business)
- **Typical use cases:**
  1. Serve golden-source Market Data Feed data to every other service domain with full audit history
  2. Synchronize Market Data Switch Operation records bi-directionally with the core banking system of record
  3. Provide point-in-time lookups for regulatory reporting and reconciliation
- **Integrates with (typical backend providers):**
  - Core banking: Temenos Transact, Infosys Finacle, Mambu, Thought Machine Vault
  - Market data: Refinitiv/LSEG, Bloomberg, SIX Financial
  - Registries & identity: GLEIF (LEI), SWIFTRef, national ID/address validators (DigiLocker, Loqate)

#### [Information Provider Operation](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-information-provider-operation)

`sd-information-provider-operation` · namespace `bian-reference-data` · gateway path `/sd-information-provider-operation`

BIAN **Operate** service domain operating on the **Information Feed Operating Session** control record — the system of record for *Information Feed* within Reference Data.

- **Banking type:** Universal banking (shared backbone for every line of business)
- **Typical use cases:**
  1. Serve golden-source Information Feed data to every other service domain with full audit history
  2. Synchronize Information Provider Operation records bi-directionally with the core banking system of record
  3. Provide point-in-time lookups for regulatory reporting and reconciliation
- **Integrates with (typical backend providers):**
  - Core banking: Temenos Transact, Infosys Finacle, Mambu, Thought Machine Vault
  - Market data: Refinitiv/LSEG, Bloomberg, SIX Financial
  - Registries & identity: GLEIF (LEI), SWIFTRef, national ID/address validators (DigiLocker, Loqate)

#### [Quoted Securities Service](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-quoted-securities-service)

`sd-quoted-securities-service` · namespace `bian-reference-data` · gateway path `/sd-quoted-securities-service`

BIAN **Catalog** service domain operating on the **Securities Reference Data Directory Entry** control record — the system of record for *Securities Reference Data* within Reference Data.

- **Banking type:** Universal banking (shared backbone for every line of business)
- **Typical use cases:**
  1. Serve golden-source Securities Reference Data data to every other service domain with full audit history
  2. Synchronize Quoted Securities Service records bi-directionally with the core banking system of record
  3. Provide point-in-time lookups for regulatory reporting and reconciliation
- **Integrates with (typical backend providers):**
  - Core banking: Temenos Transact, Infosys Finacle, Mambu, Thought Machine Vault
  - Market data: Refinitiv/LSEG, Bloomberg, SIX Financial
  - Registries & identity: GLEIF (LEI), SWIFTRef, national ID/address validators (DigiLocker, Loqate)


## Sales and Service


### Customer Management

*Retail & corporate banking (customer lifecycle).*

#### [Customer Relationship Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-customer-relationship-management)

`sd-customer-relationship-management` · namespace `bian-sales-service` · gateway path `/sd-customer-relationship-management`

BIAN **Direct** service domain operating on the **Customer Relationship Strategy** control record — the system of record for *Customer Relationship* within Customer Management.

- **Banking type:** Retail & corporate banking (customer lifecycle)
- **Typical use cases:**
  1. Maintain a single view of the customer across products, channels, and entities
  2. Drive onboarding, servicing, and offboarding journeys for Customer Relationship records
  3. Feed customer analytics, consent, and entitlement decisions to channel applications
- **Integrates with (typical backend providers):**
  - CRM: Salesforce Financial Services Cloud, Microsoft Dynamics 365
  - CIAM: Keycloak, Okta, ForgeRock
  - Credit bureaus: CIBIL, Experian, Equifax
  - KYC utilities & registries

#### [Customer Profile](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-customer-profile)

`sd-customer-profile` · namespace `bian-sales-service` · gateway path `/sd-customer-profile`

BIAN **Maintain** service domain operating on the **Customer Profile Maintenance Agreement** control record — the system of record for *Customer Profile* within Customer Management.

- **Banking type:** Retail & corporate banking (customer lifecycle)
- **Typical use cases:**
  1. Maintain a single view of the customer across products, channels, and entities
  2. Drive onboarding, servicing, and offboarding journeys for Customer Profile records
  3. Feed customer analytics, consent, and entitlement decisions to channel applications
- **Integrates with (typical backend providers):**
  - CRM: Salesforce Financial Services Cloud, Microsoft Dynamics 365
  - CIAM: Keycloak, Okta, ForgeRock
  - Credit bureaus: CIBIL, Experian, Equifax
  - KYC utilities & registries

#### [Customer Agreement](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-customer-agreement)

`sd-customer-agreement` · namespace `bian-sales-service` · gateway path `/sd-customer-agreement`

BIAN **Manage** service domain operating on the **Customer Agreement Management Plan** control record — the system of record for *Customer Agreement* within Customer Management.

- **Banking type:** Retail & corporate banking (customer lifecycle)
- **Typical use cases:**
  1. Maintain a single view of the customer across products, channels, and entities
  2. Drive onboarding, servicing, and offboarding journeys for Customer Agreement records
  3. Feed customer analytics, consent, and entitlement decisions to channel applications
- **Integrates with (typical backend providers):**
  - CRM: Salesforce Financial Services Cloud, Microsoft Dynamics 365
  - CIAM: Keycloak, Okta, ForgeRock
  - Credit bureaus: CIBIL, Experian, Equifax
  - KYC utilities & registries

#### [Customer Behavior Insights](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-customer-behavior-insights)

`sd-customer-behavior-insights` · namespace `bian-sales-service` · gateway path `/sd-customer-behavior-insights`

BIAN **Analyze** service domain operating on the **Customer Behavior Model Analysis** control record — the system of record for *Customer Behavior Model* within Customer Management.

- **Banking type:** Retail & corporate banking (customer lifecycle)
- **Typical use cases:**
  1. Maintain a single view of the customer across products, channels, and entities
  2. Drive onboarding, servicing, and offboarding journeys for Customer Behavior Model records
  3. Feed customer analytics, consent, and entitlement decisions to channel applications
- **Integrates with (typical backend providers):**
  - CRM: Salesforce Financial Services Cloud, Microsoft Dynamics 365
  - CIAM: Keycloak, Okta, ForgeRock
  - Credit bureaus: CIBIL, Experian, Equifax
  - KYC utilities & registries

#### [Customer Event History](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-customer-event-history)

`sd-customer-event-history` · namespace `bian-sales-service` · gateway path `/sd-customer-event-history`

BIAN **Maintain** service domain operating on the **Customer Event Log Maintenance Agreement** control record — the system of record for *Customer Event Log* within Customer Management.

- **Banking type:** Retail & corporate banking (customer lifecycle)
- **Typical use cases:**
  1. Maintain a single view of the customer across products, channels, and entities
  2. Drive onboarding, servicing, and offboarding journeys for Customer Event Log records
  3. Feed customer analytics, consent, and entitlement decisions to channel applications
- **Integrates with (typical backend providers):**
  - CRM: Salesforce Financial Services Cloud, Microsoft Dynamics 365
  - CIAM: Keycloak, Okta, ForgeRock
  - Credit bureaus: CIBIL, Experian, Equifax
  - KYC utilities & registries

#### [Customer Case Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-customer-case-management)

`sd-customer-case-management` · namespace `bian-sales-service` · gateway path `/sd-customer-case-management`

BIAN **Manage** service domain operating on the **Customer Case Management Plan** control record — the system of record for *Customer Case* within Customer Management.

- **Banking type:** Retail & corporate banking (customer lifecycle)
- **Typical use cases:**
  1. Maintain a single view of the customer across products, channels, and entities
  2. Drive onboarding, servicing, and offboarding journeys for Customer Case records
  3. Feed customer analytics, consent, and entitlement decisions to channel applications
- **Integrates with (typical backend providers):**
  - CRM: Salesforce Financial Services Cloud, Microsoft Dynamics 365
  - CIAM: Keycloak, Okta, ForgeRock
  - Credit bureaus: CIBIL, Experian, Equifax
  - KYC utilities & registries

#### [Customer Access Entitlement](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-customer-access-entitlement)

`sd-customer-access-entitlement` · namespace `bian-sales-service` · gateway path `/sd-customer-access-entitlement`

BIAN **Administer** service domain operating on the **Access Entitlement Administrative Plan** control record — the system of record for *Access Entitlement* within Customer Management.

- **Banking type:** Retail & corporate banking (customer lifecycle)
- **Typical use cases:**
  1. Maintain a single view of the customer across products, channels, and entities
  2. Drive onboarding, servicing, and offboarding journeys for Access Entitlement records
  3. Feed customer analytics, consent, and entitlement decisions to channel applications
- **Integrates with (typical backend providers):**
  - CRM: Salesforce Financial Services Cloud, Microsoft Dynamics 365
  - CIAM: Keycloak, Okta, ForgeRock
  - Credit bureaus: CIBIL, Experian, Equifax
  - KYC utilities & registries

#### [Customer Position](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-customer-position)

`sd-customer-position` · namespace `bian-sales-service` · gateway path `/sd-customer-position`

BIAN **Manage** service domain operating on the **Customer Position Management Plan** control record — the system of record for *Customer Position* within Customer Management.

- **Banking type:** Retail & corporate banking (customer lifecycle)
- **Typical use cases:**
  1. Maintain a single view of the customer across products, channels, and entities
  2. Drive onboarding, servicing, and offboarding journeys for Customer Position records
  3. Feed customer analytics, consent, and entitlement decisions to channel applications
- **Integrates with (typical backend providers):**
  - CRM: Salesforce Financial Services Cloud, Microsoft Dynamics 365
  - CIAM: Keycloak, Okta, ForgeRock
  - Credit bureaus: CIBIL, Experian, Equifax
  - KYC utilities & registries

#### [Party Lifecycle Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-party-lifecycle-management)

`sd-party-lifecycle-management` · namespace `bian-sales-service` · gateway path `/sd-party-lifecycle-management`

BIAN **Manage** service domain operating on the **Party Record Management Plan** control record — the system of record for *Party Record* within Customer Management.

- **Banking type:** Retail & corporate banking (customer lifecycle)
- **Typical use cases:**
  1. Maintain a single view of the customer across products, channels, and entities
  2. Drive onboarding, servicing, and offboarding journeys for Party Record records
  3. Feed customer analytics, consent, and entitlement decisions to channel applications
- **Integrates with (typical backend providers):**
  - CRM: Salesforce Financial Services Cloud, Microsoft Dynamics 365
  - CIAM: Keycloak, Okta, ForgeRock
  - Credit bureaus: CIBIL, Experian, Equifax
  - KYC utilities & registries

#### [Customer Tax Handling](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-customer-tax-handling)

`sd-customer-tax-handling` · namespace `bian-sales-service` · gateway path `/sd-customer-tax-handling`

BIAN **Process** service domain operating on the **Customer Tax Record Procedure** control record — the system of record for *Customer Tax Record* within Customer Management.

- **Banking type:** Retail & corporate banking (customer lifecycle)
- **Typical use cases:**
  1. Maintain a single view of the customer across products, channels, and entities
  2. Drive onboarding, servicing, and offboarding journeys for Customer Tax Record records
  3. Feed customer analytics, consent, and entitlement decisions to channel applications
- **Integrates with (typical backend providers):**
  - CRM: Salesforce Financial Services Cloud, Microsoft Dynamics 365
  - CIAM: Keycloak, Okta, ForgeRock
  - Credit bureaus: CIBIL, Experian, Equifax
  - KYC utilities & registries


### Sales

*Retail banking (sales & origination).*

#### [Sales Planning](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-sales-planning)

`sd-sales-planning` · namespace `bian-sales-service` · gateway path `/sd-sales-planning`

BIAN **Plan** service domain operating on the **Sales Plan Plan** control record — the system of record for *Sales Plan* within Sales.

- **Banking type:** Retail banking (sales & origination)
- **Typical use cases:**
  1. Run Sales Planning workflows from lead capture through fulfilled product agreement
  2. Match customers to eligible products using bureau + behavioral data
  3. Track conversion funnels and hand off won opportunities to fulfillment domains
- **Integrates with (typical backend providers):**
  - CRM & lead engines: Salesforce, HubSpot
  - Pricing/offer engines: Earnix, Nomis
  - Origination platforms: nCino, FinnOne

#### [Lead Opportunity Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-lead-opportunity-management)

`sd-lead-opportunity-management` · namespace `bian-sales-service` · gateway path `/sd-lead-opportunity-management`

BIAN **Manage** service domain operating on the **Sales Lead Management Plan** control record — the system of record for *Sales Lead* within Sales.

- **Banking type:** Retail banking (sales & origination)
- **Typical use cases:**
  1. Run Lead Opportunity Management workflows from lead capture through fulfilled product agreement
  2. Match customers to eligible products using bureau + behavioral data
  3. Track conversion funnels and hand off won opportunities to fulfillment domains
- **Integrates with (typical backend providers):**
  - CRM & lead engines: Salesforce, HubSpot
  - Pricing/offer engines: Earnix, Nomis
  - Origination platforms: nCino, FinnOne

#### [Customer Offer](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-customer-offer)

`sd-customer-offer` · namespace `bian-sales-service` · gateway path `/sd-customer-offer`

BIAN **Manage** service domain operating on the **Customer Offer Management Plan** control record — the system of record for *Customer Offer* within Sales.

- **Banking type:** Retail banking (sales & origination)
- **Typical use cases:**
  1. Run Customer Offer workflows from lead capture through fulfilled product agreement
  2. Match customers to eligible products using bureau + behavioral data
  3. Track conversion funnels and hand off won opportunities to fulfillment domains
- **Integrates with (typical backend providers):**
  - CRM & lead engines: Salesforce, HubSpot
  - Pricing/offer engines: Earnix, Nomis
  - Origination platforms: nCino, FinnOne

#### [Product Matching](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-product-matching)

`sd-product-matching` · namespace `bian-sales-service` · gateway path `/sd-product-matching`

BIAN **Process** service domain operating on the **Product Match Procedure** control record — the system of record for *Product Match* within Sales.

- **Banking type:** Retail banking (sales & origination)
- **Typical use cases:**
  1. Run Product Matching workflows from lead capture through fulfilled product agreement
  2. Match customers to eligible products using bureau + behavioral data
  3. Track conversion funnels and hand off won opportunities to fulfillment domains
- **Integrates with (typical backend providers):**
  - CRM & lead engines: Salesforce, HubSpot
  - Pricing/offer engines: Earnix, Nomis
  - Origination platforms: nCino, FinnOne

#### [Sales Product Agreement](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-sales-product-agreement)

`sd-sales-product-agreement` · namespace `bian-sales-service` · gateway path `/sd-sales-product-agreement`

BIAN **Manage** service domain operating on the **Sales Product Agreement Management Plan** control record — the system of record for *Sales Product Agreement* within Sales.

- **Banking type:** Retail banking (sales & origination)
- **Typical use cases:**
  1. Run Sales Product Agreement workflows from lead capture through fulfilled product agreement
  2. Match customers to eligible products using bureau + behavioral data
  3. Track conversion funnels and hand off won opportunities to fulfillment domains
- **Integrates with (typical backend providers):**
  - CRM & lead engines: Salesforce, HubSpot
  - Pricing/offer engines: Earnix, Nomis
  - Origination platforms: nCino, FinnOne

#### [Prospect Campaign Design](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-prospect-campaign-design)

`sd-prospect-campaign-design` · namespace `bian-sales-service` · gateway path `/sd-prospect-campaign-design`

BIAN **Design** service domain operating on the **Prospect Campaign Design** control record — the system of record for *Prospect Campaign* within Sales.

- **Banking type:** Retail banking (sales & origination)
- **Typical use cases:**
  1. Run Prospect Campaign Design workflows from lead capture through fulfilled product agreement
  2. Match customers to eligible products using bureau + behavioral data
  3. Track conversion funnels and hand off won opportunities to fulfillment domains
- **Integrates with (typical backend providers):**
  - CRM & lead engines: Salesforce, HubSpot
  - Pricing/offer engines: Earnix, Nomis
  - Origination platforms: nCino, FinnOne


### Marketing

*Retail banking (engagement).*

#### [Brand Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-brand-management)

`sd-brand-management` · namespace `bian-sales-service` · gateway path `/sd-brand-management`

BIAN **Manage** service domain operating on the **Brand Plan Management Plan** control record — the system of record for *Brand Plan* within Marketing.

- **Banking type:** Retail banking (engagement)
- **Typical use cases:**
  1. Design and launch Brand Plan programs targeted by segment and channel
  2. Measure campaign attribution against account-opening and usage events
  3. Coordinate brand, promotion, and survey activity across markets
- **Integrates with (typical backend providers):**
  - Martech: Adobe Experience Cloud, Salesforce Marketing Cloud, Braze
  - Analytics/CDP: Segment, Amplitude

#### [Advertising](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-advertising)

`sd-advertising` · namespace `bian-sales-service` · gateway path `/sd-advertising`

BIAN **Operate** service domain operating on the **Advertising Campaign Operating Session** control record — the system of record for *Advertising Campaign* within Marketing.

- **Banking type:** Retail banking (engagement)
- **Typical use cases:**
  1. Design and launch Advertising Campaign programs targeted by segment and channel
  2. Measure campaign attribution against account-opening and usage events
  3. Coordinate brand, promotion, and survey activity across markets
- **Integrates with (typical backend providers):**
  - Martech: Adobe Experience Cloud, Salesforce Marketing Cloud, Braze
  - Analytics/CDP: Segment, Amplitude

#### [Marketing Campaign Design](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-marketing-campaign-design)

`sd-marketing-campaign-design` · namespace `bian-sales-service` · gateway path `/sd-marketing-campaign-design`

BIAN **Design** service domain operating on the **Marketing Campaign Design** control record — the system of record for *Marketing Campaign* within Marketing.

- **Banking type:** Retail banking (engagement)
- **Typical use cases:**
  1. Design and launch Marketing Campaign programs targeted by segment and channel
  2. Measure campaign attribution against account-opening and usage events
  3. Coordinate brand, promotion, and survey activity across markets
- **Integrates with (typical backend providers):**
  - Martech: Adobe Experience Cloud, Salesforce Marketing Cloud, Braze
  - Analytics/CDP: Segment, Amplitude

#### [Promotional Events](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-promotional-events)

`sd-promotional-events` · namespace `bian-sales-service` · gateway path `/sd-promotional-events`

BIAN **Operate** service domain operating on the **Promotional Event Operating Session** control record — the system of record for *Promotional Event* within Marketing.

- **Banking type:** Retail banking (engagement)
- **Typical use cases:**
  1. Design and launch Promotional Event programs targeted by segment and channel
  2. Measure campaign attribution against account-opening and usage events
  3. Coordinate brand, promotion, and survey activity across markets
- **Integrates with (typical backend providers):**
  - Martech: Adobe Experience Cloud, Salesforce Marketing Cloud, Braze
  - Analytics/CDP: Segment, Amplitude

#### [Market Research](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-market-research)

`sd-market-research` · namespace `bian-sales-service` · gateway path `/sd-market-research`

BIAN **Analyze** service domain operating on the **Market Research Study Analysis** control record — the system of record for *Market Research Study* within Marketing.

- **Banking type:** Retail banking (engagement)
- **Typical use cases:**
  1. Design and launch Market Research Study programs targeted by segment and channel
  2. Measure campaign attribution against account-opening and usage events
  3. Coordinate brand, promotion, and survey activity across markets
- **Integrates with (typical backend providers):**
  - Martech: Adobe Experience Cloud, Salesforce Marketing Cloud, Braze
  - Analytics/CDP: Segment, Amplitude

#### [Customer Surveys](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-customer-surveys)

`sd-customer-surveys` · namespace `bian-sales-service` · gateway path `/sd-customer-surveys`

BIAN **Operate** service domain operating on the **Customer Survey Operating Session** control record — the system of record for *Customer Survey* within Marketing.

- **Banking type:** Retail banking (engagement)
- **Typical use cases:**
  1. Design and launch Customer Survey programs targeted by segment and channel
  2. Measure campaign attribution against account-opening and usage events
  3. Coordinate brand, promotion, and survey activity across markets
- **Integrates with (typical backend providers):**
  - Martech: Adobe Experience Cloud, Salesforce Marketing Cloud, Braze
  - Analytics/CDP: Segment, Amplitude


### Channels

*Retail & universal banking (distribution).*

#### [Contact Center Operation](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-contact-center-operation)

`sd-contact-center-operation` · namespace `bian-sales-service` · gateway path `/sd-contact-center-operation`

BIAN **Operate** service domain operating on the **Contact Center Session Operating Session** control record — the system of record for *Contact Center Session* within Channels.

- **Banking type:** Retail & universal banking (distribution)
- **Typical use cases:**
  1. Operate the Contact Center Session touchpoint and expose its sessions/events to the bank
  2. Route customer contacts and service orders to the right fulfillment domain
  3. Capture channel telemetry for fraud signals and experience analytics
- **Integrates with (typical backend providers):**
  - Digital banking: Backbase, Temenos Infinity
  - ATM/POS: NCR, Diebold Nixdorf, Verifone, Ingenico
  - Contact center: Genesys, Twilio Flex, Amazon Connect

#### [Contact Center Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-contact-center-management)

`sd-contact-center-management` · namespace `bian-sales-service` · gateway path `/sd-contact-center-management`

BIAN **Manage** service domain operating on the **Contact Center Plan Management Plan** control record — the system of record for *Contact Center Plan* within Channels.

- **Banking type:** Retail & universal banking (distribution)
- **Typical use cases:**
  1. Operate the Contact Center Plan touchpoint and expose its sessions/events to the bank
  2. Route customer contacts and service orders to the right fulfillment domain
  3. Capture channel telemetry for fraud signals and experience analytics
- **Integrates with (typical backend providers):**
  - Digital banking: Backbase, Temenos Infinity
  - ATM/POS: NCR, Diebold Nixdorf, Verifone, Ingenico
  - Contact center: Genesys, Twilio Flex, Amazon Connect

#### [Contact Routing](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-contact-routing)

`sd-contact-routing` · namespace `bian-sales-service` · gateway path `/sd-contact-routing`

BIAN **Process** service domain operating on the **Contact Routing Record Procedure** control record — the system of record for *Contact Routing Record* within Channels.

- **Banking type:** Retail & universal banking (distribution)
- **Typical use cases:**
  1. Operate the Contact Routing Record touchpoint and expose its sessions/events to the bank
  2. Route customer contacts and service orders to the right fulfillment domain
  3. Capture channel telemetry for fraud signals and experience analytics
- **Integrates with (typical backend providers):**
  - Digital banking: Backbase, Temenos Infinity
  - ATM/POS: NCR, Diebold Nixdorf, Verifone, Ingenico
  - Contact center: Genesys, Twilio Flex, Amazon Connect

#### [Branch Location Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-branch-location-management)

`sd-branch-location-management` · namespace `bian-sales-service` · gateway path `/sd-branch-location-management`

BIAN **Operate** service domain operating on the **Branch Operation Operating Session** control record — the system of record for *Branch Operation* within Channels.

- **Banking type:** Retail & universal banking (distribution)
- **Typical use cases:**
  1. Operate the Branch Operation touchpoint and expose its sessions/events to the bank
  2. Route customer contacts and service orders to the right fulfillment domain
  3. Capture channel telemetry for fraud signals and experience analytics
- **Integrates with (typical backend providers):**
  - Digital banking: Backbase, Temenos Infinity
  - ATM/POS: NCR, Diebold Nixdorf, Verifone, Ingenico
  - Contact center: Genesys, Twilio Flex, Amazon Connect

#### [E-Branch Operation](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-e-branch-operation)

`sd-e-branch-operation` · namespace `bian-sales-service` · gateway path `/sd-e-branch-operation`

BIAN **Operate** service domain operating on the **Digital Branch Session Operating Session** control record — the system of record for *Digital Branch Session* within Channels.

- **Banking type:** Retail & universal banking (distribution)
- **Typical use cases:**
  1. Operate the Digital Branch Session touchpoint and expose its sessions/events to the bank
  2. Route customer contacts and service orders to the right fulfillment domain
  3. Capture channel telemetry for fraud signals and experience analytics
- **Integrates with (typical backend providers):**
  - Digital banking: Backbase, Temenos Infinity
  - ATM/POS: NCR, Diebold Nixdorf, Verifone, Ingenico
  - Contact center: Genesys, Twilio Flex, Amazon Connect

#### [ATM Network Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-atm-network-management)

`sd-atm-network-management` · namespace `bian-sales-service` · gateway path `/sd-atm-network-management`

BIAN **Operate** service domain operating on the **ATM Network Operating Session** control record — the system of record for *ATM Network* within Channels.

- **Banking type:** Retail & universal banking (distribution)
- **Typical use cases:**
  1. Operate the ATM Network touchpoint and expose its sessions/events to the bank
  2. Route customer contacts and service orders to the right fulfillment domain
  3. Capture channel telemetry for fraud signals and experience analytics
- **Integrates with (typical backend providers):**
  - Digital banking: Backbase, Temenos Infinity
  - ATM/POS: NCR, Diebold Nixdorf, Verifone, Ingenico
  - Contact center: Genesys, Twilio Flex, Amazon Connect

#### [Point Of Service](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-point-of-service)

`sd-point-of-service` · namespace `bian-sales-service` · gateway path `/sd-point-of-service`

BIAN **Operate** service domain operating on the **POS Session Operating Session** control record — the system of record for *POS Session* within Channels.

- **Banking type:** Retail & universal banking (distribution)
- **Typical use cases:**
  1. Operate the POS Session touchpoint and expose its sessions/events to the bank
  2. Route customer contacts and service orders to the right fulfillment domain
  3. Capture channel telemetry for fraud signals and experience analytics
- **Integrates with (typical backend providers):**
  - Digital banking: Backbase, Temenos Infinity
  - ATM/POS: NCR, Diebold Nixdorf, Verifone, Ingenico
  - Contact center: Genesys, Twilio Flex, Amazon Connect

#### [Card Terminal Administration](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-card-terminal-administration)

`sd-card-terminal-administration` · namespace `bian-sales-service` · gateway path `/sd-card-terminal-administration`

BIAN **Administer** service domain operating on the **Card Terminal Administrative Plan** control record — the system of record for *Card Terminal* within Channels.

- **Banking type:** Retail & universal banking (distribution)
- **Typical use cases:**
  1. Operate the Card Terminal touchpoint and expose its sessions/events to the bank
  2. Route customer contacts and service orders to the right fulfillment domain
  3. Capture channel telemetry for fraud signals and experience analytics
- **Integrates with (typical backend providers):**
  - Digital banking: Backbase, Temenos Infinity
  - ATM/POS: NCR, Diebold Nixdorf, Verifone, Ingenico
  - Contact center: Genesys, Twilio Flex, Amazon Connect

#### [Servicing Mandate](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-servicing-mandate)

`sd-servicing-mandate` · namespace `bian-sales-service` · gateway path `/sd-servicing-mandate`

BIAN **Manage** service domain operating on the **Servicing Mandate Management Plan** control record — the system of record for *Servicing Mandate* within Channels.

- **Banking type:** Retail & universal banking (distribution)
- **Typical use cases:**
  1. Operate the Servicing Mandate touchpoint and expose its sessions/events to the bank
  2. Route customer contacts and service orders to the right fulfillment domain
  3. Capture channel telemetry for fraud signals and experience analytics
- **Integrates with (typical backend providers):**
  - Digital banking: Backbase, Temenos Infinity
  - ATM/POS: NCR, Diebold Nixdorf, Verifone, Ingenico
  - Contact center: Genesys, Twilio Flex, Amazon Connect

#### [Servicing Order](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-servicing-order)

`sd-servicing-order` · namespace `bian-sales-service` · gateway path `/sd-servicing-order`

BIAN **Process** service domain operating on the **Servicing Order Procedure** control record — the system of record for *Servicing Order* within Channels.

- **Banking type:** Retail & universal banking (distribution)
- **Typical use cases:**
  1. Operate the Servicing Order touchpoint and expose its sessions/events to the bank
  2. Route customer contacts and service orders to the right fulfillment domain
  3. Capture channel telemetry for fraud signals and experience analytics
- **Integrates with (typical backend providers):**
  - Digital banking: Backbase, Temenos Infinity
  - ATM/POS: NCR, Diebold Nixdorf, Verifone, Ingenico
  - Contact center: Genesys, Twilio Flex, Amazon Connect

#### [Customer Workbench](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-customer-workbench)

`sd-customer-workbench` · namespace `bian-sales-service` · gateway path `/sd-customer-workbench`

BIAN **Operate** service domain operating on the **Servicing Session Operating Session** control record — the system of record for *Servicing Session* within Channels.

- **Banking type:** Retail & universal banking (distribution)
- **Typical use cases:**
  1. Operate the Servicing Session touchpoint and expose its sessions/events to the bank
  2. Route customer contacts and service orders to the right fulfillment domain
  3. Capture channel telemetry for fraud signals and experience analytics
- **Integrates with (typical backend providers):**
  - Digital banking: Backbase, Temenos Infinity
  - ATM/POS: NCR, Diebold Nixdorf, Verifone, Ingenico
  - Contact center: Genesys, Twilio Flex, Amazon Connect

#### [Advisor Workbench](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-advisor-workbench)

`sd-advisor-workbench` · namespace `bian-sales-service` · gateway path `/sd-advisor-workbench`

BIAN **Operate** service domain operating on the **Advisory Session Operating Session** control record — the system of record for *Advisory Session* within Channels.

- **Banking type:** Retail & universal banking (distribution)
- **Typical use cases:**
  1. Operate the Advisory Session touchpoint and expose its sessions/events to the bank
  2. Route customer contacts and service orders to the right fulfillment domain
  3. Capture channel telemetry for fraud signals and experience analytics
- **Integrates with (typical backend providers):**
  - Digital banking: Backbase, Temenos Infinity
  - ATM/POS: NCR, Diebold Nixdorf, Verifone, Ingenico
  - Contact center: Genesys, Twilio Flex, Amazon Connect

#### [Channel Activity Analysis](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-channel-activity-analysis)

`sd-channel-activity-analysis` · namespace `bian-sales-service` · gateway path `/sd-channel-activity-analysis`

BIAN **Analyze** service domain operating on the **Channel Activity Model Analysis** control record — the system of record for *Channel Activity Model* within Channels.

- **Banking type:** Retail & universal banking (distribution)
- **Typical use cases:**
  1. Operate the Channel Activity Model touchpoint and expose its sessions/events to the bank
  2. Route customer contacts and service orders to the right fulfillment domain
  3. Capture channel telemetry for fraud signals and experience analytics
- **Integrates with (typical backend providers):**
  - Digital banking: Backbase, Temenos Infinity
  - ATM/POS: NCR, Diebold Nixdorf, Verifone, Ingenico
  - Contact center: Genesys, Twilio Flex, Amazon Connect

#### [Channel Activity History](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-channel-activity-history)

`sd-channel-activity-history` · namespace `bian-sales-service` · gateway path `/sd-channel-activity-history`

BIAN **Maintain** service domain operating on the **Channel Activity Log Maintenance Agreement** control record — the system of record for *Channel Activity Log* within Channels.

- **Banking type:** Retail & universal banking (distribution)
- **Typical use cases:**
  1. Operate the Channel Activity Log touchpoint and expose its sessions/events to the bank
  2. Route customer contacts and service orders to the right fulfillment domain
  3. Capture channel telemetry for fraud signals and experience analytics
- **Integrates with (typical backend providers):**
  - Digital banking: Backbase, Temenos Infinity
  - ATM/POS: NCR, Diebold Nixdorf, Verifone, Ingenico
  - Contact center: Genesys, Twilio Flex, Amazon Connect


## Operations and Execution


### Account Management

*Retail core banking (deposits & current accounts).*

#### [Current Account](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-current-account)

`sd-current-account` · namespace `bian-operations` · gateway path `/sd-current-account`

BIAN **Fulfill** service domain operating on the **Current Account Facility Fulfillment Arrangement** control record — the system of record for *Current Account Facility* within Account Management.

- **Banking type:** Retail core banking (deposits & current accounts)
- **Typical use cases:**
  1. Open, service, block, and close Current Account Facility records with full posting history
  2. Post deposits/withdrawals with balance and overdraft/minimum rules enforced
  3. Stream transaction events to fraud monitoring and customer notifications
  4. Drive interest accrual/fees and feed the general ledger
- **Integrates with (typical backend providers):**
  - Core ledgers: Thought Machine Vault, Mambu, Temenos, Finacle
  - Statements/comms: Quadient, OpenText Exstream
  - Billing: Zuora, SAP BRIM

#### [Savings Account](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-savings-account)

`sd-savings-account` · namespace `bian-operations` · gateway path `/sd-savings-account`

BIAN **Fulfill** service domain operating on the **Savings Account Facility Fulfillment Arrangement** control record — the system of record for *Savings Account Facility* within Account Management.

- **Banking type:** Retail core banking (deposits & current accounts)
- **Typical use cases:**
  1. Open, service, block, and close Savings Account Facility records with full posting history
  2. Post deposits/withdrawals with balance and overdraft/minimum rules enforced
  3. Stream transaction events to fraud monitoring and customer notifications
  4. Drive interest accrual/fees and feed the general ledger
- **Integrates with (typical backend providers):**
  - Core ledgers: Thought Machine Vault, Mambu, Temenos, Finacle
  - Statements/comms: Quadient, OpenText Exstream
  - Billing: Zuora, SAP BRIM

#### [Deposit Account](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-deposit-account)

`sd-deposit-account` · namespace `bian-operations` · gateway path `/sd-deposit-account`

BIAN **Fulfill** service domain operating on the **Deposit Account Facility Fulfillment Arrangement** control record — the system of record for *Deposit Account Facility* within Account Management.

- **Banking type:** Retail core banking (deposits & current accounts)
- **Typical use cases:**
  1. Open, service, block, and close Deposit Account Facility records with full posting history
  2. Post deposits/withdrawals with balance and overdraft/minimum rules enforced
  3. Stream transaction events to fraud monitoring and customer notifications
  4. Drive interest accrual/fees and feed the general ledger
- **Integrates with (typical backend providers):**
  - Core ledgers: Thought Machine Vault, Mambu, Temenos, Finacle
  - Statements/comms: Quadient, OpenText Exstream
  - Billing: Zuora, SAP BRIM

#### [Customer Billing](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-customer-billing)

`sd-customer-billing` · namespace `bian-operations` · gateway path `/sd-customer-billing`

BIAN **Process** service domain operating on the **Customer Bill Procedure** control record — the system of record for *Customer Bill* within Account Management.

- **Banking type:** Retail core banking (deposits & current accounts)
- **Typical use cases:**
  1. Open, service, block, and close Customer Bill records with full posting history
  2. Post deposits/withdrawals with balance and overdraft/minimum rules enforced
  3. Stream transaction events to fraud monitoring and customer notifications
  4. Drive interest accrual/fees and feed the general ledger
- **Integrates with (typical backend providers):**
  - Core ledgers: Thought Machine Vault, Mambu, Temenos, Finacle
  - Statements/comms: Quadient, OpenText Exstream
  - Billing: Zuora, SAP BRIM

#### [Reward Points Account](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-reward-points-account)

`sd-reward-points-account` · namespace `bian-operations` · gateway path `/sd-reward-points-account`

BIAN **Fulfill** service domain operating on the **Reward Points Facility Fulfillment Arrangement** control record — the system of record for *Reward Points Facility* within Account Management.

- **Banking type:** Retail core banking (deposits & current accounts)
- **Typical use cases:**
  1. Open, service, block, and close Reward Points Facility records with full posting history
  2. Post deposits/withdrawals with balance and overdraft/minimum rules enforced
  3. Stream transaction events to fraud monitoring and customer notifications
  4. Drive interest accrual/fees and feed the general ledger
- **Integrates with (typical backend providers):**
  - Core ledgers: Thought Machine Vault, Mambu, Temenos, Finacle
  - Statements/comms: Quadient, OpenText Exstream
  - Billing: Zuora, SAP BRIM

#### [Customer Tax Withholding](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-customer-tax-withholding)

`sd-customer-tax-withholding` · namespace `bian-operations` · gateway path `/sd-customer-tax-withholding`

BIAN **Process** service domain operating on the **Tax Withholding Record Procedure** control record — the system of record for *Tax Withholding Record* within Account Management.

- **Banking type:** Retail core banking (deposits & current accounts)
- **Typical use cases:**
  1. Open, service, block, and close Tax Withholding Record records with full posting history
  2. Post deposits/withdrawals with balance and overdraft/minimum rules enforced
  3. Stream transaction events to fraud monitoring and customer notifications
  4. Drive interest accrual/fees and feed the general ledger
- **Integrates with (typical backend providers):**
  - Core ledgers: Thought Machine Vault, Mambu, Temenos, Finacle
  - Statements/comms: Quadient, OpenText Exstream
  - Billing: Zuora, SAP BRIM


### Payments

*Payments / transaction banking.*

#### [Payment Order](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-payment-order)

`sd-payment-order` · namespace `bian-operations` · gateway path `/sd-payment-order`

BIAN **Process** service domain operating on the **Payment Order Procedure** control record — the system of record for *Payment Order* within Payments.

- **Banking type:** Payments / transaction banking
- **Typical use cases:**
  1. Accept, validate, and route Payment Order instructions to the correct rail
  2. Execute transfers with debit/credit atomicity and compensation on failure
  3. Provide payment status tracking to channels and corporate clients (gpi-style)
  4. Screen instructions against sanctions lists before release
- **Integrates with (typical backend providers):**
  - Rails: SWIFT, SEPA, ACH/NACHA, UPI (NPCI), NEFT/RTGS/IMPS, FedNow, TARGET2
  - Payment hubs: Volante, ACI Worldwide, FIS, Finastra
  - Sanctions screening: Fircosoft, LexisNexis Bridger

#### [Payment Execution](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-payment-execution)

`sd-payment-execution` · namespace `bian-operations` · gateway path `/sd-payment-execution`

BIAN **Process** service domain operating on the **Payment Transaction Procedure** control record — the system of record for *Payment Transaction* within Payments.

- **Banking type:** Payments / transaction banking
- **Typical use cases:**
  1. Accept, validate, and route Payment Transaction instructions to the correct rail
  2. Execute transfers with debit/credit atomicity and compensation on failure
  3. Provide payment status tracking to channels and corporate clients (gpi-style)
  4. Screen instructions against sanctions lists before release
- **Integrates with (typical backend providers):**
  - Rails: SWIFT, SEPA, ACH/NACHA, UPI (NPCI), NEFT/RTGS/IMPS, FedNow, TARGET2
  - Payment hubs: Volante, ACI Worldwide, FIS, Finastra
  - Sanctions screening: Fircosoft, LexisNexis Bridger

#### [Payment Initiation](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-payment-initiation)

`sd-payment-initiation` · namespace `bian-operations` · gateway path `/sd-payment-initiation`

BIAN **Process** service domain operating on the **Payment Instruction Procedure** control record — the system of record for *Payment Instruction* within Payments.

- **Banking type:** Payments / transaction banking
- **Typical use cases:**
  1. Accept, validate, and route Payment Instruction instructions to the correct rail
  2. Execute transfers with debit/credit atomicity and compensation on failure
  3. Provide payment status tracking to channels and corporate clients (gpi-style)
  4. Screen instructions against sanctions lists before release
- **Integrates with (typical backend providers):**
  - Rails: SWIFT, SEPA, ACH/NACHA, UPI (NPCI), NEFT/RTGS/IMPS, FedNow, TARGET2
  - Payment hubs: Volante, ACI Worldwide, FIS, Finastra
  - Sanctions screening: Fircosoft, LexisNexis Bridger

#### [ACH Operations](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-ach-operations)

`sd-ach-operations` · namespace `bian-operations` · gateway path `/sd-ach-operations`

BIAN **Operate** service domain operating on the **ACH Batch Operating Session** control record — the system of record for *ACH Batch* within Payments.

- **Banking type:** Payments / transaction banking
- **Typical use cases:**
  1. Accept, validate, and route ACH Batch instructions to the correct rail
  2. Execute transfers with debit/credit atomicity and compensation on failure
  3. Provide payment status tracking to channels and corporate clients (gpi-style)
  4. Screen instructions against sanctions lists before release
- **Integrates with (typical backend providers):**
  - Rails: SWIFT, SEPA, ACH/NACHA, UPI (NPCI), NEFT/RTGS/IMPS, FedNow, TARGET2
  - Payment hubs: Volante, ACI Worldwide, FIS, Finastra
  - Sanctions screening: Fircosoft, LexisNexis Bridger

#### [Bulk Payments](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-bulk-payments)

`sd-bulk-payments` · namespace `bian-operations` · gateway path `/sd-bulk-payments`

BIAN **Process** service domain operating on the **Bulk Payment File Procedure** control record — the system of record for *Bulk Payment File* within Payments.

- **Banking type:** Payments / transaction banking
- **Typical use cases:**
  1. Accept, validate, and route Bulk Payment File instructions to the correct rail
  2. Execute transfers with debit/credit atomicity and compensation on failure
  3. Provide payment status tracking to channels and corporate clients (gpi-style)
  4. Screen instructions against sanctions lists before release
- **Integrates with (typical backend providers):**
  - Rails: SWIFT, SEPA, ACH/NACHA, UPI (NPCI), NEFT/RTGS/IMPS, FedNow, TARGET2
  - Payment hubs: Volante, ACI Worldwide, FIS, Finastra
  - Sanctions screening: Fircosoft, LexisNexis Bridger

#### [Direct Debit Mandate](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-direct-debit-mandate)

`sd-direct-debit-mandate` · namespace `bian-operations` · gateway path `/sd-direct-debit-mandate`

BIAN **Manage** service domain operating on the **Direct Debit Mandate Management Plan** control record — the system of record for *Direct Debit Mandate* within Payments.

- **Banking type:** Payments / transaction banking
- **Typical use cases:**
  1. Accept, validate, and route Direct Debit Mandate instructions to the correct rail
  2. Execute transfers with debit/credit atomicity and compensation on failure
  3. Provide payment status tracking to channels and corporate clients (gpi-style)
  4. Screen instructions against sanctions lists before release
- **Integrates with (typical backend providers):**
  - Rails: SWIFT, SEPA, ACH/NACHA, UPI (NPCI), NEFT/RTGS/IMPS, FedNow, TARGET2
  - Payment hubs: Volante, ACI Worldwide, FIS, Finastra
  - Sanctions screening: Fircosoft, LexisNexis Bridger

#### [Cross Border Payment](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-cross-border-payment)

`sd-cross-border-payment` · namespace `bian-operations` · gateway path `/sd-cross-border-payment`

BIAN **Process** service domain operating on the **Cross Border Payment Procedure** control record — the system of record for *Cross Border Payment* within Payments.

- **Banking type:** Payments / transaction banking
- **Typical use cases:**
  1. Accept, validate, and route Cross Border Payment instructions to the correct rail
  2. Execute transfers with debit/credit atomicity and compensation on failure
  3. Provide payment status tracking to channels and corporate clients (gpi-style)
  4. Screen instructions against sanctions lists before release
- **Integrates with (typical backend providers):**
  - Rails: SWIFT, SEPA, ACH/NACHA, UPI (NPCI), NEFT/RTGS/IMPS, FedNow, TARGET2
  - Payment hubs: Volante, ACI Worldwide, FIS, Finastra
  - Sanctions screening: Fircosoft, LexisNexis Bridger

#### [Correspondent Bank Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-correspondent-bank-management)

`sd-correspondent-bank-management` · namespace `bian-operations` · gateway path `/sd-correspondent-bank-management`

BIAN **Manage** service domain operating on the **Correspondent Arrangement Management Plan** control record — the system of record for *Correspondent Arrangement* within Payments.

- **Banking type:** Payments / transaction banking
- **Typical use cases:**
  1. Accept, validate, and route Correspondent Arrangement instructions to the correct rail
  2. Execute transfers with debit/credit atomicity and compensation on failure
  3. Provide payment status tracking to channels and corporate clients (gpi-style)
  4. Screen instructions against sanctions lists before release
- **Integrates with (typical backend providers):**
  - Rails: SWIFT, SEPA, ACH/NACHA, UPI (NPCI), NEFT/RTGS/IMPS, FedNow, TARGET2
  - Payment hubs: Volante, ACI Worldwide, FIS, Finastra
  - Sanctions screening: Fircosoft, LexisNexis Bridger

#### [Cheque Processing](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-cheque-processing)

`sd-cheque-processing` · namespace `bian-operations` · gateway path `/sd-cheque-processing`

BIAN **Process** service domain operating on the **Cheque Transaction Procedure** control record — the system of record for *Cheque Transaction* within Payments.

- **Banking type:** Payments / transaction banking
- **Typical use cases:**
  1. Accept, validate, and route Cheque Transaction instructions to the correct rail
  2. Execute transfers with debit/credit atomicity and compensation on failure
  3. Provide payment status tracking to channels and corporate clients (gpi-style)
  4. Screen instructions against sanctions lists before release
- **Integrates with (typical backend providers):**
  - Rails: SWIFT, SEPA, ACH/NACHA, UPI (NPCI), NEFT/RTGS/IMPS, FedNow, TARGET2
  - Payment hubs: Volante, ACI Worldwide, FIS, Finastra
  - Sanctions screening: Fircosoft, LexisNexis Bridger

#### [Clearing Operations](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-clearing-operations)

`sd-clearing-operations` · namespace `bian-operations` · gateway path `/sd-clearing-operations`

BIAN **Operate** service domain operating on the **Clearing Cycle Operating Session** control record — the system of record for *Clearing Cycle* within Payments.

- **Banking type:** Payments / transaction banking
- **Typical use cases:**
  1. Accept, validate, and route Clearing Cycle instructions to the correct rail
  2. Execute transfers with debit/credit atomicity and compensation on failure
  3. Provide payment status tracking to channels and corporate clients (gpi-style)
  4. Screen instructions against sanctions lists before release
- **Integrates with (typical backend providers):**
  - Rails: SWIFT, SEPA, ACH/NACHA, UPI (NPCI), NEFT/RTGS/IMPS, FedNow, TARGET2
  - Payment hubs: Volante, ACI Worldwide, FIS, Finastra
  - Sanctions screening: Fircosoft, LexisNexis Bridger

#### [Settlement Operations](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-settlement-operations)

`sd-settlement-operations` · namespace `bian-operations` · gateway path `/sd-settlement-operations`

BIAN **Operate** service domain operating on the **Settlement Instruction Operating Session** control record — the system of record for *Settlement Instruction* within Payments.

- **Banking type:** Payments / transaction banking
- **Typical use cases:**
  1. Accept, validate, and route Settlement Instruction instructions to the correct rail
  2. Execute transfers with debit/credit atomicity and compensation on failure
  3. Provide payment status tracking to channels and corporate clients (gpi-style)
  4. Screen instructions against sanctions lists before release
- **Integrates with (typical backend providers):**
  - Rails: SWIFT, SEPA, ACH/NACHA, UPI (NPCI), NEFT/RTGS/IMPS, FedNow, TARGET2
  - Payment hubs: Volante, ACI Worldwide, FIS, Finastra
  - Sanctions screening: Fircosoft, LexisNexis Bridger


### Cards

*Cards & consumer finance.*

#### [Card Authorization](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-card-authorization)

`sd-card-authorization` · namespace `bian-operations` · gateway path `/sd-card-authorization`

BIAN **Process** service domain operating on the **Card Authorization Procedure** control record — the system of record for *Card Authorization* within Cards.

- **Banking type:** Cards & consumer finance
- **Typical use cases:**
  1. Authorize and clear Card Authorization activity within network SLAs
  2. Manage card issuance, activation, blocking, and re-issuance lifecycles
  3. Feed every authorization to fraud scoring in real time
- **Integrates with (typical backend providers):**
  - Networks: Visa, Mastercard, RuPay, Amex
  - Processors: FIS, TSYS, Fiserv, Marqeta, M2P
  - 3-D Secure & tokenization: Cardinal, MDES/VTS

#### [Card Transaction](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-card-transaction)

`sd-card-transaction` · namespace `bian-operations` · gateway path `/sd-card-transaction`

BIAN **Process** service domain operating on the **Card Transaction Procedure** control record — the system of record for *Card Transaction* within Cards.

- **Banking type:** Cards & consumer finance
- **Typical use cases:**
  1. Authorize and clear Card Transaction activity within network SLAs
  2. Manage card issuance, activation, blocking, and re-issuance lifecycles
  3. Feed every authorization to fraud scoring in real time
- **Integrates with (typical backend providers):**
  - Networks: Visa, Mastercard, RuPay, Amex
  - Processors: FIS, TSYS, Fiserv, Marqeta, M2P
  - 3-D Secure & tokenization: Cardinal, MDES/VTS

#### [Card Collections](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-card-collections)

`sd-card-collections` · namespace `bian-operations` · gateway path `/sd-card-collections`

BIAN **Process** service domain operating on the **Card Collection Case Procedure** control record — the system of record for *Card Collection Case* within Cards.

- **Banking type:** Cards & consumer finance
- **Typical use cases:**
  1. Authorize and clear Card Collection Case activity within network SLAs
  2. Manage card issuance, activation, blocking, and re-issuance lifecycles
  3. Feed every authorization to fraud scoring in real time
- **Integrates with (typical backend providers):**
  - Networks: Visa, Mastercard, RuPay, Amex
  - Processors: FIS, TSYS, Fiserv, Marqeta, M2P
  - 3-D Secure & tokenization: Cardinal, MDES/VTS

#### [Card Capture](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-card-capture)

`sd-card-capture` · namespace `bian-operations` · gateway path `/sd-card-capture`

BIAN **Process** service domain operating on the **Captured Card Procedure** control record — the system of record for *Captured Card* within Cards.

- **Banking type:** Cards & consumer finance
- **Typical use cases:**
  1. Authorize and clear Captured Card activity within network SLAs
  2. Manage card issuance, activation, blocking, and re-issuance lifecycles
  3. Feed every authorization to fraud scoring in real time
- **Integrates with (typical backend providers):**
  - Networks: Visa, Mastercard, RuPay, Amex
  - Processors: FIS, TSYS, Fiserv, Marqeta, M2P
  - 3-D Secure & tokenization: Cardinal, MDES/VTS

#### [Issued Device Administration](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-issued-device-administration)

`sd-issued-device-administration` · namespace `bian-operations` · gateway path `/sd-issued-device-administration`

BIAN **Administer** service domain operating on the **Issued Card Administrative Plan** control record — the system of record for *Issued Card* within Cards.

- **Banking type:** Cards & consumer finance
- **Typical use cases:**
  1. Authorize and clear Issued Card activity within network SLAs
  2. Manage card issuance, activation, blocking, and re-issuance lifecycles
  3. Feed every authorization to fraud scoring in real time
- **Integrates with (typical backend providers):**
  - Networks: Visa, Mastercard, RuPay, Amex
  - Processors: FIS, TSYS, Fiserv, Marqeta, M2P
  - 3-D Secure & tokenization: Cardinal, MDES/VTS

#### [Card Network Participant Services](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-card-network-participant-services)

`sd-card-network-participant-services` · namespace `bian-operations` · gateway path `/sd-card-network-participant-services`

BIAN **Operate** service domain operating on the **Card Network Membership Operating Session** control record — the system of record for *Card Network Membership* within Cards.

- **Banking type:** Cards & consumer finance
- **Typical use cases:**
  1. Authorize and clear Card Network Membership activity within network SLAs
  2. Manage card issuance, activation, blocking, and re-issuance lifecycles
  3. Feed every authorization to fraud scoring in real time
- **Integrates with (typical backend providers):**
  - Networks: Visa, Mastercard, RuPay, Amex
  - Processors: FIS, TSYS, Fiserv, Marqeta, M2P
  - 3-D Secure & tokenization: Cardinal, MDES/VTS

#### [Card Clearing](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-card-clearing)

`sd-card-clearing` · namespace `bian-operations` · gateway path `/sd-card-clearing`

BIAN **Operate** service domain operating on the **Card Clearing Cycle Operating Session** control record — the system of record for *Card Clearing Cycle* within Cards.

- **Banking type:** Cards & consumer finance
- **Typical use cases:**
  1. Authorize and clear Card Clearing Cycle activity within network SLAs
  2. Manage card issuance, activation, blocking, and re-issuance lifecycles
  3. Feed every authorization to fraud scoring in real time
- **Integrates with (typical backend providers):**
  - Networks: Visa, Mastercard, RuPay, Amex
  - Processors: FIS, TSYS, Fiserv, Marqeta, M2P
  - 3-D Secure & tokenization: Cardinal, MDES/VTS


### Loans and Deposits

*Retail & corporate credit.*

#### [Consumer Loan](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-consumer-loan)

`sd-consumer-loan` · namespace `bian-operations` · gateway path `/sd-consumer-loan`

BIAN **Fulfill** service domain operating on the **Consumer Loan Facility Fulfillment Arrangement** control record — the system of record for *Consumer Loan Facility* within Loans and Deposits.

- **Banking type:** Retail & corporate credit
- **Typical use cases:**
  1. Originate and service Consumer Loan Facility facilities from application to closure
  2. Schedule disbursements, repayments, and restructuring events
  3. Track collateral, guarantees, and covenant compliance against exposures
- **Integrates with (typical backend providers):**
  - LOS/LMS: nCino, FinnOne Neo, Pennant, Temenos
  - Bureaus & registries: CIBIL/Experian, CERSAI (collateral)
  - Valuers & insurers for collateral assets

#### [Corporate Loan](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-corporate-loan)

`sd-corporate-loan` · namespace `bian-operations` · gateway path `/sd-corporate-loan`

BIAN **Fulfill** service domain operating on the **Corporate Loan Facility Fulfillment Arrangement** control record — the system of record for *Corporate Loan Facility* within Loans and Deposits.

- **Banking type:** Retail & corporate credit
- **Typical use cases:**
  1. Originate and service Corporate Loan Facility facilities from application to closure
  2. Schedule disbursements, repayments, and restructuring events
  3. Track collateral, guarantees, and covenant compliance against exposures
- **Integrates with (typical backend providers):**
  - LOS/LMS: nCino, FinnOne Neo, Pennant, Temenos
  - Bureaus & registries: CIBIL/Experian, CERSAI (collateral)
  - Valuers & insurers for collateral assets

#### [Mortgage Loan](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-mortgage-loan)

`sd-mortgage-loan` · namespace `bian-operations` · gateway path `/sd-mortgage-loan`

BIAN **Fulfill** service domain operating on the **Mortgage Facility Fulfillment Arrangement** control record — the system of record for *Mortgage Facility* within Loans and Deposits.

- **Banking type:** Retail & corporate credit
- **Typical use cases:**
  1. Originate and service Mortgage Facility facilities from application to closure
  2. Schedule disbursements, repayments, and restructuring events
  3. Track collateral, guarantees, and covenant compliance against exposures
- **Integrates with (typical backend providers):**
  - LOS/LMS: nCino, FinnOne Neo, Pennant, Temenos
  - Bureaus & registries: CIBIL/Experian, CERSAI (collateral)
  - Valuers & insurers for collateral assets

#### [Syndicated Loan](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-syndicated-loan)

`sd-syndicated-loan` · namespace `bian-operations` · gateway path `/sd-syndicated-loan`

BIAN **Fulfill** service domain operating on the **Syndicated Loan Facility Fulfillment Arrangement** control record — the system of record for *Syndicated Loan Facility* within Loans and Deposits.

- **Banking type:** Retail & corporate credit
- **Typical use cases:**
  1. Originate and service Syndicated Loan Facility facilities from application to closure
  2. Schedule disbursements, repayments, and restructuring events
  3. Track collateral, guarantees, and covenant compliance against exposures
- **Integrates with (typical backend providers):**
  - LOS/LMS: nCino, FinnOne Neo, Pennant, Temenos
  - Bureaus & registries: CIBIL/Experian, CERSAI (collateral)
  - Valuers & insurers for collateral assets

#### [Leasing](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-leasing)

`sd-leasing` · namespace `bian-operations` · gateway path `/sd-leasing`

BIAN **Fulfill** service domain operating on the **Lease Facility Fulfillment Arrangement** control record — the system of record for *Lease Facility* within Loans and Deposits.

- **Banking type:** Retail & corporate credit
- **Typical use cases:**
  1. Originate and service Lease Facility facilities from application to closure
  2. Schedule disbursements, repayments, and restructuring events
  3. Track collateral, guarantees, and covenant compliance against exposures
- **Integrates with (typical backend providers):**
  - LOS/LMS: nCino, FinnOne Neo, Pennant, Temenos
  - Bureaus & registries: CIBIL/Experian, CERSAI (collateral)
  - Valuers & insurers for collateral assets

#### [Loan Disbursement](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-loan-disbursement)

`sd-loan-disbursement` · namespace `bian-operations` · gateway path `/sd-loan-disbursement`

BIAN **Process** service domain operating on the **Disbursement Instruction Procedure** control record — the system of record for *Disbursement Instruction* within Loans and Deposits.

- **Banking type:** Retail & corporate credit
- **Typical use cases:**
  1. Originate and service Disbursement Instruction facilities from application to closure
  2. Schedule disbursements, repayments, and restructuring events
  3. Track collateral, guarantees, and covenant compliance against exposures
- **Integrates with (typical backend providers):**
  - LOS/LMS: nCino, FinnOne Neo, Pennant, Temenos
  - Bureaus & registries: CIBIL/Experian, CERSAI (collateral)
  - Valuers & insurers for collateral assets

#### [Collateral Administration](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-collateral-administration)

`sd-collateral-administration` · namespace `bian-operations` · gateway path `/sd-collateral-administration`

BIAN **Administer** service domain operating on the **Collateral Asset Administrative Plan** control record — the system of record for *Collateral Asset* within Loans and Deposits.

- **Banking type:** Retail & corporate credit
- **Typical use cases:**
  1. Originate and service Collateral Asset facilities from application to closure
  2. Schedule disbursements, repayments, and restructuring events
  3. Track collateral, guarantees, and covenant compliance against exposures
- **Integrates with (typical backend providers):**
  - LOS/LMS: nCino, FinnOne Neo, Pennant, Temenos
  - Bureaus & registries: CIBIL/Experian, CERSAI (collateral)
  - Valuers & insurers for collateral assets

#### [Guarantee](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-guarantee)

`sd-guarantee` · namespace `bian-operations` · gateway path `/sd-guarantee`

BIAN **Fulfill** service domain operating on the **Guarantee Facility Fulfillment Arrangement** control record — the system of record for *Guarantee Facility* within Loans and Deposits.

- **Banking type:** Retail & corporate credit
- **Typical use cases:**
  1. Originate and service Guarantee Facility facilities from application to closure
  2. Schedule disbursements, repayments, and restructuring events
  3. Track collateral, guarantees, and covenant compliance against exposures
- **Integrates with (typical backend providers):**
  - LOS/LMS: nCino, FinnOne Neo, Pennant, Temenos
  - Bureaus & registries: CIBIL/Experian, CERSAI (collateral)
  - Valuers & insurers for collateral assets

#### [Letter Of Credit](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-letter-of-credit)

`sd-letter-of-credit` · namespace `bian-operations` · gateway path `/sd-letter-of-credit`

BIAN **Fulfill** service domain operating on the **Letter Of Credit Fulfillment Arrangement** control record — the system of record for *Letter Of Credit* within Loans and Deposits.

- **Banking type:** Retail & corporate credit
- **Typical use cases:**
  1. Originate and service Letter Of Credit facilities from application to closure
  2. Schedule disbursements, repayments, and restructuring events
  3. Track collateral, guarantees, and covenant compliance against exposures
- **Integrates with (typical backend providers):**
  - LOS/LMS: nCino, FinnOne Neo, Pennant, Temenos
  - Bureaus & registries: CIBIL/Experian, CERSAI (collateral)
  - Valuers & insurers for collateral assets


### Trade Banking

*Corporate banking (trade finance).*

#### [Trade Finance](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-trade-finance)

`sd-trade-finance` · namespace `bian-operations` · gateway path `/sd-trade-finance`

BIAN **Fulfill** service domain operating on the **Trade Finance Facility Fulfillment Arrangement** control record — the system of record for *Trade Finance Facility* within Trade Banking.

- **Banking type:** Corporate banking (trade finance)
- **Typical use cases:**
  1. Issue and manage Trade Finance Facility instruments through their documentary lifecycle
  2. Exchange structured trade messages with counterparty banks
  3. Track shipment/document milestones and trigger payment events
- **Integrates with (typical backend providers):**
  - SWIFT MT 7xx / ISO 20022 trade messages
  - Trade platforms: Finastra Trade Innovation, China Systems
  - e-Docs: Bolero, essDOCS; ECAs & credit insurers

#### [Documentary Collection](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-documentary-collection)

`sd-documentary-collection` · namespace `bian-operations` · gateway path `/sd-documentary-collection`

BIAN **Process** service domain operating on the **Documentary Collection Procedure** control record — the system of record for *Documentary Collection* within Trade Banking.

- **Banking type:** Corporate banking (trade finance)
- **Typical use cases:**
  1. Issue and manage Documentary Collection instruments through their documentary lifecycle
  2. Exchange structured trade messages with counterparty banks
  3. Track shipment/document milestones and trigger payment events
- **Integrates with (typical backend providers):**
  - SWIFT MT 7xx / ISO 20022 trade messages
  - Trade platforms: Finastra Trade Innovation, China Systems
  - e-Docs: Bolero, essDOCS; ECAs & credit insurers

#### [Bank Drafts](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-bank-drafts)

`sd-bank-drafts` · namespace `bian-operations` · gateway path `/sd-bank-drafts`

BIAN **Fulfill** service domain operating on the **Bank Draft Fulfillment Arrangement** control record — the system of record for *Bank Draft* within Trade Banking.

- **Banking type:** Corporate banking (trade finance)
- **Typical use cases:**
  1. Issue and manage Bank Draft instruments through their documentary lifecycle
  2. Exchange structured trade messages with counterparty banks
  3. Track shipment/document milestones and trigger payment events
- **Integrates with (typical backend providers):**
  - SWIFT MT 7xx / ISO 20022 trade messages
  - Trade platforms: Finastra Trade Innovation, China Systems
  - e-Docs: Bolero, essDOCS; ECAs & credit insurers

#### [Factoring](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-factoring)

`sd-factoring` · namespace `bian-operations` · gateway path `/sd-factoring`

BIAN **Fulfill** service domain operating on the **Factoring Facility Fulfillment Arrangement** control record — the system of record for *Factoring Facility* within Trade Banking.

- **Banking type:** Corporate banking (trade finance)
- **Typical use cases:**
  1. Issue and manage Factoring Facility instruments through their documentary lifecycle
  2. Exchange structured trade messages with counterparty banks
  3. Track shipment/document milestones and trigger payment events
- **Integrates with (typical backend providers):**
  - SWIFT MT 7xx / ISO 20022 trade messages
  - Trade platforms: Finastra Trade Innovation, China Systems
  - e-Docs: Bolero, essDOCS; ECAs & credit insurers

#### [Trade Services Customer Directory](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-trade-services-customer-directory)

`sd-trade-services-customer-directory` · namespace `bian-operations` · gateway path `/sd-trade-services-customer-directory`

BIAN **Catalog** service domain operating on the **Trade Counterparty Directory Entry** control record — the system of record for *Trade Counterparty* within Trade Banking.

- **Banking type:** Corporate banking (trade finance)
- **Typical use cases:**
  1. Issue and manage Trade Counterparty instruments through their documentary lifecycle
  2. Exchange structured trade messages with counterparty banks
  3. Track shipment/document milestones and trigger payment events
- **Integrates with (typical backend providers):**
  - SWIFT MT 7xx / ISO 20022 trade messages
  - Trade platforms: Finastra Trade Innovation, China Systems
  - e-Docs: Bolero, essDOCS; ECAs & credit insurers


### Securities

*Investment banking & wealth.*

#### [Securities Position Keeping](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-securities-position-keeping)

`sd-securities-position-keeping` · namespace `bian-operations` · gateway path `/sd-securities-position-keeping`

BIAN **Maintain** service domain operating on the **Securities Position Maintenance Agreement** control record — the system of record for *Securities Position* within Securities.

- **Banking type:** Investment banking & wealth
- **Typical use cases:**
  1. Maintain Securities Position positions and process settlements/corporate actions
  2. Service portfolios for wealth and institutional clients
  3. Reconcile holdings against custodian and CSD records daily
- **Integrates with (typical backend providers):**
  - Custodians: BNY Mellon, Citi; CSDs: NSDL/CDSL, Euroclear
  - OMS/PMS: Charles River, BlackRock Aladdin
  - Connectivity: FIX, SWIFT securities messages

#### [Custody Administration](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-custody-administration)

`sd-custody-administration` · namespace `bian-operations` · gateway path `/sd-custody-administration`

BIAN **Administer** service domain operating on the **Custody Holding Administrative Plan** control record — the system of record for *Custody Holding* within Securities.

- **Banking type:** Investment banking & wealth
- **Typical use cases:**
  1. Maintain Custody Holding positions and process settlements/corporate actions
  2. Service portfolios for wealth and institutional clients
  3. Reconcile holdings against custodian and CSD records daily
- **Integrates with (typical backend providers):**
  - Custodians: BNY Mellon, Citi; CSDs: NSDL/CDSL, Euroclear
  - OMS/PMS: Charles River, BlackRock Aladdin
  - Connectivity: FIX, SWIFT securities messages

#### [Corporate Action](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-corporate-action)

`sd-corporate-action` · namespace `bian-operations` · gateway path `/sd-corporate-action`

BIAN **Process** service domain operating on the **Corporate Action Event Procedure** control record — the system of record for *Corporate Action Event* within Securities.

- **Banking type:** Investment banking & wealth
- **Typical use cases:**
  1. Maintain Corporate Action Event positions and process settlements/corporate actions
  2. Service portfolios for wealth and institutional clients
  3. Reconcile holdings against custodian and CSD records daily
- **Integrates with (typical backend providers):**
  - Custodians: BNY Mellon, Citi; CSDs: NSDL/CDSL, Euroclear
  - OMS/PMS: Charles River, BlackRock Aladdin
  - Connectivity: FIX, SWIFT securities messages

#### [Securities Settlement](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-securities-settlement)

`sd-securities-settlement` · namespace `bian-operations` · gateway path `/sd-securities-settlement`

BIAN **Process** service domain operating on the **Securities Settlement Procedure** control record — the system of record for *Securities Settlement* within Securities.

- **Banking type:** Investment banking & wealth
- **Typical use cases:**
  1. Maintain Securities Settlement positions and process settlements/corporate actions
  2. Service portfolios for wealth and institutional clients
  3. Reconcile holdings against custodian and CSD records daily
- **Integrates with (typical backend providers):**
  - Custodians: BNY Mellon, Citi; CSDs: NSDL/CDSL, Euroclear
  - OMS/PMS: Charles River, BlackRock Aladdin
  - Connectivity: FIX, SWIFT securities messages

#### [Securities Lending](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-securities-lending)

`sd-securities-lending` · namespace `bian-operations` · gateway path `/sd-securities-lending`

BIAN **Fulfill** service domain operating on the **Securities Loan Fulfillment Arrangement** control record — the system of record for *Securities Loan* within Securities.

- **Banking type:** Investment banking & wealth
- **Typical use cases:**
  1. Maintain Securities Loan positions and process settlements/corporate actions
  2. Service portfolios for wealth and institutional clients
  3. Reconcile holdings against custodian and CSD records daily
- **Integrates with (typical backend providers):**
  - Custodians: BNY Mellon, Citi; CSDs: NSDL/CDSL, Euroclear
  - OMS/PMS: Charles River, BlackRock Aladdin
  - Connectivity: FIX, SWIFT securities messages

#### [Trade Order Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-trade-order-management)

`sd-trade-order-management` · namespace `bian-operations` · gateway path `/sd-trade-order-management`

BIAN **Manage** service domain operating on the **Trade Order Management Plan** control record — the system of record for *Trade Order* within Securities.

- **Banking type:** Investment banking & wealth
- **Typical use cases:**
  1. Maintain Trade Order positions and process settlements/corporate actions
  2. Service portfolios for wealth and institutional clients
  3. Reconcile holdings against custodian and CSD records daily
- **Integrates with (typical backend providers):**
  - Custodians: BNY Mellon, Citi; CSDs: NSDL/CDSL, Euroclear
  - OMS/PMS: Charles River, BlackRock Aladdin
  - Connectivity: FIX, SWIFT securities messages

#### [Investment Portfolio Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-investment-portfolio-management)

`sd-investment-portfolio-management` · namespace `bian-operations` · gateway path `/sd-investment-portfolio-management`

BIAN **Manage** service domain operating on the **Investment Portfolio Management Plan** control record — the system of record for *Investment Portfolio* within Securities.

- **Banking type:** Investment banking & wealth
- **Typical use cases:**
  1. Maintain Investment Portfolio positions and process settlements/corporate actions
  2. Service portfolios for wealth and institutional clients
  3. Reconcile holdings against custodian and CSD records daily
- **Integrates with (typical backend providers):**
  - Custodians: BNY Mellon, Citi; CSDs: NSDL/CDSL, Euroclear
  - OMS/PMS: Charles River, BlackRock Aladdin
  - Connectivity: FIX, SWIFT securities messages

#### [Investment Portfolio Analysis](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-investment-portfolio-analysis)

`sd-investment-portfolio-analysis` · namespace `bian-operations` · gateway path `/sd-investment-portfolio-analysis`

BIAN **Analyze** service domain operating on the **Portfolio Analysis Analysis** control record — the system of record for *Portfolio Analysis* within Securities.

- **Banking type:** Investment banking & wealth
- **Typical use cases:**
  1. Maintain Portfolio Analysis positions and process settlements/corporate actions
  2. Service portfolios for wealth and institutional clients
  3. Reconcile holdings against custodian and CSD records daily
- **Integrates with (typical backend providers):**
  - Custodians: BNY Mellon, Citi; CSDs: NSDL/CDSL, Euroclear
  - OMS/PMS: Charles River, BlackRock Aladdin
  - Connectivity: FIX, SWIFT securities messages

#### [Brokered Product](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-brokered-product)

`sd-brokered-product` · namespace `bian-operations` · gateway path `/sd-brokered-product`

BIAN **Fulfill** service domain operating on the **Brokered Product Facility Fulfillment Arrangement** control record — the system of record for *Brokered Product Facility* within Securities.

- **Banking type:** Investment banking & wealth
- **Typical use cases:**
  1. Maintain Brokered Product Facility positions and process settlements/corporate actions
  2. Service portfolios for wealth and institutional clients
  3. Reconcile holdings against custodian and CSD records daily
- **Integrates with (typical backend providers):**
  - Custodians: BNY Mellon, Citi; CSDs: NSDL/CDSL, Euroclear
  - OMS/PMS: Charles River, BlackRock Aladdin
  - Connectivity: FIX, SWIFT securities messages


### Markets and Treasury

*Treasury & financial markets.*

#### [Financial Instrument Valuation](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-financial-instrument-valuation)

`sd-financial-instrument-valuation` · namespace `bian-operations` · gateway path `/sd-financial-instrument-valuation`

BIAN **Analyze** service domain operating on the **Instrument Valuation Analysis** control record — the system of record for *Instrument Valuation* within Markets and Treasury.

- **Banking type:** Treasury & financial markets
- **Typical use cases:**
  1. Manage Instrument Valuation books with intraday position and P&L visibility
  2. Execute funding, FX, and hedging workflows under limit controls
  3. Feed risk engines and regulatory trade repositories
- **Integrates with (typical backend providers):**
  - Trading & risk: Murex, Calypso, FIS Quantum
  - Venues & clearing: CLS, LCH, CCIL; Bloomberg/Refinitiv data

#### [Quote Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-quote-management)

`sd-quote-management` · namespace `bian-operations` · gateway path `/sd-quote-management`

BIAN **Manage** service domain operating on the **Market Quote Management Plan** control record — the system of record for *Market Quote* within Markets and Treasury.

- **Banking type:** Treasury & financial markets
- **Typical use cases:**
  1. Manage Market Quote books with intraday position and P&L visibility
  2. Execute funding, FX, and hedging workflows under limit controls
  3. Feed risk engines and regulatory trade repositories
- **Integrates with (typical backend providers):**
  - Trading & risk: Murex, Calypso, FIS Quantum
  - Venues & clearing: CLS, LCH, CCIL; Bloomberg/Refinitiv data

#### [Trading Book Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-trading-book-management)

`sd-trading-book-management` · namespace `bian-operations` · gateway path `/sd-trading-book-management`

BIAN **Manage** service domain operating on the **Trading Book Management Plan** control record — the system of record for *Trading Book* within Markets and Treasury.

- **Banking type:** Treasury & financial markets
- **Typical use cases:**
  1. Manage Trading Book books with intraday position and P&L visibility
  2. Execute funding, FX, and hedging workflows under limit controls
  3. Feed risk engines and regulatory trade repositories
- **Integrates with (typical backend providers):**
  - Trading & risk: Murex, Calypso, FIS Quantum
  - Venues & clearing: CLS, LCH, CCIL; Bloomberg/Refinitiv data

#### [Position Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-position-management)

`sd-position-management` · namespace `bian-operations` · gateway path `/sd-position-management`

BIAN **Manage** service domain operating on the **Market Position Management Plan** control record — the system of record for *Market Position* within Markets and Treasury.

- **Banking type:** Treasury & financial markets
- **Typical use cases:**
  1. Manage Market Position books with intraday position and P&L visibility
  2. Execute funding, FX, and hedging workflows under limit controls
  3. Feed risk engines and regulatory trade repositories
- **Integrates with (typical backend providers):**
  - Trading & risk: Murex, Calypso, FIS Quantum
  - Venues & clearing: CLS, LCH, CCIL; Bloomberg/Refinitiv data

#### [Currency Position Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-currency-position-management)

`sd-currency-position-management` · namespace `bian-operations` · gateway path `/sd-currency-position-management`

BIAN **Manage** service domain operating on the **Currency Position Management Plan** control record — the system of record for *Currency Position* within Markets and Treasury.

- **Banking type:** Treasury & financial markets
- **Typical use cases:**
  1. Manage Currency Position books with intraday position and P&L visibility
  2. Execute funding, FX, and hedging workflows under limit controls
  3. Feed risk engines and regulatory trade repositories
- **Integrates with (typical backend providers):**
  - Trading & risk: Murex, Calypso, FIS Quantum
  - Venues & clearing: CLS, LCH, CCIL; Bloomberg/Refinitiv data

#### [Treasury Position Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-treasury-position-management)

`sd-treasury-position-management` · namespace `bian-operations` · gateway path `/sd-treasury-position-management`

BIAN **Manage** service domain operating on the **Treasury Position Management Plan** control record — the system of record for *Treasury Position* within Markets and Treasury.

- **Banking type:** Treasury & financial markets
- **Typical use cases:**
  1. Manage Treasury Position books with intraday position and P&L visibility
  2. Execute funding, FX, and hedging workflows under limit controls
  3. Feed risk engines and regulatory trade repositories
- **Integrates with (typical backend providers):**
  - Trading & risk: Murex, Calypso, FIS Quantum
  - Venues & clearing: CLS, LCH, CCIL; Bloomberg/Refinitiv data

#### [Asset Securitization](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-asset-securitization)

`sd-asset-securitization` · namespace `bian-operations` · gateway path `/sd-asset-securitization`

BIAN **Process** service domain operating on the **Securitization Pool Procedure** control record — the system of record for *Securitization Pool* within Markets and Treasury.

- **Banking type:** Treasury & financial markets
- **Typical use cases:**
  1. Manage Securitization Pool books with intraday position and P&L visibility
  2. Execute funding, FX, and hedging workflows under limit controls
  3. Feed risk engines and regulatory trade repositories
- **Integrates with (typical backend providers):**
  - Trading & risk: Murex, Calypso, FIS Quantum
  - Venues & clearing: CLS, LCH, CCIL; Bloomberg/Refinitiv data


### Operations

*Universal banking back office.*

#### [Transaction Engine](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-transaction-engine)

`sd-transaction-engine` · namespace `bian-operations` · gateway path `/sd-transaction-engine`

BIAN **Operate** service domain operating on the **Transaction Ledger Operating Session** control record — the system of record for *Transaction Ledger* within Operations.

- **Banking type:** Universal banking back office
- **Typical use cases:**
  1. Process Transaction Ledger workloads reliably at end-of-day and intraday
  2. Reconcile internal ledgers against external statements and networks
  3. Surface breaks and exceptions to case management with full lineage
- **Integrates with (typical backend providers):**
  - Reconciliation: Duco, SmartStream TLM
  - Messaging: SWIFT Alliance, IBM MQ, Kafka
  - GL & sub-ledgers: SAP, Oracle

#### [Reconciliation](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-reconciliation)

`sd-reconciliation` · namespace `bian-operations` · gateway path `/sd-reconciliation`

BIAN **Process** service domain operating on the **Reconciliation Case Procedure** control record — the system of record for *Reconciliation Case* within Operations.

- **Banking type:** Universal banking back office
- **Typical use cases:**
  1. Process Reconciliation Case workloads reliably at end-of-day and intraday
  2. Reconcile internal ledgers against external statements and networks
  3. Surface breaks and exceptions to case management with full lineage
- **Integrates with (typical backend providers):**
  - Reconciliation: Duco, SmartStream TLM
  - Messaging: SWIFT Alliance, IBM MQ, Kafka
  - GL & sub-ledgers: SAP, Oracle

#### [Financial Message Gateway](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-financial-message-gateway)

`sd-financial-message-gateway` · namespace `bian-operations` · gateway path `/sd-financial-message-gateway`

BIAN **Operate** service domain operating on the **Financial Message Operating Session** control record — the system of record for *Financial Message* within Operations.

- **Banking type:** Universal banking back office
- **Typical use cases:**
  1. Process Financial Message workloads reliably at end-of-day and intraday
  2. Reconcile internal ledgers against external statements and networks
  3. Surface breaks and exceptions to case management with full lineage
- **Integrates with (typical backend providers):**
  - Reconciliation: Duco, SmartStream TLM
  - Messaging: SWIFT Alliance, IBM MQ, Kafka
  - GL & sub-ledgers: SAP, Oracle

#### [Account Reconciliation](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-account-reconciliation)

`sd-account-reconciliation` · namespace `bian-operations` · gateway path `/sd-account-reconciliation`

BIAN **Process** service domain operating on the **Account Reconciliation Procedure** control record — the system of record for *Account Reconciliation* within Operations.

- **Banking type:** Universal banking back office
- **Typical use cases:**
  1. Process Account Reconciliation workloads reliably at end-of-day and intraday
  2. Reconcile internal ledgers against external statements and networks
  3. Surface breaks and exceptions to case management with full lineage
- **Integrates with (typical backend providers):**
  - Reconciliation: Duco, SmartStream TLM
  - Messaging: SWIFT Alliance, IBM MQ, Kafka
  - GL & sub-ledgers: SAP, Oracle

#### [Currency Exchange](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-currency-exchange)

`sd-currency-exchange` · namespace `bian-operations` · gateway path `/sd-currency-exchange`

BIAN **Process** service domain operating on the **FX Deal Procedure** control record — the system of record for *FX Deal* within Operations.

- **Banking type:** Universal banking back office
- **Typical use cases:**
  1. Process FX Deal workloads reliably at end-of-day and intraday
  2. Reconcile internal ledgers against external statements and networks
  3. Surface breaks and exceptions to case management with full lineage
- **Integrates with (typical backend providers):**
  - Reconciliation: Duco, SmartStream TLM
  - Messaging: SWIFT Alliance, IBM MQ, Kafka
  - GL & sub-ledgers: SAP, Oracle

#### [Open Item Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-open-item-management)

`sd-open-item-management` · namespace `bian-operations` · gateway path `/sd-open-item-management`

BIAN **Manage** service domain operating on the **Open Item Management Plan** control record — the system of record for *Open Item* within Operations.

- **Banking type:** Universal banking back office
- **Typical use cases:**
  1. Process Open Item workloads reliably at end-of-day and intraday
  2. Reconcile internal ledgers against external statements and networks
  3. Surface breaks and exceptions to case management with full lineage
- **Integrates with (typical backend providers):**
  - Reconciliation: Duco, SmartStream TLM
  - Messaging: SWIFT Alliance, IBM MQ, Kafka
  - GL & sub-ledgers: SAP, Oracle


## Risk and Compliance


### Credit Risk

*Risk management (credit).*

#### [Customer Credit Rating](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-customer-credit-rating)

`sd-customer-credit-rating` · namespace `bian-risk-compliance` · gateway path `/sd-customer-credit-rating`

BIAN **Assess** service domain operating on the **Credit Rating Assessment** control record — the system of record for *Credit Rating* within Credit Risk.

- **Banking type:** Risk management (credit)
- **Typical use cases:**
  1. Assess and refresh Credit Rating scores/limits across the credit lifecycle
  2. Aggregate exposures across products for single-obligor views
  3. Feed IFRS 9 / Basel capital calculations with current risk data
- **Integrates with (typical backend providers):**
  - Models: Moody's Analytics, SAS; spreading: FIS Optimist
  - Bureaus and rating agencies; limits engines

#### [Credit Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-credit-management)

`sd-credit-management` · namespace `bian-risk-compliance` · gateway path `/sd-credit-management`

BIAN **Manage** service domain operating on the **Credit Facility Risk Management Plan** control record — the system of record for *Credit Facility Risk* within Credit Risk.

- **Banking type:** Risk management (credit)
- **Typical use cases:**
  1. Assess and refresh Credit Facility Risk scores/limits across the credit lifecycle
  2. Aggregate exposures across products for single-obligor views
  3. Feed IFRS 9 / Basel capital calculations with current risk data
- **Integrates with (typical backend providers):**
  - Models: Moody's Analytics, SAS; spreading: FIS Optimist
  - Bureaus and rating agencies; limits engines

#### [Credit Risk Models](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-credit-risk-models)

`sd-credit-risk-models` · namespace `bian-risk-compliance` · gateway path `/sd-credit-risk-models`

BIAN **Develop** service domain operating on the **Credit Risk Model Development Project** control record — the system of record for *Credit Risk Model* within Credit Risk.

- **Banking type:** Risk management (credit)
- **Typical use cases:**
  1. Assess and refresh Credit Risk Model scores/limits across the credit lifecycle
  2. Aggregate exposures across products for single-obligor views
  3. Feed IFRS 9 / Basel capital calculations with current risk data
- **Integrates with (typical backend providers):**
  - Models: Moody's Analytics, SAS; spreading: FIS Optimist
  - Bureaus and rating agencies; limits engines

#### [Collateral Asset Administration](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-collateral-asset-administration)

`sd-collateral-asset-administration` · namespace `bian-risk-compliance` · gateway path `/sd-collateral-asset-administration`

BIAN **Administer** service domain operating on the **Collateral Valuation Administrative Plan** control record — the system of record for *Collateral Valuation* within Credit Risk.

- **Banking type:** Risk management (credit)
- **Typical use cases:**
  1. Assess and refresh Collateral Valuation scores/limits across the credit lifecycle
  2. Aggregate exposures across products for single-obligor views
  3. Feed IFRS 9 / Basel capital calculations with current risk data
- **Integrates with (typical backend providers):**
  - Models: Moody's Analytics, SAS; spreading: FIS Optimist
  - Bureaus and rating agencies; limits engines

#### [Limit And Exposure Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-limit-and-exposure-management)

`sd-limit-and-exposure-management` · namespace `bian-risk-compliance` · gateway path `/sd-limit-and-exposure-management`

BIAN **Manage** service domain operating on the **Exposure Limit Management Plan** control record — the system of record for *Exposure Limit* within Credit Risk.

- **Banking type:** Risk management (credit)
- **Typical use cases:**
  1. Assess and refresh Exposure Limit scores/limits across the credit lifecycle
  2. Aggregate exposures across products for single-obligor views
  3. Feed IFRS 9 / Basel capital calculations with current risk data
- **Integrates with (typical backend providers):**
  - Models: Moody's Analytics, SAS; spreading: FIS Optimist
  - Bureaus and rating agencies; limits engines


### Market and Operational Risk

*Risk management (market, liquidity, operational).*

#### [Market Risk Models](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-market-risk-models)

`sd-market-risk-models` · namespace `bian-risk-compliance` · gateway path `/sd-market-risk-models`

BIAN **Develop** service domain operating on the **Market Risk Model Development Project** control record — the system of record for *Market Risk Model* within Market and Operational Risk.

- **Banking type:** Risk management (market, liquidity, operational)
- **Typical use cases:**
  1. Compute and monitor Market Risk Model measures against board limits
  2. Run stress scenarios and feed ICAAP/ILAAP reporting
  3. Alert treasury and risk committees on threshold breaches
- **Integrates with (typical backend providers):**
  - MSCI RiskMetrics, Murex MLC, SAS
  - ALM: QRM, FIS BancWare

#### [Operational Risk Models](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-operational-risk-models)

`sd-operational-risk-models` · namespace `bian-risk-compliance` · gateway path `/sd-operational-risk-models`

BIAN **Develop** service domain operating on the **Operational Risk Model Development Project** control record — the system of record for *Operational Risk Model* within Market and Operational Risk.

- **Banking type:** Risk management (market, liquidity, operational)
- **Typical use cases:**
  1. Compute and monitor Operational Risk Model measures against board limits
  2. Run stress scenarios and feed ICAAP/ILAAP reporting
  3. Alert treasury and risk committees on threshold breaches
- **Integrates with (typical backend providers):**
  - MSCI RiskMetrics, Murex MLC, SAS
  - ALM: QRM, FIS BancWare

#### [Liquidity Risk Models](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-liquidity-risk-models)

`sd-liquidity-risk-models` · namespace `bian-risk-compliance` · gateway path `/sd-liquidity-risk-models`

BIAN **Develop** service domain operating on the **Liquidity Risk Model Development Project** control record — the system of record for *Liquidity Risk Model* within Market and Operational Risk.

- **Banking type:** Risk management (market, liquidity, operational)
- **Typical use cases:**
  1. Compute and monitor Liquidity Risk Model measures against board limits
  2. Run stress scenarios and feed ICAAP/ILAAP reporting
  3. Alert treasury and risk committees on threshold breaches
- **Integrates with (typical backend providers):**
  - MSCI RiskMetrics, Murex MLC, SAS
  - ALM: QRM, FIS BancWare

#### [Liquidity Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-liquidity-management)

`sd-liquidity-management` · namespace `bian-risk-compliance` · gateway path `/sd-liquidity-management`

BIAN **Manage** service domain operating on the **Liquidity Position Management Plan** control record — the system of record for *Liquidity Position* within Market and Operational Risk.

- **Banking type:** Risk management (market, liquidity, operational)
- **Typical use cases:**
  1. Compute and monitor Liquidity Position measures against board limits
  2. Run stress scenarios and feed ICAAP/ILAAP reporting
  3. Alert treasury and risk committees on threshold breaches
- **Integrates with (typical backend providers):**
  - MSCI RiskMetrics, Murex MLC, SAS
  - ALM: QRM, FIS BancWare

#### [Asset Liability Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-asset-liability-management)

`sd-asset-liability-management` · namespace `bian-risk-compliance` · gateway path `/sd-asset-liability-management`

BIAN **Manage** service domain operating on the **ALM Position Management Plan** control record — the system of record for *ALM Position* within Market and Operational Risk.

- **Banking type:** Risk management (market, liquidity, operational)
- **Typical use cases:**
  1. Compute and monitor ALM Position measures against board limits
  2. Run stress scenarios and feed ICAAP/ILAAP reporting
  3. Alert treasury and risk committees on threshold breaches
- **Integrates with (typical backend providers):**
  - MSCI RiskMetrics, Murex MLC, SAS
  - ALM: QRM, FIS BancWare


### Financial Crime

*Compliance / financial crime prevention.*

#### [Fraud Detection](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-fraud-detection)

`sd-fraud-detection` · namespace `bian-risk-compliance` · gateway path `/sd-fraud-detection`

BIAN **Monitor** service domain operating on the **Fraud Alert Monitoring State** control record — the system of record for *Fraud Alert* within Financial Crime.

- **Banking type:** Compliance / financial crime prevention
- **Typical use cases:**
  1. Detect suspicious Fraud Alert patterns in real time and raise scored alerts
  2. Run KYC/CDD checks at onboarding and on trigger events
  3. Manage investigations end-to-end with audit-grade decision trails
  4. File STRs/SARs to the FIU with supporting evidence
- **Integrates with (typical backend providers):**
  - AML & monitoring: NICE Actimize, SAS AML, Oracle FCCM
  - Screening: Refinitiv World-Check, Dow Jones; device intel: BioCatch
  - Case management platforms

#### [Fraud Diagnosis](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-fraud-diagnosis)

`sd-fraud-diagnosis` · namespace `bian-risk-compliance` · gateway path `/sd-fraud-diagnosis`

BIAN **Assess** service domain operating on the **Fraud Case Assessment** control record — the system of record for *Fraud Case* within Financial Crime.

- **Banking type:** Compliance / financial crime prevention
- **Typical use cases:**
  1. Detect suspicious Fraud Case patterns in real time and raise scored alerts
  2. Run KYC/CDD checks at onboarding and on trigger events
  3. Manage investigations end-to-end with audit-grade decision trails
  4. File STRs/SARs to the FIU with supporting evidence
- **Integrates with (typical backend providers):**
  - AML & monitoring: NICE Actimize, SAS AML, Oracle FCCM
  - Screening: Refinitiv World-Check, Dow Jones; device intel: BioCatch
  - Case management platforms

#### [Fraud Resolution](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-fraud-resolution)

`sd-fraud-resolution` · namespace `bian-risk-compliance` · gateway path `/sd-fraud-resolution`

BIAN **Process** service domain operating on the **Fraud Resolution Procedure** control record — the system of record for *Fraud Resolution* within Financial Crime.

- **Banking type:** Compliance / financial crime prevention
- **Typical use cases:**
  1. Detect suspicious Fraud Resolution patterns in real time and raise scored alerts
  2. Run KYC/CDD checks at onboarding and on trigger events
  3. Manage investigations end-to-end with audit-grade decision trails
  4. File STRs/SARs to the FIU with supporting evidence
- **Integrates with (typical backend providers):**
  - AML & monitoring: NICE Actimize, SAS AML, Oracle FCCM
  - Screening: Refinitiv World-Check, Dow Jones; device intel: BioCatch
  - Case management platforms

#### [Financial Crime Models](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-financial-crime-models)

`sd-financial-crime-models` · namespace `bian-risk-compliance` · gateway path `/sd-financial-crime-models`

BIAN **Develop** service domain operating on the **Financial Crime Model Development Project** control record — the system of record for *Financial Crime Model* within Financial Crime.

- **Banking type:** Compliance / financial crime prevention
- **Typical use cases:**
  1. Detect suspicious Financial Crime Model patterns in real time and raise scored alerts
  2. Run KYC/CDD checks at onboarding and on trigger events
  3. Manage investigations end-to-end with audit-grade decision trails
  4. File STRs/SARs to the FIU with supporting evidence
- **Integrates with (typical backend providers):**
  - AML & monitoring: NICE Actimize, SAS AML, Oracle FCCM
  - Screening: Refinitiv World-Check, Dow Jones; device intel: BioCatch
  - Case management platforms

#### [Know Your Customer](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-know-your-customer)

`sd-know-your-customer` · namespace `bian-risk-compliance` · gateway path `/sd-know-your-customer`

BIAN **Process** service domain operating on the **KYC Assessment Procedure** control record — the system of record for *KYC Assessment* within Financial Crime.

- **Banking type:** Compliance / financial crime prevention
- **Typical use cases:**
  1. Detect suspicious KYC Assessment patterns in real time and raise scored alerts
  2. Run KYC/CDD checks at onboarding and on trigger events
  3. Manage investigations end-to-end with audit-grade decision trails
  4. File STRs/SARs to the FIU with supporting evidence
- **Integrates with (typical backend providers):**
  - AML & monitoring: NICE Actimize, SAS AML, Oracle FCCM
  - Screening: Refinitiv World-Check, Dow Jones; device intel: BioCatch
  - Case management platforms

#### [Anti Money Laundering](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-anti-money-laundering)

`sd-anti-money-laundering` · namespace `bian-risk-compliance` · gateway path `/sd-anti-money-laundering`

BIAN **Monitor** service domain operating on the **AML Alert Monitoring State** control record — the system of record for *AML Alert* within Financial Crime.

- **Banking type:** Compliance / financial crime prevention
- **Typical use cases:**
  1. Detect suspicious AML Alert patterns in real time and raise scored alerts
  2. Run KYC/CDD checks at onboarding and on trigger events
  3. Manage investigations end-to-end with audit-grade decision trails
  4. File STRs/SARs to the FIU with supporting evidence
- **Integrates with (typical backend providers):**
  - AML & monitoring: NICE Actimize, SAS AML, Oracle FCCM
  - Screening: Refinitiv World-Check, Dow Jones; device intel: BioCatch
  - Case management platforms

#### [Case Management Financial Crime](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-case-management-financial-crime)

`sd-case-management-financial-crime` · namespace `bian-risk-compliance` · gateway path `/sd-case-management-financial-crime`

BIAN **Manage** service domain operating on the **Financial Crime Case Management Plan** control record — the system of record for *Financial Crime Case* within Financial Crime.

- **Banking type:** Compliance / financial crime prevention
- **Typical use cases:**
  1. Detect suspicious Financial Crime Case patterns in real time and raise scored alerts
  2. Run KYC/CDD checks at onboarding and on trigger events
  3. Manage investigations end-to-end with audit-grade decision trails
  4. File STRs/SARs to the FIU with supporting evidence
- **Integrates with (typical backend providers):**
  - AML & monitoring: NICE Actimize, SAS AML, Oracle FCCM
  - Screening: Refinitiv World-Check, Dow Jones; device intel: BioCatch
  - Case management platforms


### Compliance

*Regulatory compliance & audit.*

#### [Regulatory Compliance](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-regulatory-compliance)

`sd-regulatory-compliance` · namespace `bian-risk-compliance` · gateway path `/sd-regulatory-compliance`

BIAN **Manage** service domain operating on the **Compliance Requirement Management Plan** control record — the system of record for *Compliance Requirement* within Compliance.

- **Banking type:** Regulatory compliance & audit
- **Typical use cases:**
  1. Track Compliance Requirement obligations and evidence their fulfilment
  2. Produce and submit regulator-ready reports on schedule
  3. Support internal/external audits with complete records retrieval
- **Integrates with (typical backend providers):**
  - GRC: RSA Archer, MetricStream
  - Reg reporting: AxiomSL, Wolters Kluwer OneSumX, Vermeg
  - Records: OpenText, Veritas

#### [Regulatory Reporting](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-regulatory-reporting)

`sd-regulatory-reporting` · namespace `bian-risk-compliance` · gateway path `/sd-regulatory-reporting`

BIAN **Process** service domain operating on the **Regulatory Report Procedure** control record — the system of record for *Regulatory Report* within Compliance.

- **Banking type:** Regulatory compliance & audit
- **Typical use cases:**
  1. Track Regulatory Report obligations and evidence their fulfilment
  2. Produce and submit regulator-ready reports on schedule
  3. Support internal/external audits with complete records retrieval
- **Integrates with (typical backend providers):**
  - GRC: RSA Archer, MetricStream
  - Reg reporting: AxiomSL, Wolters Kluwer OneSumX, Vermeg
  - Records: OpenText, Veritas

#### [Guideline Compliance](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-guideline-compliance)

`sd-guideline-compliance` · namespace `bian-risk-compliance` · gateway path `/sd-guideline-compliance`

BIAN **Monitor** service domain operating on the **Compliance Check Monitoring State** control record — the system of record for *Compliance Check* within Compliance.

- **Banking type:** Regulatory compliance & audit
- **Typical use cases:**
  1. Track Compliance Check obligations and evidence their fulfilment
  2. Produce and submit regulator-ready reports on schedule
  3. Support internal/external audits with complete records retrieval
- **Integrates with (typical backend providers):**
  - GRC: RSA Archer, MetricStream
  - Reg reporting: AxiomSL, Wolters Kluwer OneSumX, Vermeg
  - Records: OpenText, Veritas

#### [Information Security](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-information-security)

`sd-information-security` · namespace `bian-risk-compliance` · gateway path `/sd-information-security`

BIAN **Administer** service domain operating on the **Security Policy Administrative Plan** control record — the system of record for *Security Policy* within Compliance.

- **Banking type:** Regulatory compliance & audit
- **Typical use cases:**
  1. Track Security Policy obligations and evidence their fulfilment
  2. Produce and submit regulator-ready reports on schedule
  3. Support internal/external audits with complete records retrieval
- **Integrates with (typical backend providers):**
  - GRC: RSA Archer, MetricStream
  - Reg reporting: AxiomSL, Wolters Kluwer OneSumX, Vermeg
  - Records: OpenText, Veritas

#### [Internal Audit](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-internal-audit)

`sd-internal-audit` · namespace `bian-risk-compliance` · gateway path `/sd-internal-audit`

BIAN **Assess** service domain operating on the **Audit Engagement Assessment** control record — the system of record for *Audit Engagement* within Compliance.

- **Banking type:** Regulatory compliance & audit
- **Typical use cases:**
  1. Track Audit Engagement obligations and evidence their fulfilment
  2. Produce and submit regulator-ready reports on schedule
  3. Support internal/external audits with complete records retrieval
- **Integrates with (typical backend providers):**
  - GRC: RSA Archer, MetricStream
  - Reg reporting: AxiomSL, Wolters Kluwer OneSumX, Vermeg
  - Records: OpenText, Veritas

#### [Records Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-records-management)

`sd-records-management` · namespace `bian-risk-compliance` · gateway path `/sd-records-management`

BIAN **Maintain** service domain operating on the **Record Archive Maintenance Agreement** control record — the system of record for *Record Archive* within Compliance.

- **Banking type:** Regulatory compliance & audit
- **Typical use cases:**
  1. Track Record Archive obligations and evidence their fulfilment
  2. Produce and submit regulator-ready reports on schedule
  3. Support internal/external audits with complete records retrieval
- **Integrates with (typical backend providers):**
  - GRC: RSA Archer, MetricStream
  - Reg reporting: AxiomSL, Wolters Kluwer OneSumX, Vermeg
  - Records: OpenText, Veritas

#### [Continuity Planning](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-continuity-planning)

`sd-continuity-planning` · namespace `bian-risk-compliance` · gateway path `/sd-continuity-planning`

BIAN **Plan** service domain operating on the **Continuity Plan Plan** control record — the system of record for *Continuity Plan* within Compliance.

- **Banking type:** Regulatory compliance & audit
- **Typical use cases:**
  1. Track Continuity Plan obligations and evidence their fulfilment
  2. Produce and submit regulator-ready reports on schedule
  3. Support internal/external audits with complete records retrieval
- **Integrates with (typical backend providers):**
  - GRC: RSA Archer, MetricStream
  - Reg reporting: AxiomSL, Wolters Kluwer OneSumX, Vermeg
  - Records: OpenText, Veritas


## Business Support


### Finance

*Enterprise finance (the bank's own books).*

#### [Financial Control](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-financial-control)

`sd-financial-control` · namespace `bian-business-support` · gateway path `/sd-financial-control`

BIAN **Manage** service domain operating on the **Financial Control Record Management Plan** control record — the system of record for *Financial Control Record* within Finance.

- **Banking type:** Enterprise finance (the bank's own books)
- **Typical use cases:**
  1. Operate Financial Control Record processes for the bank's own financial management
  2. Consolidate entity results and produce statutory statements
  3. Plan capital and funding against regulatory ratios
- **Integrates with (typical backend providers):**
  - ERP: SAP S/4HANA, Oracle Financials
  - Close & disclosure: Workiva, BlackLine; tax: Vertex

#### [Financial Statements](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-financial-statements)

`sd-financial-statements` · namespace `bian-business-support` · gateway path `/sd-financial-statements`

BIAN **Process** service domain operating on the **Financial Statement Procedure** control record — the system of record for *Financial Statement* within Finance.

- **Banking type:** Enterprise finance (the bank's own books)
- **Typical use cases:**
  1. Operate Financial Statement processes for the bank's own financial management
  2. Consolidate entity results and produce statutory statements
  3. Plan capital and funding against regulatory ratios
- **Integrates with (typical backend providers):**
  - ERP: SAP S/4HANA, Oracle Financials
  - Close & disclosure: Workiva, BlackLine; tax: Vertex

#### [Management Accounting](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-management-accounting)

`sd-management-accounting` · namespace `bian-business-support` · gateway path `/sd-management-accounting`

BIAN **Process** service domain operating on the **Management Account Procedure** control record — the system of record for *Management Account* within Finance.

- **Banking type:** Enterprise finance (the bank's own books)
- **Typical use cases:**
  1. Operate Management Account processes for the bank's own financial management
  2. Consolidate entity results and produce statutory statements
  3. Plan capital and funding against regulatory ratios
- **Integrates with (typical backend providers):**
  - ERP: SAP S/4HANA, Oracle Financials
  - Close & disclosure: Workiva, BlackLine; tax: Vertex

#### [Corporate Treasury](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-corporate-treasury)

`sd-corporate-treasury` · namespace `bian-business-support` · gateway path `/sd-corporate-treasury`

BIAN **Manage** service domain operating on the **Treasury Plan Management Plan** control record — the system of record for *Treasury Plan* within Finance.

- **Banking type:** Enterprise finance (the bank's own books)
- **Typical use cases:**
  1. Operate Treasury Plan processes for the bank's own financial management
  2. Consolidate entity results and produce statutory statements
  3. Plan capital and funding against regulatory ratios
- **Integrates with (typical backend providers):**
  - ERP: SAP S/4HANA, Oracle Financials
  - Close & disclosure: Workiva, BlackLine; tax: Vertex

#### [Capital Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-capital-management)

`sd-capital-management` · namespace `bian-business-support` · gateway path `/sd-capital-management`

BIAN **Manage** service domain operating on the **Capital Plan Management Plan** control record — the system of record for *Capital Plan* within Finance.

- **Banking type:** Enterprise finance (the bank's own books)
- **Typical use cases:**
  1. Operate Capital Plan processes for the bank's own financial management
  2. Consolidate entity results and produce statutory statements
  3. Plan capital and funding against regulatory ratios
- **Integrates with (typical backend providers):**
  - ERP: SAP S/4HANA, Oracle Financials
  - Close & disclosure: Workiva, BlackLine; tax: Vertex

#### [Tax Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-tax-management)

`sd-tax-management` · namespace `bian-business-support` · gateway path `/sd-tax-management`

BIAN **Process** service domain operating on the **Corporate Tax Record Procedure** control record — the system of record for *Corporate Tax Record* within Finance.

- **Banking type:** Enterprise finance (the bank's own books)
- **Typical use cases:**
  1. Operate Corporate Tax Record processes for the bank's own financial management
  2. Consolidate entity results and produce statutory statements
  3. Plan capital and funding against regulatory ratios
- **Integrates with (typical backend providers):**
  - ERP: SAP S/4HANA, Oracle Financials
  - Close & disclosure: Workiva, BlackLine; tax: Vertex


### Human Resources

*Enterprise (people operations).*

#### [Employee Data Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-employee-data-management)

`sd-employee-data-management` · namespace `bian-business-support` · gateway path `/sd-employee-data-management`

BIAN **Maintain** service domain operating on the **Employee Record Maintenance Agreement** control record — the system of record for *Employee Record* within Human Resources.

- **Banking type:** Enterprise (people operations)
- **Typical use cases:**
  1. Manage Employee Record records through hire-to-retire events
  2. Run payroll/benefits cycles with finance integration
  3. Track certifications and role-based training compliance (critical in regulated banking)
- **Integrates with (typical backend providers):**
  - HCM: Workday, SAP SuccessFactors
  - Payroll: ADP; learning: Cornerstone, Degreed

#### [Employee Assignment](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-employee-assignment)

`sd-employee-assignment` · namespace `bian-business-support` · gateway path `/sd-employee-assignment`

BIAN **Manage** service domain operating on the **Employee Assignment Management Plan** control record — the system of record for *Employee Assignment* within Human Resources.

- **Banking type:** Enterprise (people operations)
- **Typical use cases:**
  1. Manage Employee Assignment records through hire-to-retire events
  2. Run payroll/benefits cycles with finance integration
  3. Track certifications and role-based training compliance (critical in regulated banking)
- **Integrates with (typical backend providers):**
  - HCM: Workday, SAP SuccessFactors
  - Payroll: ADP; learning: Cornerstone, Degreed

#### [Workforce Training](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-workforce-training)

`sd-workforce-training` · namespace `bian-business-support` · gateway path `/sd-workforce-training`

BIAN **Operate** service domain operating on the **Training Program Operating Session** control record — the system of record for *Training Program* within Human Resources.

- **Banking type:** Enterprise (people operations)
- **Typical use cases:**
  1. Manage Training Program records through hire-to-retire events
  2. Run payroll/benefits cycles with finance integration
  3. Track certifications and role-based training compliance (critical in regulated banking)
- **Integrates with (typical backend providers):**
  - HCM: Workday, SAP SuccessFactors
  - Payroll: ADP; learning: Cornerstone, Degreed

#### [Employee Certification](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-employee-certification)

`sd-employee-certification` · namespace `bian-business-support` · gateway path `/sd-employee-certification`

BIAN **Administer** service domain operating on the **Certification Record Administrative Plan** control record — the system of record for *Certification Record* within Human Resources.

- **Banking type:** Enterprise (people operations)
- **Typical use cases:**
  1. Manage Certification Record records through hire-to-retire events
  2. Run payroll/benefits cycles with finance integration
  3. Track certifications and role-based training compliance (critical in regulated banking)
- **Integrates with (typical backend providers):**
  - HCM: Workday, SAP SuccessFactors
  - Payroll: ADP; learning: Cornerstone, Degreed

#### [Employee Payroll](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-employee-payroll)

`sd-employee-payroll` · namespace `bian-business-support` · gateway path `/sd-employee-payroll`

BIAN **Process** service domain operating on the **Payroll Run Procedure** control record — the system of record for *Payroll Run* within Human Resources.

- **Banking type:** Enterprise (people operations)
- **Typical use cases:**
  1. Manage Payroll Run records through hire-to-retire events
  2. Run payroll/benefits cycles with finance integration
  3. Track certifications and role-based training compliance (critical in regulated banking)
- **Integrates with (typical backend providers):**
  - HCM: Workday, SAP SuccessFactors
  - Payroll: ADP; learning: Cornerstone, Degreed

#### [Employee Benefits](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-employee-benefits)

`sd-employee-benefits` · namespace `bian-business-support` · gateway path `/sd-employee-benefits`

BIAN **Administer** service domain operating on the **Benefit Enrollment Administrative Plan** control record — the system of record for *Benefit Enrollment* within Human Resources.

- **Banking type:** Enterprise (people operations)
- **Typical use cases:**
  1. Manage Benefit Enrollment records through hire-to-retire events
  2. Run payroll/benefits cycles with finance integration
  3. Track certifications and role-based training compliance (critical in regulated banking)
- **Integrates with (typical backend providers):**
  - HCM: Workday, SAP SuccessFactors
  - Payroll: ADP; learning: Cornerstone, Degreed

#### [Workforce Development](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-workforce-development)

`sd-workforce-development` · namespace `bian-business-support` · gateway path `/sd-workforce-development`

BIAN **Develop** service domain operating on the **Workforce Plan Development Project** control record — the system of record for *Workforce Plan* within Human Resources.

- **Banking type:** Enterprise (people operations)
- **Typical use cases:**
  1. Manage Workforce Plan records through hire-to-retire events
  2. Run payroll/benefits cycles with finance integration
  3. Track certifications and role-based training compliance (critical in regulated banking)
- **Integrates with (typical backend providers):**
  - HCM: Workday, SAP SuccessFactors
  - Payroll: ADP; learning: Cornerstone, Degreed


### Corporate Services

*Enterprise (facilities, legal, procurement, documents).*

#### [Building Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-building-management)

`sd-building-management` · namespace `bian-business-support` · gateway path `/sd-building-management`

BIAN **Operate** service domain operating on the **Facility Operating Session** control record — the system of record for *Facility* within Corporate Services.

- **Banking type:** Enterprise (facilities, legal, procurement, documents)
- **Typical use cases:**
  1. Administer Facility services for the organization
  2. Maintain compliant document/records lifecycles with retention rules
  3. Run procurement and vendor management with spend controls
- **Integrates with (typical backend providers):**
  - DMS: OpenText, SharePoint, iManage (legal)
  - Procurement: SAP Ariba, Coupa; IWMS: Archibus

#### [Corporate Insurance](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-corporate-insurance)

`sd-corporate-insurance` · namespace `bian-business-support` · gateway path `/sd-corporate-insurance`

BIAN **Administer** service domain operating on the **Insurance Policy Administrative Plan** control record — the system of record for *Insurance Policy* within Corporate Services.

- **Banking type:** Enterprise (facilities, legal, procurement, documents)
- **Typical use cases:**
  1. Administer Insurance Policy services for the organization
  2. Maintain compliant document/records lifecycles with retention rules
  3. Run procurement and vendor management with spend controls
- **Integrates with (typical backend providers):**
  - DMS: OpenText, SharePoint, iManage (legal)
  - Procurement: SAP Ariba, Coupa; IWMS: Archibus

#### [Corporate Relationship](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-corporate-relationship)

`sd-corporate-relationship` · namespace `bian-business-support` · gateway path `/sd-corporate-relationship`

BIAN **Manage** service domain operating on the **Corporate Relationship Management Plan** control record — the system of record for *Corporate Relationship* within Corporate Services.

- **Banking type:** Enterprise (facilities, legal, procurement, documents)
- **Typical use cases:**
  1. Administer Corporate Relationship services for the organization
  2. Maintain compliant document/records lifecycles with retention rules
  3. Run procurement and vendor management with spend controls
- **Integrates with (typical backend providers):**
  - DMS: OpenText, SharePoint, iManage (legal)
  - Procurement: SAP Ariba, Coupa; IWMS: Archibus

#### [Corporate Communications](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-corporate-communications)

`sd-corporate-communications` · namespace `bian-business-support` · gateway path `/sd-corporate-communications`

BIAN **Operate** service domain operating on the **Communication Campaign Operating Session** control record — the system of record for *Communication Campaign* within Corporate Services.

- **Banking type:** Enterprise (facilities, legal, procurement, documents)
- **Typical use cases:**
  1. Administer Communication Campaign services for the organization
  2. Maintain compliant document/records lifecycles with retention rules
  3. Run procurement and vendor management with spend controls
- **Integrates with (typical backend providers):**
  - DMS: OpenText, SharePoint, iManage (legal)
  - Procurement: SAP Ariba, Coupa; IWMS: Archibus

#### [Procurement](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-procurement)

`sd-procurement` · namespace `bian-business-support` · gateway path `/sd-procurement`

BIAN **Process** service domain operating on the **Purchase Order Procedure** control record — the system of record for *Purchase Order* within Corporate Services.

- **Banking type:** Enterprise (facilities, legal, procurement, documents)
- **Typical use cases:**
  1. Administer Purchase Order services for the organization
  2. Maintain compliant document/records lifecycles with retention rules
  3. Run procurement and vendor management with spend controls
- **Integrates with (typical backend providers):**
  - DMS: OpenText, SharePoint, iManage (legal)
  - Procurement: SAP Ariba, Coupa; IWMS: Archibus

#### [Document Management](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-document-management)

`sd-document-management` · namespace `bian-business-support` · gateway path `/sd-document-management`

BIAN **Maintain** service domain operating on the **Document Maintenance Agreement** control record — the system of record for *Document* within Corporate Services.

- **Banking type:** Enterprise (facilities, legal, procurement, documents)
- **Typical use cases:**
  1. Administer Document services for the organization
  2. Maintain compliant document/records lifecycles with retention rules
  3. Run procurement and vendor management with spend controls
- **Integrates with (typical backend providers):**
  - DMS: OpenText, SharePoint, iManage (legal)
  - Procurement: SAP Ariba, Coupa; IWMS: Archibus

#### [Archive Services](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-archive-services)

`sd-archive-services` · namespace `bian-business-support` · gateway path `/sd-archive-services`

BIAN **Maintain** service domain operating on the **Archive Item Maintenance Agreement** control record — the system of record for *Archive Item* within Corporate Services.

- **Banking type:** Enterprise (facilities, legal, procurement, documents)
- **Typical use cases:**
  1. Administer Archive Item services for the organization
  2. Maintain compliant document/records lifecycles with retention rules
  3. Run procurement and vendor management with spend controls
- **Integrates with (typical backend providers):**
  - DMS: OpenText, SharePoint, iManage (legal)
  - Procurement: SAP Ariba, Coupa; IWMS: Archibus

#### [Knowledge Exchange](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-knowledge-exchange)

`sd-knowledge-exchange` · namespace `bian-business-support` · gateway path `/sd-knowledge-exchange`

BIAN **Operate** service domain operating on the **Knowledge Article Operating Session** control record — the system of record for *Knowledge Article* within Corporate Services.

- **Banking type:** Enterprise (facilities, legal, procurement, documents)
- **Typical use cases:**
  1. Administer Knowledge Article services for the organization
  2. Maintain compliant document/records lifecycles with retention rules
  3. Run procurement and vendor management with spend controls
- **Integrates with (typical backend providers):**
  - DMS: OpenText, SharePoint, iManage (legal)
  - Procurement: SAP Ariba, Coupa; IWMS: Archibus

#### [Legal Services](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-legal-services)

`sd-legal-services` · namespace `bian-business-support` · gateway path `/sd-legal-services`

BIAN **Provide Advice** service domain operating on the **Legal Matter Advisory Session** control record — the system of record for *Legal Matter* within Corporate Services.

- **Banking type:** Enterprise (facilities, legal, procurement, documents)
- **Typical use cases:**
  1. Administer Legal Matter services for the organization
  2. Maintain compliant document/records lifecycles with retention rules
  3. Run procurement and vendor management with spend controls
- **Integrates with (typical backend providers):**
  - DMS: OpenText, SharePoint, iManage (legal)
  - Procurement: SAP Ariba, Coupa; IWMS: Archibus


### Technology and Operations

*Enterprise IT operations.*

#### [Systems Administration](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-systems-administration)

`sd-systems-administration` · namespace `bian-business-support` · gateway path `/sd-systems-administration`

BIAN **Administer** service domain operating on the **System Configuration Administrative Plan** control record — the system of record for *System Configuration* within Technology and Operations.

- **Banking type:** Enterprise IT operations
- **Typical use cases:**
  1. Operate System Configuration processes for the bank's technology estate
  2. Coordinate releases/changes with audit trails (SOX-friendly)
  3. Track incidents and service health against SLOs
- **Integrates with (typical backend providers):**
  - ITSM: ServiceNow, Jira Service Management
  - Observability: Datadog, Grafana stack; CI/CD: ArgoCD, Jenkins

#### [Platform Operations](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-platform-operations)

`sd-platform-operations` · namespace `bian-business-support` · gateway path `/sd-platform-operations`

BIAN **Operate** service domain operating on the **Platform Service Operating Session** control record — the system of record for *Platform Service* within Technology and Operations.

- **Banking type:** Enterprise IT operations
- **Typical use cases:**
  1. Operate Platform Service processes for the bank's technology estate
  2. Coordinate releases/changes with audit trails (SOX-friendly)
  3. Track incidents and service health against SLOs
- **Integrates with (typical backend providers):**
  - ITSM: ServiceNow, Jira Service Management
  - Observability: Datadog, Grafana stack; CI/CD: ArgoCD, Jenkins

#### [Network Operations](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-network-operations)

`sd-network-operations` · namespace `bian-business-support` · gateway path `/sd-network-operations`

BIAN **Operate** service domain operating on the **Network Service Operating Session** control record — the system of record for *Network Service* within Technology and Operations.

- **Banking type:** Enterprise IT operations
- **Typical use cases:**
  1. Operate Network Service processes for the bank's technology estate
  2. Coordinate releases/changes with audit trails (SOX-friendly)
  3. Track incidents and service health against SLOs
- **Integrates with (typical backend providers):**
  - ITSM: ServiceNow, Jira Service Management
  - Observability: Datadog, Grafana stack; CI/CD: ArgoCD, Jenkins

#### [Software Deployment](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-software-deployment)

`sd-software-deployment` · namespace `bian-business-support` · gateway path `/sd-software-deployment`

BIAN **Process** service domain operating on the **Software Release Procedure** control record — the system of record for *Software Release* within Technology and Operations.

- **Banking type:** Enterprise IT operations
- **Typical use cases:**
  1. Operate Software Release processes for the bank's technology estate
  2. Coordinate releases/changes with audit trails (SOX-friendly)
  3. Track incidents and service health against SLOs
- **Integrates with (typical backend providers):**
  - ITSM: ServiceNow, Jira Service Management
  - Observability: Datadog, Grafana stack; CI/CD: ArgoCD, Jenkins

#### [IT Standards And Guidelines](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-it-standards-and-guidelines)

`sd-it-standards-and-guidelines` · namespace `bian-business-support` · gateway path `/sd-it-standards-and-guidelines`

BIAN **Catalog** service domain operating on the **IT Standard Directory Entry** control record — the system of record for *IT Standard* within Technology and Operations.

- **Banking type:** Enterprise IT operations
- **Typical use cases:**
  1. Operate IT Standard processes for the bank's technology estate
  2. Coordinate releases/changes with audit trails (SOX-friendly)
  3. Track incidents and service health against SLOs
- **Integrates with (typical backend providers):**
  - ITSM: ServiceNow, Jira Service Management
  - Observability: Datadog, Grafana stack; CI/CD: ArgoCD, Jenkins

#### [Site Operations](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-site-operations)

`sd-site-operations` · namespace `bian-business-support` · gateway path `/sd-site-operations`

BIAN **Operate** service domain operating on the **Site Operation Operating Session** control record — the system of record for *Site Operation* within Technology and Operations.

- **Banking type:** Enterprise IT operations
- **Typical use cases:**
  1. Operate Site Operation processes for the bank's technology estate
  2. Coordinate releases/changes with audit trails (SOX-friendly)
  3. Track incidents and service health against SLOs
- **Integrates with (typical backend providers):**
  - ITSM: ServiceNow, Jira Service Management
  - Observability: Datadog, Grafana stack; CI/CD: ArgoCD, Jenkins

#### [Service Desk](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-service-desk)

`sd-service-desk` · namespace `bian-business-support` · gateway path `/sd-service-desk`

BIAN **Operate** service domain operating on the **Service Ticket Operating Session** control record — the system of record for *Service Ticket* within Technology and Operations.

- **Banking type:** Enterprise IT operations
- **Typical use cases:**
  1. Operate Service Ticket processes for the bank's technology estate
  2. Coordinate releases/changes with audit trails (SOX-friendly)
  3. Track incidents and service health against SLOs
- **Integrates with (typical backend providers):**
  - ITSM: ServiceNow, Jira Service Management
  - Observability: Datadog, Grafana stack; CI/CD: ArgoCD, Jenkins


### Business Command and Control

*Enterprise strategy & architecture.*

#### [Enterprise Architecture](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-enterprise-architecture)

`sd-enterprise-architecture` · namespace `bian-business-support` · gateway path `/sd-enterprise-architecture`

BIAN **Design** service domain operating on the **Architecture Blueprint Design** control record — the system of record for *Architecture Blueprint* within Business Command and Control.

- **Banking type:** Enterprise strategy & architecture
- **Typical use cases:**
  1. Maintain Architecture Blueprint artifacts that steer investment and change
  2. Map business capabilities (BIAN landscape!) to systems and initiatives
  3. Monitor strategic KPIs and feed executive decision cycles
- **Integrates with (typical backend providers):**
  - EA: LeanIX, Ardoq; planning: Anaplan
  - BI: Power BI, Tableau

#### [Business Development](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-business-development)

`sd-business-development` · namespace `bian-business-support` · gateway path `/sd-business-development`

BIAN **Plan** service domain operating on the **Business Development Plan Plan** control record — the system of record for *Business Development Plan* within Business Command and Control.

- **Banking type:** Enterprise strategy & architecture
- **Typical use cases:**
  1. Maintain Business Development Plan artifacts that steer investment and change
  2. Map business capabilities (BIAN landscape!) to systems and initiatives
  3. Monitor strategic KPIs and feed executive decision cycles
- **Integrates with (typical backend providers):**
  - EA: LeanIX, Ardoq; planning: Anaplan
  - BI: Power BI, Tableau

#### [Business Risk Models](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-business-risk-models)

`sd-business-risk-models` · namespace `bian-business-support` · gateway path `/sd-business-risk-models`

BIAN **Develop** service domain operating on the **Business Risk Model Development Project** control record — the system of record for *Business Risk Model* within Business Command and Control.

- **Banking type:** Enterprise strategy & architecture
- **Typical use cases:**
  1. Maintain Business Risk Model artifacts that steer investment and change
  2. Map business capabilities (BIAN landscape!) to systems and initiatives
  3. Monitor strategic KPIs and feed executive decision cycles
- **Integrates with (typical backend providers):**
  - EA: LeanIX, Ardoq; planning: Anaplan
  - BI: Power BI, Tableau

#### [Enterprise Planning](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-enterprise-planning)

`sd-enterprise-planning` · namespace `bian-business-support` · gateway path `/sd-enterprise-planning`

BIAN **Plan** service domain operating on the **Enterprise Plan Plan** control record — the system of record for *Enterprise Plan* within Business Command and Control.

- **Banking type:** Enterprise strategy & architecture
- **Typical use cases:**
  1. Maintain Enterprise Plan artifacts that steer investment and change
  2. Map business capabilities (BIAN landscape!) to systems and initiatives
  3. Monitor strategic KPIs and feed executive decision cycles
- **Integrates with (typical backend providers):**
  - EA: LeanIX, Ardoq; planning: Anaplan
  - BI: Power BI, Tableau

#### [Corporate Strategy](https://github.com/Sreenivas-Sadhu-Prabhakara/sd-corporate-strategy)

`sd-corporate-strategy` · namespace `bian-business-support` · gateway path `/sd-corporate-strategy`

BIAN **Direct** service domain operating on the **Strategy Directive Strategy** control record — the system of record for *Strategy Directive* within Business Command and Control.

- **Banking type:** Enterprise strategy & architecture
- **Typical use cases:**
  1. Maintain Strategy Directive artifacts that steer investment and change
  2. Map business capabilities (BIAN landscape!) to systems and initiatives
  3. Monitor strategic KPIs and feed executive decision cycles
- **Integrates with (typical backend providers):**
  - EA: LeanIX, Ardoq; planning: Anaplan
  - BI: Power BI, Tableau


---

## 🕌 Islamic Banking Landscape

A **separate, fully isolated** Shariah-compliant landscape (its own catalog, template, repos, and master catalog — no code shared with this one) lives at
**[islamic-banking-platform](https://github.com/Sreenivas-Sadhu-Prabhakara/islamic-banking-platform)**.

---

*Generated from `bian-services/registry.json` by `scripts/generate-master-catalog.py` — regenerate after catalog changes. BIAN® is a registered trademark of the Banking Industry Architecture Network; this independent project models its service-landscape concepts.*
