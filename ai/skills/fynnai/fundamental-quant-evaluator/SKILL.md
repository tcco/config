---
name: fundamental-quant-evaluator
description: Generates earnings report cards, Seeking Alpha 5-Factor Quant scores (A+ to F), 5 Lifecycle Archetype classifications (AOTG framework), and 3-Year Base/Bull/Bear price projections with annual CAGR.
---

# Fundamental Quant Evaluator Playbook

## 1. Stock Lifecycle Archetype Classification (AOTG Framework):
Classify each asset into one of 5 fundamental archetypes:
1. 🚀 **Profitable Hyper-Growth (AOTG Tier)**:
   - **Criteria**: Revenue YoY $\ge 25\%$, $\text{Rule of 40} \ge 50\%$, Net Margin $\ge 18\%$, FCF Conversion $\ge 80\%$.
   - **Valuation Lens**: Rule of 40 Adjusted EV/Sales, Forward PEG, Cash Flow Compounding.
   - **Examples**: `NVDA`, `PLTR`, `NOW`, `SNDK`, `ASML`.
2. 🛡️ **Core Compounders (Mega-Cap Quality)**:
   - **Criteria**: Revenue YoY $10\% - 22\%$, Net Margin $\ge 22\%$, ROIC $\ge 20\%$, Share Buybacks.
   - **Valuation Lens**: Normalized P/E, FCF Yield vs 10Y Treasury, ROIC.
   - **Examples**: `GOOG`, `AMZN`, `META`, `V`, `AAPL`.
3. ⚡ **Land-Grab Hyper-Growth (Pre-Profit)**:
   - **Criteria**: Revenue YoY $\ge 30\%$, Net Margin $< 10\%$, Gross Margin $\ge 65\%$.
   - **Valuation Lens**: EV/Gross Profit, Net Revenue Retention (NRR).
4. 🚜 **Mature Cash Cows & Cyclicals**:
   - **Criteria**: Revenue YoY $0\% - 10\%$, High Dividend/Buyback, Macro-sensitive.
   - **Valuation Lens**: Low P/E ($< 18\text{x}$), EV/EBITDA, FCF Yield ($> 6\%$).
5. 🔄 **Turnaround / Special Situations**:
   - **Criteria**: Temporary margin compression, negative revisions bottoming/inflecting.
   - **Valuation Lens**: Normalized Peak/Trough Earnings Power.

---

## 2. Seeking Alpha-Style 5-Factor Quant Score:
Evaluate the stock across five core quantitative factors:
- **Valuation**: P/E, EV/EBITDA, P/S, FCF Yield vs sector.
- **Growth**: Revenue YoY, 3-Yr Revenue CAGR, EPS Forward Growth.
- **Profitability**: Gross Margin, Operating Margin, Net Margin, ROE, ROCE.
- **Momentum**: 3-Month, 6-Month, 12-Month relative strength vs S&P 500.
- **EPS Revisions**: Upward vs Downward analyst revisions over last 90 days.
- **Composite Score**: Assign letter grade (A+ to F) and numeric value (1.00 to 5.00).

---

## 3. Archetype-Aware 3-Year & 5-Year Price Projections & Annual CAGR:
Model multi-year targets across three scenarios:
- **Profitable Hyper-Growth**: Dynamic exit P/E ($35\text{x} - 55\text{x}$) proportional to Rule of 40 score ($\text{Rev Growth \%} + \text{FCF Margin \%}$).
- **Compounders**: PEG-anchored target multiples ($1.4\text{x} - 1.8\text{x}$).
- **Mature/Value**: Mean-reverting historical P/E with FCF yield floor.
- Output Year 1, Year 3, and Year 5 target prices with fixed annualized CAGR.

