---
name: finance-watchlist-sync
description: Automates cross-platform watchlist synchronization across Robinhood, Seeking Alpha, Google Finance Beta, and external finance dashboards using high-speed browser automation and AppleScript DOM drivers.
---

# Financial Watchlist Synchronizer (`finance-watchlist-sync`)

## 1. Overview & Purpose
This skill manages automated, bidirectional synchronization of multi-ticker watchlists (e.g. `stock picks` and `stock watch`) across active financial web applications:
- **Source of Truth**: Robinhood Web / Legend or local FynnAI `brain/portfolio/holdings.json`.
- **Target Platforms**:
  - **Seeking Alpha** (`seekingalpha.com/account/portfolio/summary?portfolioId=...`)
  - **Google Finance Beta** (`google.com/finance/beta#lists`)
  - **TradingView / Snowball Analytics** (via CSV/JSON export)

---

## 2. Prerequisites & Setup
1. **Browser**: Google Chrome must have `Allow JavaScript from Apple Events` enabled:
   - macOS Menu Bar: **`View` ➔ `Developer` ➔ `Allow JavaScript from Apple Events`**
2. **Utilities**: `cliclick` for trusted OS-level hardware clicks on Material/Wiz components:
   ```bash
   brew install cliclick
   ```

---

## 3. Platform-Specific Automation Protocols

### A. Robinhood Ingestion Protocol
Robinhood displays watchlists either in **Robinhood Legend** (`/legend/layout/...`) as distinct `<section>` widgets or in the standard sidebar.
- **Extraction Command**:
  ```bash
  python3 -m engine.sync.cli watchlists
  ```
- **Direct Python API**:
  ```python
  from engine.sync.robinhood_watchlist import extract_robinhood_watchlists
  watchlists = extract_robinhood_watchlists()
  # returns: {"stock_picks": ["SNDK", "MU", ...], "stock_watch": ["TSLA", "ELF", ...]}
  ```

---

### B. Seeking Alpha Synchronization Protocol
Seeking Alpha uses React with standard modal inputs and dialog confirmations.

#### 1. Batch Adding Missing Tickers
1. Navigate to target portfolio URL:
   - `stock picks`: `https://seekingalpha.com/account/portfolio/summary?portfolioId=66479730`
   - `stock watch`: `https://seekingalpha.com/account/portfolio/summary?portfolioId=66479735`
2. Click `button[data-test-id="add-symbols-button"]` (`+ Add Symbol`).
3. Focus `input[placeholder*="Add symbols"]`.
4. Type or paste comma-separated string (e.g., `"TSLA, ELF, V, NFLX, SOFI, NKE, WDC, CELH"`).
5. Uncheck newsletter opt-in if needed, then click `button[data-test-id="add-ticker-done-btn"]` (`Done`).

#### 2. Removing Outdated Tickers
1. Click `button[data-test-id="edit-portfolio-button"]` (`Edit Portfolio`).
2. For each symbol to remove, click `button[aria-label="Delete <SYMBOL> symbol"]`.
3. In the confirmation dialog, click `button` with text `"Delete"`.
4. Click `Done` to save and exit edit mode.

---

### C. Google Finance Beta Protocol
Google Finance Beta uses Google's Wiz / Material 3 component framework.

#### 1. Removing Tickers from Lists
1. Navigate to `https://www.google.com/finance/beta#lists`.
2. Click `button[aria-label="Options for list <LIST_NAME>"]`.
3. Click menu item with text `"edit\nEdit"`.
4. Locate row container `.WKV3hc` with items `.vzBCm`.
5. Trigger delete on unwanted symbols.
6. Click `Done` to persist changes.

#### 2. Adding Tickers to Lists
1. Click `[aria-label="Add symbol to list <LIST_NAME>"]`.
2. Focus the search input (`.Fgl6fe-fmcmS-wGMbrd`).
3. Type target ticker.
4. Select first matching option and click `Done`.

---

## 4. Quick Standalone Sync Execution
To run an instant verification or update across all sites:
```bash
# 1. Inspect live Robinhood watchlists
python3 -m engine.sync.cli watchlists

# 2. Promote to active FynnAI dashboard
python3 -m engine.sync.cli watchlists --promote

# 3. Refresh dashboard
python3 engine/run.py
```
