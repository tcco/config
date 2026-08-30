---
name: technical-chart-analyst
description: Evaluates stock tickers using the 33 Fair Value Band (33 FVB EMA) and Weekly/Monthly BX Trender momentum histograms with exact trading rules.
---

# Technical Chart Analyst Playbook

Act as an expert technical analyst and quantitative developer reviewing every ticker across portfolio holdings and active watchlists.

## 1. Historical Depth & Timeframe Bar Construction:
- **Historical Data Requirement**: Fetch at least 5 years (~1,260 daily bars) of daily price history to provide adequate warmup depth for multi-timeframe EMA and MACD calculations.
- **Timeframe Resampling Rules**:
  - **All Prior Bars**: Strictly locked to their official period close (Friday weekly close, Month-end close). They never change.
  - **Current Developing Bar**: Only the latest bar is live/open, incorporating today's latest daily close without mutating historical closed bars.

## 2. Indicator Formulas & Thresholds:

### A. 33 Fair Value Band (33 FVB):
- **Formula**: 33-period Exponential Moving Average (EMA) applied to daily close.
- **Trend Slope**: Evaluated over a 5-day smoothed baseline ($\text{EMA}_t \ge \text{EMA}_{t-5}$) to prevent 1-day micro-jitter from falsely flipping trend color.
- **Distance from Band**: $\text{Distance \%} = \frac{\text{Price} - \text{EMA}_{33}}{\text{EMA}_{33}} \times 100\%$.
- **Discount Pocket**: $-3.0\%$ to $+3.5\%$ from 33 EMA.

### B. BX Trender (Multi-Timeframe Histogram):
- **Formula**:
  1. $MACD = EMA(Close, 5) - EMA(Close, 20)$
  2. $RSI\_MACD = RSI(MACD, 5)$
  3. $BX\_Value = RSI\_MACD - 50.0$
- **Color Classification**:
  - 🟢 **Bright Green**: $BX > 0$ AND rising ($\ge \text{prev}$)
  - 🌲 **Dark Green**: $BX > 0$ AND falling ($< \text{prev}$)
  - 🔴 **Increasing Light Red**: $BX < 0$ AND rising ($\ge \text{prev}$)
  - 🩸 **Dark Red**: $BX < 0$ AND falling ($< \text{prev}$)
- **Timeframe Focus**: Monthly BX dictates the primary macro trend; Weekly BX identifies swing momentum cycles.

---

## 3. Simplified 4-Zone Technical Postures & Signal Rules:

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 🟢 BUY / DIP ZONE (Action: Full Entry / Re-entry Add)                                  │
│ • Higher Trend Intact: Monthly BX is Green (Bright/Dark) or Light Red inflecting.      │
│ • 33 FVB Baseline: 33 EMA is rising over the 5-day trend window.                      │
│ • Price Position: Price inside the 33 EMA Discount Pocket (-3.0% to +3.5%).            │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 🔵 HOLDING / TREND RIDING ZONE (Action: Hold / Ride Trend)                             │
│ • Price trending constructively above 33 EMA (+3.5% to +10.0%).                        │
│ • Monthly and Weekly momentum remain positive.                                         │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 🟡 EXTENDED / TRIM ZONE (Action: Take Profit / Trim 20-30%)                            │
│ • Price stretched far above 33 EMA (> +12.0% to +20.0%+).                              │
│ • Weekly BX momentum begins decelerating; lock in gains and raise trailing stops.      │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 🔴 TREND BROKEN / EXIT ZONE (Action: Structural Exit / Stop Out)                       │
│ • Price breaks below 33 EMA AND Monthly BX turns Dark Red.                             │
│ • Trend broken; exit position to preserve capital.                                     │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ ⚠️ BULL TRAP WARNING (Action: Stand Down / Wait)                                       │
│ • Price bounce into a falling/broken 33 EMA. Stand down until 33 FVB turns green.      │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 4. Signal Audit & Lookback Tracking ($T+30, T+90, T+180$):
- Whenever a **Genesis Entry**, **Contrarian Dip Buy**, or **Sector Rotation** triggers, log an immutable snapshot to `brain/signals/audit_log.json`.
- Evaluate at $T+30$, $T+90$, and $T+180$ days against SPY benchmark:
  - 🟢 **Validated Alpha Hit**: Absolute Return $\ge +12\%$ and Outperformed SPY by $\ge +6\%$.
  - 🔵 **Constructive Win**: Absolute Return $> 0\%$ and Alpha between $-2\%$ and $+6\%$.
  - ⚠️ **Market Drag**: Absolute Loss, but matched or beat dropping benchmark.
  - 🔴 **False Breakout / Trap**: Loss $> -8\%$ and Underperformed SPY by $> -6\%$.

## 5. Required Markdown Output Schema:
| Ticker | Current Price | Genesis Entry (Date / Price) | Position State & P&L | Closed Position Details | 33 FVB (Daily) | Weekly BX | Monthly BX | Distance to 33 EMA (%) | Current Trade Rating / Action | Tactical Management Guidance |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
