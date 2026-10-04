---
name: portfolio-rebalance-strategy
description: >-
  Systematically cross-reference Notion equity planning cards, monthly rebalance
  routine notes, and live Fynn AI quantitative indicators including 33 FVB daily baseline,
  Weekly and Monthly BX Trenders, multi-year DCFs, and portfolio analytics.
  Use to generate tactical rebalancing briefings, identify high-conviction discount entry pockets,
  stage overextended froth trims, manage Roth IRA allocations, and execute concentrated position
  de-risking roadmaps.
---

# 🎯 Portfolio Rebalance & Strategy Radar Skill

This skill provides an automated protocol to inspect active **Equity Half / Quarterly strategy cards** (e.g. `$ H2-2026`, `$ H1-2027`), cross-reference **monthly rebalancing notes**, and reconcile them against **live Fynn AI quantitative telemetry**.

Use this skill to review portfolio posture, execute monthly rebalances, check entry and exit levels, manage Roth IRA allocations, or calibrate concentrated position de-risking roadmaps.

---

## 🧭 Core Directives & Data Sources

The skill operates by correlating three heterogeneous local sources:

1. **Active Half / Quarterly Strategy Card in Notion**:
   - Location: `cache/notion/cards/*.json` where `database_name == "Equity Halves/Quarterly"` or title matches `$\s*[HQ][1-4]-\d{4}`.
   - Dynamic Resolution: Automatically selects the latest chronological card based on year and period order (e.g. `$ H2-2026`, automatically switching to `$ H1-2027` as periods advance).
   - Ingests: Strategic headspace, sector rotation theses such as semiconductor to software rotation or capital equipment, single-stock targets (`AMD`, `MU`, `SNDK`), and macro inputs.

2. **Systematic Monthly Rebalance Checklist**:
   - Location: `cache/notion/cards/` with title matching `monthly rebal #fin`.
   - Ingests: Anchor versus theme tracking, high-beta noise pruning guidelines, and automated contribution routing.

3. **Fynn AI Quantitative Telemetry**:
   - Files: `cache/fynn/CURRENT_BRIEF.md` and `cache/fynn/portfolio_analytics.json`.
   - Indicators:
     - **33 FVB Baseline**: Daily 33 EMA slope (🟢 Green = Rising / 🔴 Red = Falling).
     - **BX Trenders**: Weekly & Monthly momentum (`RSI(MACD(5,20), 5) - 50`).
     - **Distance to 33 EMA**: Percentage premium or discount to baseline.
     - **Multi-Year Valuation Models**: DCF Base, Bull, and Bear CAGR targets.
     - **Account Distinction**: Isolates verified portfolio holdings from watchlists and stock picks.

---

## ⚡ The 6-Category Rebalancing Action Matrix

When executing this skill, group assets into these 6 distinct operational buckets:

### 1. 🟢 Priority Accumulation: 33 FVB Discount Pockets
- **Criteria**: Primary trend intact (33 FVB Green, Monthly BX Green) resting within **+0% to +3%** above Daily 33 EMA.
- **Current Core Focus**: Enterprise software rotation (`NOW`, `CRM`) and foundational ETFs (`SPMO`, `VOO`).
- **Guidance**: Deploy fresh dollar-cost averaging deposits or redeploy trim proceeds here. Do not chase names extended beyond +5%.

### 2. 🌾 Froth Harvesting & Staged Trims (>10% Overextensions)
- **Criteria**: Price stretched **>10% to +18%** above Daily 33 EMA with overextension warnings in Fynn.
- **Current Core Focus**: `AMD` approaching upper valuation resistance bands.
- **Guidance**: Stage GTC limit sell orders to harvest 20% to 30% into strength. Raise trailing stops to the rising 33 EMA.

### 3. 🚀 Trend Runners: Hold and Ride (Do Not Chase)
- **Criteria**: Positive momentum actively running (+5% to +9% above 33 EMA) after testing discount pockets.
- **Current Core Focus**: `META`, `MU`, `ASML`, `CAKE`, `ELF`, `SMH`, `TSM`.
- **Guidance**: Let momentum run toward multi-year DCF targets. Do not allocate fresh capital until a secondary 33 EMA test occurs.

### 4. 💼 Roth IRA Mechanical Engine (`SPMO` & `SMH` Only)
- **Vehicle Characteristics**: Roth IRA allows tax-advantaged rebalancing without incurring capital gains taxes.
- **Target Allocation**: **65% `SPMO` / 35% `SMH`** (Core momentum combined with semiconductor allocation).
- **Monthly Inflow Routing**: Direct 100% of new monthly contributions to whichever asset is inside its 33 EMA discount pocket.
- **Tolerance Rebalancing Bands**:
  - Upper Band: If `SMH` exceeds **45%** of the account, trim back to **35%** and sweep gains into `SPMO`.
  - Lower Band: If `SMH` pulls back below **25%** while monthly momentum is green, reallocate from `SPMO` back up to **35%**.
  - Risk Stop: If `SMH` closes below its Daily 33 EMA, shift allocation to **85% `SPMO` / 15% `SMH`**.

### 5. 🛡️ Concentrated Position Management (`SNDK`)
- **Concentration Context**: Concentrated single-stock position requiring disciplined, staged de-risking over time.
- **Current Posture**: Daily 33 EMA serves as the primary trailing floor.
- **The Playbook**:
  1. **Staged De-Risking Tranches**: Sell target tranches into strength during periods of price extension at long-term capital gains rates. Redeploy proceeds toward cashflow buffers, family commitments, and diversified equity dividend index allocations (`FDVV`, `SCHD`).
  2. **Tax Year Deferral**: Stage execution across tax year boundaries when appropriate to defer capital gains tax liabilities into future filing periods.
  3. **Capex Hard Stop**: If Daily 33 EMA is breached on a daily close or secular capex revisions soften, liquidate risk tranches systematically regardless of tax calendar timing.

### 6. 🛑 Structural Exits & Traps (Stand Aside)
- **Criteria**: Price broken below Daily 33 EMA with Dark Red monthly momentum.
- **Current Focus**: `AVGO`, `CELH`, `NKE`, `SOFI`.
- **Guidance**: Full exit or stand aside. Never average down into falling 33 EMA baselines until daily close confirms green.

---

## 🛠️ Automated Execution & Tooling

To run this skill deterministically via the CLI:

```bash
# Ingest latest data from Fynn and synthesize active strategy
python3 .agents/skills/portfolio-rebalance-strategy/scripts/rebalance_radar.py --sync

# Output structured markdown report
python3 .agents/skills/portfolio-rebalance-strategy/scripts/rebalance_radar.py

# Output raw JSON payload for programmatic dashboards
python3 .agents/skills/portfolio-rebalance-strategy/scripts/rebalance_radar.py --json
```

### Script Capabilities (`rebalance_radar.py`):
1. **Dynamic Period Discovery**: Parses regex `$\s*[HQ][1-4]-\d{4}` across Notion cards, sorting chronologically to find the active planning period without hardcoded file names.
2. **Table Parsing**: Extracts Fynn technical tables, 33 FVB slopes, BX Trenders, and distance percentages.
3. **Account Isolation**: Filters `portfolio_analytics.json` to verify true holdings vs watchlists, preventing false alarms.
4. **Markdown Generation**: Outputs a clean, scannable table matrix adhering strictly to Q style guidelines.
