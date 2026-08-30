---
name: macro-regime-analyst
description: Ingests broad macroeconomic data (VIX, CPI/PCE, Fed Funds Rate, Yield Curves, Jobs, ISM) and classifies market environment regimes.
---

# Macro Regime Analyst Playbook

Generates weekly and daily recurring briefings analyzing the macroeconomic environment, rates structure, and sector rotation.

## 1. Key Macro Indicators:
1. **The VIX**: Implied volatility, fear gauges, and risk premia.
2. **Inflation Telemetry**: Headline & Core CPI / PCE, disinflationary trajectory.
3. **Federal Funds Rate**: Policy restrictiveness vs neutral rate ($r^*$).
4. **Labor Market Dynamics**: Unemployment rate, Sahm Rule threshold ($>4.5\%$), Non-Farm Payrolls.
5. **ISM Composite (Manufacturing + Services)**: Business activity expansion vs contraction ($50.0$ threshold).

---

## 2. Expanded Multi-Point Yield Curve Suite:
Evaluate Treasury yields across the entire maturity curve:
1. **$2\text{Y}$ Yield (`US2Y` / `^IRX`)**: Policy expectations & short-rate market discounting.
2. **$10\text{Y}$ Yield (`US10Y` / `^TNX`)**: Global benchmark discount rate; anchors equity P/E multiples.
3. **$30\text{Y}$ Yield (`US30Y` / `^TYX`)**: Long-duration inflation risk, sovereign fiscal term premium, mortgage/capex hurdle rates.
4. **$10\text{Y}-2\text{Y}$ Spread**: Primary economic cycle & recession/normalization indicator.
5. **$30\text{Y}-10\text{Y}$ Spread**: Long-end term premium steepness.
6. **Real Yield ($10\text{Y}\text{ TIPS}$)**: True cost of capital ($\text{10Y Nominal} - \text{Expected Inflation}$).

### Yield Curve Shapes & Equity Transmission Rules:
- **Bull Steepener ($2\text{Y}$ falling faster than $10\text{Y}$)**: Fed easing cycle; bullish for cyclicals, banks (NIM expansion), and oversold growth.
- **Bear Steepener ($10\text{Y}/30\text{Y}$ rising faster than $2\text{Y}$)**: Long-end term premium/inflation fears; multiple compression risk for ultra-high P/E tech; favor cash-rich compounders.
- **Bull Flattener ($10\text{Y}$ falling faster than $2\text{Y}$)**: Growth slowdown flight to safety; mega-cap quality and defensives outperform.
- **Bear Flattener ($2\text{Y}$ rising faster than $10\text{Y}$)**: Fed aggressive rate hikes; defensive capital preservation.
- **Curve Inversion ($10\text{Y}-2\text{Y} < 0\text{ bps}$)**: Recessionary leading indicator.

---

## 3. Sector & Sub-Sector Rotation Signals:
- 11 Select Sector SPDR ETFs (`XLK`, `XLF`, `XLV`, `XLY`, `XLI`, `XLC`, `XLE`, `XLP`, `XLU`, `XLRE`, `XLB`)
- Sub-Sector Growth Leadership: Software Growth (`IGV`) vs Semiconductors (`SMH`)
- Multi-period performance (1W, 1M, 3M) & Relative Strength vs SPY across Rotation Quadrants (*Leading, Improving, Weakening, Lagging*).

---

## 4. Required Markdown Output Structure:
1. **Macro Regime Classification**:
   - *Disinflationary Growth* (Resilient GDP, cooling inflation, constructive yield curve).
   - *Complacent Bull* (Suppressed VIX, high euphoria, elevated multiples).
   - *Stagflation* (High CPI $\ge 3.5\%$, decelerating ISM $< 49.0$).
   - *Risk-Off Panic* (Spiking VIX $\ge 24.0$, inverted curve, surging unemployment).
2. **Indicator Delta & Yield Curve Table**: Values, weekly deltas, threshold evaluation, and equity transmission impacts.
3. **Sector Rotation & Contrarian Directives**: Overweight / Neutral / Underweight asset allocations tied to the active macro regime.

