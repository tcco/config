# 🛠️ Chief of Staff Interactive Setup & Calibration Guide

This guide details the complete 5-phase onboarding workflow for setting up a Chief of Staff system from scratch, connecting data feeds, setting up the proactive radar, and testing subagents before going live.

---

## 🧭 Phase 1: Purpose & Archetype Discovery

Before writing code or syncing APIs, clarify the principal's operating style, pain points, and scope:

### Discovery Questions to Ask the User:
1. **Operating Scope**:
   - *Personal Ops*: Household maintenance, family calendar, wellness, vehicle/home, personal errands.
   - *Professional Ops*: OKRs, meeting prep, career logging, sprint deliverables, stakeholder updates.
   - *Wealth & Assets*: Net worth tracking, cashflow models, real estate, equity/RSUs.
   - *Strategic Sandbox*: Venture ideation, technical RFCs, side projects.
2. **Substantive Priorities**:
   - What are the top 3-5 specific topics, projects, or recurring problems you want the Chief of Staff to watch over and solve ahead of time?
3. **Delegation Authority**:
   - How much should the Chief of Staff do automatically vs. draft for confirmation?
   - *Recommended*: Read/monitor automatically; draft proposed solutions and prompt for confirmation before executing writes.

---

## 🔌 Phase 2: Connecting & Ingesting Data Sources

Walk through connecting and testing each source one by one.

### 1. Notion Connection
1. Set up integration secret in `.env`: `NOTION_API_KEY=secret_...`
2. Share relevant databases/pages in Notion with the integration.
3. **Test Command**:
   ```bash
   python3 notion_cli.py sync
   ```
4. **Validation Check**:
   - Inspect `cache/notion/board_summary.md` to verify cards and statuses are populated.
   - Run `python3 notion_cli.py status` to confirm discovered database counts.

---

### 2. Google Workspace Connection (Calendar, Email, Sheets)
1. Place `credentials.json` (OAuth Desktop Client) in the workspace root.
2. Configure `.env` with target calendar IDs or spreadsheet IDs.
3. **Test Command**:
   ```bash
   python3 google_sync.py
   ```
4. **Validation Check**:
   - Inspect `cache/google/calendars/today_agenda.md` or event JSONs.
   - Inspect `cache/google/email/triaged_inbox.json` for action emails.

---

### 3. Financial & Plaid Connection (Optional)
1. Configure `PLAID_CLIENT_ID` and `PLAID_SECRET` in `.env`.
2. Run Plaid balance sync adapter.
3. **Validation Check**:
   - Verify `cache/plaid/balances_summary.md` displays liquidity and debt totals accurately.

---

### 4. Continuous Distillation & Notes (Apple Notes / Chat Dumps)
1. Place raw transcripts or notes into `cache/raw_dumps/` or configure Apple Notes export.
2. Run distillation subagent test.

---

## 🎯 Phase 3: Proactive Radar, Content Memory & Scheduling

Set up proactive intelligence so the Chief of Staff continuously monitors and solves problems ahead of time:

1. **Populate Proactive Radar (`cache/preferences/proactive_radar.md`)**:
   - Active inquiries and topics requested by the user.
   - Specific data sources and trigger conditions to monitor.
   - Proactive problem-solving queue (unblocking stalled tasks, upcoming renewals, travel progressions).
2. **Define Substantive Boundaries (`cache/preferences/user_preferences.md`)**:
   - Core financial targets, domain priority stack, autonomous action boundaries.
3. **Seed Future Notes Log (`cache/preferences/decisions_log.md`)**:
   - Log founding architecture choices, current quarterly goals, and active commitments.
4. **Configure Proactive Schedulers**:
   - Set up scheduled triggers using the `schedule` tool (e.g. morning briefings, follow-up timers).

---

## 🧪 Phase 4: Testing & Calibrating Subagents

Before relying on subagents for daily work, calibrate each subagent individually.

### Step 1: Run the Automated Audit
```bash
python3 .agents/skills/chief-of-staff-builder/scripts/test_subagents.py
```
This script validates whether every file path mentioned in `.agents/subagents/*.md` exists in the local cache.

---

### Step 2: Interactive Calibration Test Run
Execute a test query for each domain subagent to verify reasoning and data extraction:

| Domain Subagent | Test Calibration Prompt | Expected Response |
|---|---|---|
| **Operator** | *"Review my upcoming 48 hours and active Doing/To Do tasks. What are my top 3 must-dos today?"* | Focused top 3 priority list linked to calendar time blocks |
| **Personal Ops** | *"Audit our household tasks, errands, and vehicle registrations due in the next 14 days."* | Clustered personal errand list with upcoming expiration dates |
| **Professional Ops** | *"What is the status of our top quarterly OKRs and deliverables? What is blocked?"* | Concise OKR table highlighting blocked workstreams |
| **Career Chronicler** | *"Review recent project milestones and generate 3 brag bullets for my performance review."* | High-impact, quantitative accomplishment bullet points |
| **Wealth** | *"Inspect our asset balances and passive cost model. What is our current liquidity posture?"* | High-level balance sheet summary with savings rate breakdown |
| **Distill Engine** | *"Scan recent conversation dumps and extract any decisions or pending tasks."* | Normalized action items tagged by domain |

---

## 🏁 Phase 5: Activating Executive Operating Rhythms

Once data sources and subagents pass calibration, test the full system operating loop:

1. **Test the Morning Briefing**:
   - Ask the Master Chief of Staff: *"Give me my morning executive briefing."*
   - Verify that it combines calendar, emails, top priority tasks, and proactive radar updates in <60 seconds of reading.
2. **Test Thought Partnering (Braindump -> Task)**:
   - Provide a raw 3-sentence braindump: *"Need to get new tires on the SUV, review the Q3 cloud budget spreadsheet with Sarah, and follow up with the plumber about the leak."*
   - Verify the Chief of Staff structures these into distinct items, routes them to correct databases/domains, and asks to create cards.
3. **Test Proactive Problem-Solving & Scheduling**:
   - Ask the Chief of Staff: *"What is on your proactive radar and what solutions are you preparing?"*
   - Verify it lists the tracked focus areas and proposes concrete next steps without prompting.
4. **Test Writeback Execution**:
   - Approve card creation: *"Yes, create those cards."*
   - Verify the tool executes `notion_cli.py add ...` and returns confirmed card IDs.
