---
name: portfolio-orchestrator
description: Central orchestrator managing state transitions, cross-agent synthesis, multi-dimensional distributions, watchlist onboarding, capital displacement, and retrospective signal audit logging.
---

# Portfolio Orchestrator & Synthesis Playbook

Acts as the central orchestration node coordinating technical, macro, fundamental, and portfolio risk analysis.

## Pipeline Sequence:
1. **Trigger Portfolio Agent**: Ingest active holdings, watchlists, cash balances, and 401(k) mutual funds.
2. **Concurrent Fan-Out**:
   - **Technical Node**: 5Y historical depth, closed-bar resampling, 33 FVB 4-zone posture, BX Trender.
   - **Macro & Yield Curve Node**: VIX, CPI, Fed Funds, $2\text{Y}/10\text{Y}/30\text{Y}$ yields, term premium slope, and equity multiples transmission.
   - **Fundamental Quant Node**: Seeking Alpha 5-Factor scoring, 5 Lifecycle Archetypes (AOTG framework), Rule of 40.
   - **Contrarian Sentiment Node**: Fear & Greed index vs implied volatility.
3. **Consolidate Multi-Dimensional Portfolio Distributions**:
   - Distribution by **Archetype** (% Profitable Hyper-Growth, % Compounders, % Land-Grab, % Mature/Cyclical, % Cash/401k).
   - Distribution by **Ticker Weight** (% of portfolio equity).
   - Distribution by **Sector & Sub-Sector** (Tech, Semis, Software, Financials, Cash).
   - Distribution by **Conviction Tier / Signal State** (% Buy/Dip Zone, % Holding, % Extended/Trim, % Broken Exit).
   - Distribution by **Account Type** (Single-Stock Equities vs 401k Funds vs Cash).
4. **Watchlist Promotion & Capital Displacement Solver**:
   - Rank top watchlist picks entering the 33 FVB discount zone.
   - If cash $< 8\%$, pair new entries with specific trimming/liquidation candidates (broken trends or overextended $>+20\%$).
5. **Signal Logging & Retrospective Audit Loop**:
   - Append new dip/rotation triggers to `brain/signals/audit_log.json`.
   - Evaluate $T+30, T+90, T+180$ lookback performance against SPY benchmark and attribute alpha outcomes.
6. **Publish Briefing & Dashboard Update**:
   - Write updated `brain/CURRENT_BRIEF.md`, `brain/signals/daily_changes.json`, `brain/signals/daily_changes.md`, and refresh `index.html` dashboard data (`brain/data.js`).

---

## 7. Mandatory Daily Chat Thread Reporting Format:
Whenever executing daily runs or summarizing portfolio intelligence in the chat thread, output the structured Executive Changes Report with the following 5 distinct sections:

1. **🌐 Economic & Rate Telemetry Shifts**:
   - Macro Regime, VIX Volatility level and day-over-day delta, Crowd Sentiment (Fear & Greed index), Headline CPI/PCE, Fed Funds Rate.
   - Treasury yield curve spectrum ($2\text{Y}$, $10\text{Y}$, $30\text{Y}$), $10\text{Y}-2\text{Y}$ spread, $30\text{Y}-10\text{Y}$ term slope, and equity multiple transmission stance.

2. **🔄 Ticker Technical Color Flips**:
   - Table of all tickers that experienced indicator color changes since prior session:
     - 33 FVB Daily color flips (`RED` ➔ `GREEN` or `GREEN` ➔ `RED`)
     - Weekly BX Trender flips (`Dark Red` ➔ `Bright Green`, `Bright Green` ➔ `Dark Green`, etc.)
     - Monthly BX Trender flips
     - Price, distance from 33 EMA, and current trade rating.

3. **🎯 Trade Rating Shifts & Genesis Entries**:
   - **🌱 GENESIS ENTRY TRIGGERED**: Prominently spotlight any ticker triggering a fresh Genesis Entry setup (fresh 33 FVB green pivot + Bright Green Monthly momentum + discount pocket $\le +4.0\%$).
   - Table/list of all trade rating upgrades / downgrades (e.g. `Wait / Trap` ➔ `Hold / Ride Trend`, `Hold` ➔ `Buy / Dip Zone`, `Take Profit / Trim`, `Structural Exit`).

4. **🔬 Fundamental Quant Scorecards**:
   - Top composite quant scores ($1.00$ to $5.00$, Letter Grade A+ to F, Wall Street consensus recommendation) and factor grades across Value, Growth, Profitability, Momentum, Revisions.

5. **⚡ Executive Conviction Highlights**:
   - 🟢 Top Buy / Discount Pocket Opportunities (with entry pocket & thesis)
   - 🎯 Take Profit & Overextended Trims ($>+8\%$ to $>+20\%$ overextension alerts)
   - ⚠️ Bull & Value Trap Alerts (falling 33 EMA / deteriorating quant)
   - 🚨 Structural Trend Exits (broken trendlines with Dark Red monthly)


