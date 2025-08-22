# FrontierMetrix — Context Primer

This document consolidates all essential context files for Cursor AI.  
It includes: Project Overview, Tech Stack, Data Model, Design Principles, Roadmap, and Contributing Guide.

---

## Project Overview

FrontierMetrix is a macro trading intelligence platform focused on **frontier and emerging markets**.  
It provides **real-time insights on currencies, commodities, bonds, and stablecoins**, filtered through credible sources and alerting rules.

### Mission
- Be the always-on intelligence layer for traders, allocators, and analysts in the world’s least transparent markets.  
- Core values: credibility, clarity, non-alarmist tone, transparent sourcing.

### MVP Scope
- Web app (Next.js + Firebase backend).
- Auth & onboarding.
- Data ingestion (assets, news, bond yields).
- Alerts (volatility, price moves, keyword triggers).
- User preferences (regions, signals).
- Core pages: Dashboard, Assets, Countries, Alerts, Settings.

### Style
- Professional, analytical tone.
- UX: fast, minimal, grid-based, mobile-first.
- Color scheme: neutral with data-viz highlights.

---

## Tech Stack

- **Frontend**: Next.js 15 (App Router), TypeScript, TailwindCSS, shadcn/ui, Zustand, TanStack Query, Recharts.
- **Backend**: Firebase (Firestore, Functions, Storage). Server Actions for privileged ops.
- **Auth**: NextAuth (Google + Email).
- **Analytics**: GA4 (light integration).
- **Infra**: GitHub Actions CI/CD, pnpm monorepo.
- **Testing**: Vitest, React Testing Library.
- **Other**: Feature flags, accessibility best practices.

---

## Data Model (Firestore)

### Collections

#### assets
```ts
{
  symbol: string,
  type: 'fx' | 'commodity' | 'bond' | 'stablecoin',
  name: string,
  region: string,
  lastPrice: number,
  changePct: number,
  volatility: number,
  signals: string[]
}
```

#### countries
```ts
{
  iso: string,
  name: string,
  region: string,
  riskScore: number,
  watchlist: boolean
}
```

#### news
```ts
{
  headline: string,
  source: string,
  url: string,
  publishedAt: Timestamp,
  tickers: string[],
  countryISO?: string
}
```

#### alerts
```ts
{
  userId: string,
  scope: 'asset' | 'country',
  targetId: string,
  rule: AlertRule,
  active: boolean,
  lastTriggeredAt?: Timestamp
}
```

#### userPrefs
```ts
{
  userId: string,
  regions: string[],
  signals: string[],
  watchlist: string[]
}
```

### AlertRule Types
```ts
type AlertRule =
  | { kind: 'volatilitySpike'; lookbackDays: number; thresholdPct: number }
  | { kind: 'priceMove'; direction: 'up'|'down'; pct: number; lookbackDays: number }
  | { kind: 'newsKeyword'; keywords: string[]; cooldownMins: number }
```

---

## Design Principles

- **Clarity > Complexity** — minimal interfaces, avoid data overload.
- **Comparative Context** — assets/countries shown relative to peers.
- **Trust** — cite sources (Reuters, Bloomberg, IMF, World Bank).
- **Non-alarmist** — avoid hype, present grounded analytics.
- **Responsive** — works equally on desktop and mobile.
- **Accessibility** — roles, labels, keyboard navigation.

---

## Roadmap (MVP → V2)

### Phase 1 (MVP, ~60 days)
- Core auth + prefs
- Data ingestion (FX, commodities, bonds, stablecoins)
- Dashboard with top movers & news
- Alerts: volatility, price, keywords
- Country profiles (template w/ dummy data)

### Phase 2
- Multi-perspective insights (AI + human synthesis)
- Advanced charting
- Daily digest emails
- Premium gating & billing
- News scraping pipeline

---

## Contributing

- Use pnpm for all installs.
- Commit style: Conventional Commits.
- Run `pnpm typecheck && pnpm lint && pnpm test` before PR.
- Keep code modular: prefer small composable components.
- Write zod schemas for any external data.
- Feature flags: add to `lib/flags.ts`.
- Avoid speculative features; stick to ROADMAP.md.
