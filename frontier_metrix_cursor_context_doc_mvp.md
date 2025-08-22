# FrontierMetrix — Cursor Context (MVP)

> **Purpose**: Give Cursor the shared context it needs to generate consistent, production‑grade code for the FrontierMetrix MVP. This doc defines the **scope, architecture, conventions, schemas, acceptance criteria, and task templates** aligned with our phased backlog.

---

## 0) One‑liner & Principles

- **One‑liner**: *FrontierMetrix is the always‑on intelligence layer for traders and allocators in the world’s least transparent markets — built for speed, credibility, and context.*
- **Non‑negotiables**
  - Reputable sources only (FT, Reuters, Bloomberg for MVP).
  - Transparent signal math (z‑scores, rolling windows) and traceable provenance (source IDs).
  - Fast UI (P95 < 2s) and resilient pipelines (idempotent, observable).
  - Quiet, non‑alarmist tone; data > drama.

---

## 1) MVP Scope (Phased)

**Phase 1 – Foundation & Infra**

- Firestore schema & indexes
- Cloud Functions (schedulers, pipelines)
- Caching layer
- Logging/Monitoring/Alerts
- Auth & Signup, User Preferences

**Phase 2 – Data Ingestion & Processing**

- Market data connectors (FX, Commodities, Bonds, Stablecoins)
- Source whitelist filter
- Headlines & institutional reports scraper
- Earnings/transcript ingestion
- Country seed data
- Auto‑tagging, Event categorization
- Volatility & signal detection
- Historical performance calculator

**Phase 3 – UI Components & Viz**

- Asset card, Interactive charts, Country profile, News/Insights feed, Word cloud

**Phase 4 – Alerts**

- Data‑driven (σ‑threshold) alerts, Event‑driven alerts, Alert preferences UI

**Phase 5 – Insight Layer**

- Multi‑perspective synthesis, Free vs Premium gate

**Phase 6 – QA & Testing**

- Ingestion unit tests, E2E alert test, Load test

> CSV with detailed issues/criteria has been prepared separately. Keep all work items aligned with those acceptance criteria.

---

## 2) Tech Stack & Project Layout

**Runtime**

- **Backend**: Firebase Cloud Functions (Node.js 20) + Firestore (Native mode)
- **Web**: Next.js 14 (App Router) + React 18 + TypeScript (Server Actions optional)
- **Styles**: TailwindCSS + shadcn/ui
- **Charts**: Recharts (time series) or lightweight custom canvas; prefer SSR‑friendly components
- **Jobs**: Cloud Scheduler → HTTPS triggers for idempotent functions
- **Auth**: Firebase Auth (Email/Password + Google)
- **Testing**: Vitest/Jest for TS, Playwright for E2E, Locust/k6 for load
- **Obs**: OpenTelemetry + structured logs (json) shipped to Cloud Logging

**Monorepo layout** (proposed):

```
frontiermetrix/
  apps/
    web/                # Next.js app
  packages/
    ui/                 # shared components (shadcn, cards)
    utils/              # shared TS utils (date, math, fetch)
  services/
    functions/          # Firebase Functions (TS)
    pipelines/          # data scripts, backfills, evals
  infra/
    firebase/           # firestore.rules, indexes.json, storage.rules
    github/             # CI/CD workflows
  docs/                 # ADRs, this context doc
```

**NPM scripts (top‑level)**

```
"dev:web": "turbo run dev --filter=web",
"dev:functions": "cd services/functions && firebase emulators:start",
"lint": "turbo run lint",
"test": "turbo run test",
"typecheck": "turbo run typecheck",
"build": "turbo run build"
```

---

## 3) Firestore Data Model (MVP)

> Keep documents **small, immutable where possible**, and **index‑friendly**.

### Collections

- `assets/{assetId}`
  - `class`: "fx" | "commodity" | "bond" | "stablecoin"
  - `symbol`, `name`, `countryId?`
  - `meta`: provider, currency, decimals
- `prices/{assetId}/bars/{ts}`
  - `o,h,l,c,v, tf` (tf: "1m"|"5m"|"1h"|"1d")
  - `src`, `ingestedAt`
- `events/{eventId}`
  - `type`: "news" | "report" | "fed" | "geo" | "weather" | "mortality"
  - `title`, `publishedAt`, `src`, `url`, `summary`, `countryIds[]`, `companyIds[]`, `topics[]`, `confidence`
  - `primaryCategory`, `subTags[]`
- `insights/{insightId}`
  - `assetId?`, `countryId?`, `zScore?`, `window?`, `summaryAI`, `analystNote?`, `sources[]`
  - `createdAt`, `createdBy`: "ai"|uid
- `countries/{countryId}`
  - `name`, `iso2`, `fxSymbol`, `yield10ySymbol`, `latest`: { `cpi`, `gdp`, `policyRate`, `yield10y`, `fx` }
- `users/{uid}`
  - `role`, `createdAt`, `plan`: "free"|"premium"
- `prefs/{uid}`
  - `regions[]`, `assets[]`, `signals`: { `zMin`: number, `quietHours`: {start,end} }
- `alerts/{uid}/subscriptions/{subId}`
  - `type`: "sigma"|"category",
  - `params`: {assetIds?, zMin?, categories?}

### Indexes (indexes.json)

- Composite: `events` by (`primaryCategory` ASC, `publishedAt` DESC)
- Composite: `insights` by (`assetId` ASC, `createdAt` DESC)
- Composite: `prices.bars` by (`assetId` ASC, `tf` ASC, `ts` DESC) — or partition via subcollection

### Security (firestore.rules) — MVP sketch

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isSignedIn() { return request.auth != null; }
    match /users/{uid} {
      allow read, write: if isSignedIn() && request.auth.uid == uid;
    }
    match /prefs/{uid} {
      allow read, write: if isSignedIn() && request.auth.uid == uid;
    }
    match /insights/{id} {
      allow read: if true; // public read for MVP
      allow write: if isSignedIn() && request.auth.token.admin == true; // curated only
    }
    match /events/{id} {
      allow read: if true;
      allow write: if false; // write via functions only
    }
    match /assets/{id} {
      allow read: if true;
    }
  }
}
```

---

## 4) Functions & Pipelines (Templates)

**HTTP Function Skeleton (TypeScript)**

```ts
// services/functions/src/http/ingestMarket.ts
import * as functions from "firebase-functions/v2";
import { onRequest } from "firebase-functions/v2/https";
import { z } from "zod";
import { upsertBars } from "../lib/prices";

const Schema = z.object({ assetId: z.string(), tf: z.enum(["1m","5m","1h","1d"]) });

export const ingestMarket = onRequest({ cors: true, region: "us-central1" }, async (req, res) => {
  const parsed = Schema.safeParse(req.query);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.flatten() });
  const { assetId, tf } = parsed.data;
  const bars = await fetchProviderBars(assetId, tf); // TODO
  await upsertBars(assetId, tf, bars);
  return res.json({ ok: true, count: bars.length });
});
```

**Scheduled Function (Idempotent)**

```ts
// services/functions/src/schedule/sigmaScan.ts
import { onSchedule } from "firebase-functions/v2/scheduler";
import { scanZScores } from "../lib/signals";

export const sigmaScan = onSchedule({ schedule: "every 5 minutes", region: "us-central1" }, async () => {
  await scanZScores({ windows: [20, 60], thresholds: [2, 3] });
});
```

**Signals Library (Deterministic)**

```ts
// services/functions/src/lib/signals.ts
export function zScore(series: number[]) {
  const n = series.length; if (n === 0) return 0;
  const mean = series.reduce((a,b)=>a+b,0)/n;
  const sd = Math.sqrt(series.reduce((a,x)=>a + Math.pow(x-mean,2),0)/n) || 1;
  return (series[n-1]-mean)/sd;
}
```

**Event Categorization (Hybrid)**

```ts
// simple rule-first map; ML hook later
export function categorize(e: { title: string, body?: string }): { primary: string, subTags: string[] } {
  const t = (e.title + " " + (e.body||"")) .toLowerCase();
  if (/(fomc|rate decision|fed)/.test(t)) return { primary: "fed", subTags: ["rates"] };
  if (/(sanction|border|election|coup)/.test(t)) return { primary: "geopolitics", subTags: [] };
  if (/(hurricane|flood|drought)/.test(t)) return { primary: "weather", subTags: [] };
  return { primary: "news", subTags: [] };
}
```

---

## 5) Source Policy (Whitelist)

- Define `ALLOWED_SOURCES = ["Financial Times","Reuters","Bloomberg"]` (env or Firestore `config/sources`) for MVP.
- Any `events` doc with `src` not in whitelist is **rejected** (or stored in `quarantine/{id}` with `reason`).

---

## 6) Caching Strategy

- **In‑memory** (per function instance) for hot API responses with TTL 60–120s.
- **Edge** (Next.js) for SSR pages: `revalidateTag("asset:EURUSD:1h")` after price writes.
- **Cache busting** events on writes to `prices` and `events`.

---

## 7) UI Contracts (Typed)

**AssetCardProps**

```ts
export type AssetCardProps = {
  assetId: string;
  symbol: string;
  name: string;
  last: number; changePct: number;
  spark: number[]; // last N closes
  updatedAt: string; // ISO
  events?: { id:string; title:string; primaryCategory:string; publishedAt:string }[];
};
```

**Feed Query**

- Inputs: `category?`, `sources[]?`, `countryIds[]?`, `q?`, `limit`, `cursor?`
- Output: `items[]` with stable cursors; include `readState` per user.

---

## 8) Acceptance Criteria & Performance Budgets

- **Web**: P95 route TTFB < 800ms (SSR); client LCP < 2.0s on mid‑tier laptop.
- **Functions**: P95 < 3s for provider calls; scheduler drift < 60s.
- **Data Quality**: Auto‑tagging ≥90% precision / ≥85% recall on eval set (n≥200).
- **Alerts**: Trigger → push < 10s P95; cooldown dedupe: ≥5 min per asset.

---

## 9) Environment & Secrets

- `.env` (local) and Firebase config for production

```
PROVIDER_X_API_KEY=...
ALLOWED_SOURCES="Financial Times,Reuters,Bloomberg"
SIGMA_WINDOWS="20,60"
SIGMA_THRESHOLDS="2,3"
NEXT_PUBLIC_ENV="dev|prod"
```

- Cursor should **never** print real secrets in code. Use `process.env.*` with zod validation.

**Config loader**

```ts
import { z } from 'zod';
const Env = z.object({
  PROVIDER_X_API_KEY: z.string(),
  ALLOWED_SOURCES: z.string().transform(s=>s.split(',').map(x=>x.trim())),
  SIGMA_WINDOWS: z.string().transform(s=>s.split(',').map(n=>+n)),
  SIGMA_THRESHOLDS: z.string().transform(s=>s.split(',').map(n=>+n)),
});
export const env = Env.parse(process.env);
```

---

## 10) Coding Standards

- **TypeScript**: strict mode on; no `any`; functional utilities over classes.
- **API**: zod validate every boundary (HTTP/request, Firestore write).
- **Errors**: never swallow; add `code` and `cause` to Error; log with correlationId.
- **Testing**: write a test with every module; mock providers; golden JSON samples.
- **Docs**: co‑locate `README.md` in each package with run/test instructions.

**ESLint/Prettier baseline**

```jsonc
{
  "extends": ["next/core-web-vitals","turbo","prettier"],
  "rules": {
    "@typescript-eslint/consistent-type-imports": "error",
    "no-restricted-syntax": ["error", {"selector": "TSEnumDeclaration", "message": "Use const objects"}]
  }
}
```

---

## 11) Cursor Task Prompts (Examples)

**Scaffold an idempotent scheduled function**

```
Create a Firebase scheduled function `sigmaScan` in services/functions that:
- reads latest 60 closes per tracked asset (1h tf),
- computes z-score on [20,60] windows,
- writes `insights` docs when |z| >= 2 with {assetId, window, zScore, sources:["prices"]},
- is idempotent for the same hour. Include unit tests for `zScore()`.
```

**Build an AssetCard component**

```
In packages/ui, implement <AssetCard /> with props in section 7.
- Tailwind, shadcn Card
- show symbol, last price, % change (green/red), sparkline (mini canvas), updatedAt, and a popover with last 5 events.
- add story in Storybook and unit tests for render.
```

**Implement source whitelist**

```
Add a guard in services/functions/lib/events.ts that rejects events where src ∉ ALLOWED_SOURCES. If rejected, write to /quarantine with reason.
Add tests for allow/deny.
```

---

## 12) CI/CD

- **PR checks**: typecheck, lint, unit tests, build web, build functions dry‑run.
- **Deploy**: `main` → staging Firebase project; tag `v*` → production.
- **Smoke**: after deploy, run synthetic GET `/health` and sample queries.

GitHub Actions outline:

```
- uses: actions/setup-node@v4
- run: corepack enable && pnpm i
- run: pnpm -r typecheck && pnpm -r lint && pnpm -r test && pnpm -r build
```

---

## 13) UX Notes (MVP)

- Default view: **Watchlist** (top assets per class), **Latest Events**, **Recent Insights**.
- Filters are sticky (URL/search params); remember per user in `prefs`.
- Provide **Export CSV/PNG** on charts; no clutter.

---

## 14) Definitions of Done (DoD) — Apply to Every Ticket

- Code merged with tests and types; acceptance criteria met (binary).
- Telemetry added (logs/metrics) and dashboards updated if applicable.
- Docs updated (README, ADR if architectural decision).
- Feature flags or config toggles in place.

---

## 15) Open Questions (Cursor should not assume; ask)

- Final front‑end framework is **Next.js** (confirm). If SwiftUI app is added, create a sibling `apps/ios` and keep API contracts identical.
- Provider choices for **FX/commodities/bonds** (mock until keys added).
- Exact **premium quota (N insights/day)** for paywall.

---

## 16) Quick Start (Local)

```
# Web
pnpm i && pnpm dev:web

# Functions
(cd services/functions && pnpm i && firebase emulators:start)

# Seed minimal data
node services/pipelines/seed/seedCountries.mjs
node services/pipelines/seed/seedAssets.mjs
```

---

*End of Cursor Context.*

output as document

