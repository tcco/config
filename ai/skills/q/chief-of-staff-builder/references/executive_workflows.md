# 📋 Executive Workflows & Operating Rhythms

This reference outlines the core conversational operating rhythms that make an AI Chief of Staff proactive, structured, and indispensable.

---

## 1. The 5-Minute Morning Executive Briefing

**Goal**: Prepare the principal for the day in under 60 seconds of reading time, highlighting calendar commitments, urgent action items, and the top 3 focus priorities.

### Execution Procedure:
1. **Inspect Cache**:
   - Read `cache/google/calendars/today_agenda.md` (or relevant calendar files).
   - Read `cache/google/email/triaged_inbox.json` for urgent flags.
   - Read `cache/notion/board_summary.md` for cards currently marked `Doing` or urgent `To Do`.
2. **Format Response**:
   - **Executive Snapshot**: 1 sentence summary of day density (e.g., "Heavy meeting afternoon with 4 hours of deep work before 1 PM").
   - **📅 Today's Schedule**: Chronological list of meetings, noting preparation requirements or conflicts.
   - **🎯 Top 3 Focus Priorities**: High-leverage tasks aligned with strategic goals.
   - **⚠️ Friction & Action Alerts**: Expiring commitments, bills due, or unanswered high-stakes messages.

---

## 2. Conversational Thought-Partnering (Braindump -> Structured Cards)

**Goal**: Transform unstructured, messy thoughts into clean, prioritized, and actionable deliverables.

### Execution Procedure:
1. **Active Listening & Clarification**:
   - Let the user braindump freely without interrupting premature details.
   - Identify the implicit objectives, constraints, and dependencies.
2. **Structure the Proposal**:
   - Group the thoughts into concrete projects or discrete task cards.
   - Suggest appropriate database targets (e.g. `Get Done`, `Projects`, `Business Sandbox`).
   - Assign initial status (`To Do` / `Doing`), priority tags, and suggested deadlines.
3. **Execute Writeback**:
   - Once the user gives confirmation (or asks to create them), execute `python3 notion_cli.py add ...` or use MCP tools.
   - Report back the created card links and updated board state.

---

## 3. End-of-Day Wrap-Up & Stale Task Flush

**Goal**: Clear mental overhead, celebrate wins, and adjust tomorrow's trajectory.

### Execution Procedure:
1. **Review Today's Accomplishments**:
   - Prompt the user: *"What got crossed off today?"*
   - Update cards to `Done 🙌` / `Archived`.
2. **Identify Lingering Blockers**:
   - Check cards lingering in `Doing` without progress. Ask if they should be deprioritized, deferred, or delegated.
3. **Stage Tomorrow's Top 3**:
   - Pull from `To Do` queue into tomorrow's focus list.

---

## 4. Weekly Recalibration & Strategic Review

**Goal**: Prevent micro-task drift and ensure alignment with high-level quarterly milestones and personal wealth/career goals.

### Execution Procedure:
1. **Delegate Domain Audits**:
   - Master Composer triggers domain subagents:
     - `career_chronicler`: Summarize key deliverables, metrics moved, and feedback received this week.
     - `wealth`: Check cash balances, recent savings contributions, and upcoming quarterly tax/equity events.
     - `operator`: Triage upcoming week calendar density, travel, and personal errands.
2. **Synthesize Executive Briefing**:
   - Present a unified Weekly Scorecard:
     - **Wins & Milestones**: Major deliverables shipped.
     - **Financial Pulse**: Savings rate, account movements, equity checkpoints.
     - **Upcoming Week Lookahead**: Critical meetings, deadlines, and high-focus time blocks.
3. **Roadmap & Kanban Visualization**:
   - Render interactive Markdown Kanban tables or Mermaid Gantt roadmaps visualizing progress across active projects.
