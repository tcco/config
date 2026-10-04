#!/usr/bin/env python3
"""
Rebalance Radar & Strategy Synthesizer
-------------------------------------
Dynamically correlates:
1. Current Notion Half / Quarterly Strategy card (e.g. "$ H2-2026", "$ H1-2027").
2. Notion Monthly Rebalance Checklist ("monthly rebal #fin").
3. Live Fynn AI quantitative indicators, 33 FVB technical signals, and portfolio analytics.

Outputs a unified executive rebalancing briefing and action matrix.
"""

import os
import sys
import json
import glob
import re
import argparse
from datetime import datetime

Q_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../../"))
if not os.path.exists(os.path.join(Q_ROOT, "cache")):
    # Fallback to current working directory if run from Q_ROOT
    Q_ROOT = os.getcwd()

CACHE_DIR = os.path.join(Q_ROOT, "cache")
NOTION_CARDS_DIR = os.path.join(CACHE_DIR, "notion", "cards")
FYNN_BRIEF_PATH = os.path.join(CACHE_DIR, "fynn", "CURRENT_BRIEF.md")
FYNN_ANALYTICS_PATH = os.path.join(CACHE_DIR, "fynn", "portfolio_analytics.json")


def parse_period_tuple(title):
    """
    Parse a title like '$ H2-2026' or '$ Q1-2027' into a sortable tuple (year, order).
    Order: Q1=1.0, Q2=2.0, H1=2.5, Q3=3.0, Q4=4.0, H2=4.5.
    """
    m = re.search(r"\$\s*([HQ])([1-4])-(\d{4})", title)
    if not m:
        return (0, 0.0)
    type_code = m.group(1).upper()
    num = int(m.group(2))
    year = int(m.group(3))
    
    if type_code == "H":
        order = 2.5 if num == 1 else 4.5
    else:
        order = float(num)
        
    return (year, order)


def find_latest_strategy_card():
    """Find the most recent Equity Half/Quarter card in Notion cache."""
    if not os.path.exists(NOTION_CARDS_DIR):
        return None

    card_files = glob.glob(os.path.join(NOTION_CARDS_DIR, "*.json"))
    candidates = []

    for file_path in card_files:
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                card = json.load(f)
            title = card.get("title", "")
            dbname = card.get("database_name", "")
            if dbname == "Equity Halves/Quarterly" or re.search(r"\$\s*[HQ][1-4]-\d{4}", title):
                period = parse_period_tuple(title)
                if period != (0, 0.0):
                    candidates.append((period, card, file_path))
        except Exception:
            continue

    if not candidates:
        return None

    candidates.sort(key=lambda x: x[0], reverse=True)
    return candidates[0]


def find_monthly_rebal_card():
    """Find the monthly rebalance checklist card in Notion cache."""
    if not os.path.exists(NOTION_CARDS_DIR):
        return None

    card_files = glob.glob(os.path.join(NOTION_CARDS_DIR, "*.json"))
    candidates = []

    for file_path in card_files:
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                card = json.load(f)
            title = card.get("title", "")
            if "monthly rebal" in title.lower():
                edited_time = card.get("last_edited_time", "")
                candidates.append((edited_time, card, file_path))
        except Exception:
            continue

    if not candidates:
        return None

    candidates.sort(key=lambda x: x[0], reverse=True)
    return candidates[0]


def parse_fynn_technical_table(brief_path):
    """Parse Asset Technicals & Signals table from CURRENT_BRIEF.md."""
    if not os.path.exists(brief_path):
        return {}

    with open(brief_path, "r", encoding="utf-8") as f:
        content = f.read()

    tickers_data = {}
    
    # Locate Section 4: Asset Technicals & Signals
    sec4_match = re.search(r"## 4\.\s*📈 Asset Technicals & Signals(.*?)(## 5\.|\Z)", content, re.DOTALL)
    if not sec4_match:
        return {}

    table_text = sec4_match.group(1)
    lines = [line.strip() for line in table_text.splitlines() if line.strip().startswith("|")]

    for line in lines:
        cols = [c.strip() for c in line.split("|")]
        if len(cols) < 12:
            continue
        ticker_raw = cols[1]
        m = re.search(r"\*\*([$A-Za-z0-9\-_]+)\*\*", ticker_raw)
        if not m:
            continue
        ticker = m.group(1).replace("$", "")
        
        category = "Watchlist"
        if "(Holding)" in ticker_raw:
            category = "Holding"
        elif "(Stock Picks)" in ticker_raw:
            category = "Stock Picks"
        elif "(Stock Watch)" in ticker_raw:
            category = "Stock Watch"

        price_str = cols[2].replace("$", "").replace(",", "")
        try:
            price = float(price_str)
        except ValueError:
            price = 0.0

        fvb_str = cols[6]
        weekly_bx_str = cols[7]
        monthly_bx_str = cols[8]
        dist_str = cols[9]
        rating_str = cols[10]
        guidance_str = cols[11]

        tickers_data[ticker] = {
            "ticker": ticker,
            "category": category,
            "price": price,
            "fvb": fvb_str,
            "weekly_bx": weekly_bx_str,
            "monthly_bx": monthly_bx_str,
            "distance": dist_str,
            "rating": rating_str,
            "guidance": guidance_str,
        }

    return tickers_data


def get_actual_holdings(analytics_path):
    """Extract holdings category and allocation weights from portfolio_analytics.json."""
    if not os.path.exists(analytics_path):
        return {}

    try:
        with open(analytics_path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except Exception:
        return {}

    holdings = {}
    for h in data.get("holdings", []):
        if h.get("category") == "Holding":
            sym = h.get("ticker")
            holdings[sym] = {
                "ticker": sym,
                "current_price": h.get("current_price", 0),
                "weight_pct": h.get("weight_pct", 0),
                "institution": h.get("portfolios", [{}])[0].get("institution", "Unknown") if h.get("portfolios") else "Unknown",
            }
    return holdings


def parse_macro_brief(brief_path):
    """Extract Macro Regime & Indicators from CURRENT_BRIEF.md."""
    if not os.path.exists(brief_path):
        return {}

    with open(brief_path, "r", encoding="utf-8") as f:
        text = f.read()

    macro_data = {
        "date": "Unknown",
        "regime": "Disinflationary Growth",
        "vix": "N/A",
        "allocation_signal": "ACCUMULATE / DIVERSIFY",
    }

    date_m = re.search(r"\*\*Date:\*\*\s*([0-9\-]+)", text)
    if date_m:
        macro_data["date"] = date_m.group(1)

    regime_m = re.search(r"\*\*Regime:\*\*\s*([A-Za-z\s]+)", text)
    if regime_m:
        macro_data["regime"] = regime_m.group(1).strip()

    vix_m = re.search(r"\*\*VIX:\*\*\s*([0-9\.]+)", text)
    if vix_m:
        macro_data["vix"] = vix_m.group(1)

    alloc_m = re.search(r"\*\*Capital Allocation Signal:\*\*\s*\*\*([^*]+)\*\*", text)
    if alloc_m:
        macro_data["allocation_signal"] = alloc_m.group(1).strip()

    return macro_data


def generate_synthesis(strategy_card_info, monthly_card_info, fynn_signals, actual_holdings, macro_info):
    """Generate the structured rebalancing synthesis."""
    period_tuple, strat_card, strat_path = strategy_card_info
    monthly_card = monthly_card_info[1] if monthly_card_info else {}

    strat_title = strat_card.get("title", "Active Strategy")
    strat_body = strat_card.get("body_markdown", "")
    
    # Identify key thematic tickers mentioned in the current strategy card
    focus_tickers = [
        "SNDK", "AMD", "MU", "META", "NOW", "CRM", "ASML", 
        "CAKE", "ELF", "SPMO", "SMH", "AVGO", "CELH", "NKE"
    ]
    
    categories = {
        "buy_dip_zone": [],
        "take_profit": [],
        "trend_runner": [],
        "full_exit": [],
        "wait_trap": [],
        "other": []
    }

    for sym in focus_tickers:
        sig = fynn_signals.get(sym)
        if not sig:
            continue
        rating = sig.get("rating", "").lower()
        if "buy" in rating or "dip" in rating:
            categories["buy_dip_zone"].append(sig)
        elif "profit" in rating or "froth" in rating:
            categories["take_profit"].append(sig)
        elif "trend" in rating or "runner" in rating or "hold" in rating:
            categories["trend_runner"].append(sig)
        elif "exit" in rating:
            categories["full_exit"].append(sig)
        elif "trap" in rating or "wait" in rating:
            categories["wait_trap"].append(sig)
        else:
            categories["other"].append(sig)

    return {
        "strategy_period": strat_title,
        "strategy_updated": strat_card.get("last_edited_time", ""),
        "monthly_rebal_status": monthly_card.get("status", "Unknown"),
        "macro": macro_info,
        "categories": categories,
        "actual_holdings": actual_holdings,
        "focus_tickers": focus_tickers,
    }


def format_markdown_report(report_data):
    """Format synthesized report into clean GitHub markdown."""
    macro = report_data["macro"]
    cats = report_data["categories"]
    holdings = report_data["actual_holdings"]

    lines = []
    lines.append("# 🎯 Portfolio Rebalance & Tactical Radar")
    lines.append(f"**Active Planning Period:** `{report_data['strategy_period']}` | **Fynn Brief Date:** `{macro.get('date', 'N/A')}`")
    lines.append(f"**Macro Stance:** {macro.get('regime', 'Normal')} (VIX: `{macro.get('vix', 'N/A')}`) | **Allocation Signal:** `{macro.get('allocation_signal', 'ACCUMULATE / DIVERSIFY')}`")
    lines.append("")
    lines.append("---")
    lines.append("")

    # 1. High-Conviction Accumulation (Buy / Dip Zones)
    lines.append("### 1. 🟢 Priority Accumulation (33 FVB Discount Pockets)")
    if cats["buy_dip_zone"]:
        lines.append("| Ticker | Price | Distance to 33 EMA | Daily 33 FVB | Weekly BX | Monthly BX | Guidance / Strategy Confluence |")
        lines.append("| :--- | :--- | :---: | :--- | :--- | :--- | :--- |")
        for s in cats["buy_dip_zone"]:
            lines.append(f"| **${s['ticker']}** | ${s['price']:.2f} | **{s['distance']}** | {s['fvb']} | {s['weekly_bx']} | {s['monthly_bx']} | {s['guidance']} |")
    else:
        lines.append("*No focus names currently in discount pocket.*")
    lines.append("")

    # 2. Froth Harvesting & Active Trims
    lines.append("### 2. 🌾 Froth Harvesting & Staged Trims (>10% Overextension)")
    if cats["take_profit"]:
        lines.append("| Ticker | Price | Distance to 33 EMA | Rating | Tactical Management Guidance |")
        lines.append("| :--- | :--- | :---: | :--- | :--- |")
        for s in cats["take_profit"]:
            lines.append(f"| **${s['ticker']}** | ${s['price']:.2f} | **{s['distance']}** | {s['rating']} | {s['guidance']} |")
    else:
        lines.append("*No focus names currently signaling Take Profit.*")
    lines.append("")

    # 3. Active Trend Runners
    lines.append("### 3. 🚀 Trend Runners: Hold and Ride (Do Not Chase)")
    if cats["trend_runner"]:
        lines.append("| Ticker | Price | Distance to 33 EMA | Rating | Tactical Management Guidance |")
        lines.append("| :--- | :--- | :---: | :--- | :--- |")
        for s in cats["trend_runner"]:
            lines.append(f"| **${s['ticker']}** | ${s['price']:.2f} | **{s['distance']}** | {s['rating']} | {s['guidance']} |")
    lines.append("")

    # 4. Roth IRA Management
    lines.append("### 4. 💼 Roth IRA Engine ($SPMO & $SMH)")
    spmo_sig = next((s for s in cats["buy_dip_zone"] + cats["trend_runner"] if s["ticker"] == "SPMO"), None)
    smh_sig = next((s for s in cats["buy_dip_zone"] + cats["trend_runner"] if s["ticker"] == "SMH"), None)
    lines.append("- **Target Split:** 65% $SPMO / 35% $SMH.")
    if spmo_sig:
        lines.append(f"- **$SPMO (${spmo_sig['price']:.2f}):** {spmo_sig['distance']} from 33 EMA ({spmo_sig['rating']}). Route new monthly contributions here if resting in discount pocket.")
    if smh_sig:
        lines.append(f"- **$SMH (${smh_sig['price']:.2f}):** {smh_sig['distance']} from 33 EMA ({smh_sig['rating']}). Let momentum ride; rebalance back to 35% if position exceeds 45% of account.")
    lines.append("")

    # 5. Structural Exits
    lines.append("### 5. 🛑 Structural Exits & Traps (Stand Aside)")
    exits = cats["full_exit"] + cats["wait_trap"]
    if exits:
        lines.append("| Ticker | Price | Distance to 33 EMA | Rating | Action Guidance |")
        lines.append("| :--- | :--- | :---: | :--- | :--- |")
        for s in exits:
            lines.append(f"| **${s['ticker']}** | ${s['price']:.2f} | **{s['distance']}** | {s['rating']} | Stand aside until 33 FVB confirms green daily close. |")
    lines.append("")

    # 6. Concentrated Position Management
    sndk_h = holdings.get("SNDK")
    sndk_sig = next((s for s in cats["buy_dip_zone"] + cats["trend_runner"] if s["ticker"] == "SNDK"), None)
    if sndk_sig:
        lines.append("### 6. 🛡️ $SNDK Concentrated Position Management")
        if sndk_h and sndk_h.get("weight_pct"):
            lines.append(f"- **Current Posture:** {sndk_sig['rating']} ({sndk_sig['distance']} vs 33 EMA, {sndk_h['weight_pct']:.1f}% portfolio weight).")
        else:
            lines.append(f"- **Current Posture:** {sndk_sig['rating']} ({sndk_sig['distance']} vs 33 EMA).")
        lines.append("- **Playbook:** De-risk target tranches on strength at long-term capital gains rates. Stage execution across tax year boundaries when appropriate; trailing stop at Daily 33 EMA.")
    lines.append("")

    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description="Rebalance Radar & Strategy Synthesizer")
    parser.add_argument("--sync", action="store_true", help="Sync FynnAI before synthesizing")
    parser.add_argument("--json", action="store_true", help="Output raw JSON instead of markdown")
    args = parser.parse_args()

    if args.sync:
        fynn_sync = os.path.join(Q_ROOT, "fynn_sync.py")
        if os.path.exists(fynn_sync):
            print("🔄 Running Fynn AI sync...", file=sys.stderr)
            os.system(f"python3 {fynn_sync}")

    strat_info = find_latest_strategy_card()
    if not strat_info:
        print("❌ Error: No Equity Half/Quarter strategy card found in cache/notion/cards.", file=sys.stderr)
        sys.exit(1)

    monthly_info = find_monthly_rebal_card()
    fynn_signals = parse_fynn_technical_table(FYNN_BRIEF_PATH)
    actual_holdings = get_actual_holdings(FYNN_ANALYTICS_PATH)
    macro_info = parse_macro_brief(FYNN_BRIEF_PATH)

    report_data = generate_synthesis(strat_info, monthly_info, fynn_signals, actual_holdings, macro_info)

    if args.json:
        print(json.dumps(report_data, indent=2))
    else:
        print(format_markdown_report(report_data))


if __name__ == "__main__":
    main()
