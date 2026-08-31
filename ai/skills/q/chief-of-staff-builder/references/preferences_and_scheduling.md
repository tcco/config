# 🎯 Proactive Need Anticipation, Content Tracking & Scheduling

This reference outlines how an AI Chief of Staff tracks the *substantive content* a user asks for, maintains a proactive radar of open loops and key entities, and proactively solves problems over time without waiting to be asked.

---

## 1. Beyond Tone: Substantive Content Tracking

A truly indispensable Chief of Staff does not just adapt its communication style—it **remembers what you care about** and works ahead of you:

```text
User Asks / Inquires ───> [Content Extractor] ───> cache/preferences/proactive_radar.md
                                              ───> cache/preferences/user_preferences.md (Priorities & Bounds)
                                              ───> cache/preferences/decisions_log.md    (Permanent Context)
                                              
Background Ingestion ───> [Proactive Radar Monitor] ───> Matches events/signals against tracked topics
                                                    ───> Proactively drafts solutions & next steps
                                                    ───> Surfaces in Morning Briefings & Interactions
```

### Core Operating Cycle:
1. **Capture the Inquiry / Focus Area**: When the user asks about a specific stock, trip, deal, person, contract, or problem, the CoS captures *what was asked*, *why it matters*, and *what sources to monitor*.
2. **Continuous Background Monitoring**: As local cache files update (new emails, calendar events, Notion cards, market signals), the CoS checks them against the active topics on the **Proactive Radar**.
3. **Proactive Resolution (Solving Ahead of Time)**: When new information arrives or a deadline approaches, the CoS does not wait to be asked. It volunteers the update along with a recommended solution (e.g. proposed calendar adjustment, drafted card, suggested reservation, unblocking steps).

---

## 2. Proactive Radar Schema (`cache/preferences/proactive_radar.md`)

```markdown
# 🎯 Proactive Radar & Substantive Content Tracking

## 📡 Active Inquiries & Topics on the Radar

| Topic / Entity | What User Requests / Cares About | Proactive Trigger & Monitored Source | Status / Next Proactive Step |
| :--- | :--- | :--- | :--- |
| **NYC Trip (Sept 5–8)** | Weekend flow, restaurant bookings, friend coordination. | Calendar + weather updates. | Proactively draft itinerary and recommend dinner reservations. |
| **SNDK / NVDA Quants** | Momentum signals and valuation targets. | `cache/fynn/equity_signals.json` | Alert on breakout signals or risk reversals. |
| **Q3 Tax / Mega-Backdoor** | Contribution caps and execution deadline. | Financial sheets / Plaid. | Model allocation options 30 days before year-end. |

## 🔍 Proactive Problem-Solving Queue
1. **Stalled Tasks**: Diagnose why high-priority cards in `Doing` are blocked and propose 2 concrete unblocking steps.
2. **Upcoming Expirations & Renewals**: Flag vehicle/insurance/subscription renewals 14–30 days out with drafted renewal actions.
3. **Calendar Congestion**: Identify high-density meeting days and proactively propose protected focus blocks.
```

---

## 3. Substantive Executive Priorities (`cache/preferences/user_preferences.md`)

Defines the substantive criteria for what matters to the principal:
- **Financial Thresholds**: Minimum cash buffer, passive income target ($50k–$70k/mo), asset allocation rules.
- **Operational Boundaries**: What the CoS can execute autonomously (cache syncing, monitoring, timers) vs. what requires user confirmation (modifying cards, sending communications).
- **Domain Priority Stack**: Current quarter's top 3 strategic focus areas.

---

## 4. Proactive Scheduling & Autonomous Follow-Up

When a tracked topic has a temporal deadline or recurring cadence, the Chief of Staff activates:

### 1. In-Session & Background Timers (`schedule` tool)
- Set timers to check back on time-sensitive operations (e.g., waiting for API response, checking ticker close).
- Recurring cron schedules for automated morning briefs and weekly reviews.

### 2. Scheduled Task Cards (`notion_cli.py`)
- Create dated follow-up cards in Notion so long-term deliverables don't slip.

### 3. Calendar Guardrails (`google_sync.py`)
- Proactively stage reminder blocks or protect deep-work slots.
