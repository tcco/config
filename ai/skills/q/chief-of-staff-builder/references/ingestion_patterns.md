# 📥 Ingestion Patterns & Connectors Reference

This reference outlines patterns and recipes for building zero-framework, rate-limited, and token-efficient ingestion connectors for the AI Chief of Staff.

---

## 1. Core Ingestion Contract

Every ingestion adapter should adhere to the following contract:

```text
Source API / Feed ───> [Adapter Script] ───> 1. Raw JSON:   cache/<source>/<entity_id>.json
                                         ───> 2. Summary MD: cache/<source>/summary.md
                                         ───> 3. Global Index: cache/index.json
```

### Key Requirements
1. **Idempotency**: Running `python3 sync.py` multiple times must not duplicate records or corrupt cache files.
2. **Atomic Writes**: Write to a temporary file first, then atomically replace the target file to prevent partial reads during agent interaction.
3. **Dual Output (JSON + Markdown)**:
   - `*.json`: Machine-readable structured schema for filtering and automated calculations.
   - `summary.md`: Human-and-LLM-readable digest for fast context loading in system prompts.
4. **Rate Limiting & Exponential Backoff**: Gracefully handle 429 and network glitches without crashing.

---

## 2. Ingestion Recipes by Source

### A. Notion Database & Page Sync
- **Protocol**: Notion REST API (`https://api.notion.com/v1/`).
- **Sync Strategy**:
  1. Query `databases` shared with the internal integration secret.
  2. For each database, query pages where `archived == false`.
  3. Extract properties (Status, Tags, Dates, Assignee, Selects).
  4. Fetch page body blocks and convert to clean Markdown.
  5. Dump `cache/notion/cards/<page_id>.json` and generate `cache/notion/board_summary.md`.

```python
# Minimal Notion Fetch Snippet
import requests, json
headers = {
    "Authorization": f"Bearer {NOTION_API_KEY}",
    "Notion-Version": "2022-06-28",
    "Content-Type": "application/json"
}
res = requests.post(f"https://api.notion.com/v1/databases/{DB_ID}/query", headers=headers)
cards = res.json().get("results", [])
```

---

### B. Google Workspace (Calendar, Gmail, Sheets)
- **Protocol**: Google OAuth 2.0 (`credentials.json` -> `token.json`) using Google API Client.
- **Sync Strategy**:
  - **Google Calendar**: Ingest events for `now - 1 day` to `now + 7 days`. Group by calendar ID (e.g. work vs. personal). Generate `today_agenda.md`.
  - **Gmail**: Query high-priority filters (e.g. `is:unread category:primary newer_than:3d -category:promotions`). Extract `Subject`, `From`, `Snippet`, `Date`, and generate an action list `triaged_inbox.json`.
  - **Google Sheets**: Download named ranges or worksheet tables (e.g. budget, net worth model) into structured tables.

---

### C. Apple Notes & Local Markdown Journals
- **Protocol**: Direct SQLite / AppleScript or local file ingestion.
- **Sync Strategy**:
  - Scan local note directories (`~/Library/Group Containers/group.com.apple.notes/` or Obsidian vault `~/Documents/Vault/`).
  - Extract recent notes created or modified in the last 7 days.
  - Write normalized markdown files to `cache/notes/<note_id>.md`.

---

### D. Voice Memos & Chat Dumps (Gemini / Spark / Transcripts)
- **Protocol**: File watcher, export webhook, or manual drop into `cache/raw_dumps/`.
- **Sync Strategy**:
  - The `distill_engine` subagent reads raw transcripts.
  - Parses conversational tangents, questions, and decisions.
  - Produces structured distillations:
    - **Key Decisions**: Permanent decisions made during conversations.
    - **Action Candidates**: Tasks proposed for the user to review.
    - **Domain Insights**: Strategic nuggets routed to Wealth, Career, or Real Estate.

---

### E. Financial & Bank Feeds (Plaid / Open Banking / CSVs)
- **Protocol**: Plaid API or manual bank CSV drops.
- **Sync Strategy**:
  - Sync account balances (Checking, Savings, Brokerage, Credit Cards, Loans).
  - Compute total liquid cash, total debt, and monthly net savings rate.
  - Store summary in `cache/plaid/balances_summary.md` and detailed transactions in `cache/plaid/accounts.json`.

---

## 3. Cache Directory Schema Specification

```
cache/
├── index.json                    # Meta manifest: sync timestamps, source statuses
├── notion/
│   ├── board_summary.md          # Markdown Kanban view of active tasks
│   ├── databases/
│   │   └── <db_name_or_id>.json  # Schema, statuses, tags
│   └── cards/
│       └── <card_id>.json        # Card title, status, tags, markdown body
├── google/
│   ├── calendars/
│   │   ├── today_agenda.md       # Pre-rendered 24h schedule
│   │   └── <cal_id>.json         # Raw event array
│   ├── email/
│   │   └── triaged_inbox.json    # Actionable filtered emails
│   └── sheets/
│       └── <sheet_name>.json     # Tabular data exports
├── distills/
│   ├── decisions_log.md          # Log of key decisions
│   └── weekly_synthesis.md       # Consolidated insights
└── plaid/
    ├── balances_summary.md       # High-level net worth & liquidity
    └── accounts.json             # Normalized account balances
```
