#!/usr/bin/env python3
"""
Chief of Staff (CoS) Scaffolding Tool
-------------------------------------
Generates a complete, modular AI Chief of Staff setup inside any target directory.
Configures:
- Master Composer prompt (AGENTS.md)
- Domain Subagents (.agents/subagents/*.md)
- Local Cache structure (cache/*)
- Ingestion connectors & .env.example
"""

import os
import sys
import argparse
import shutil
from pathlib import Path
from typing import List, Set

DEFAULT_DOMAINS = ["operator", "personal_ops", "professional_ops", "wealth", "distill_engine"]
DEFAULT_SOURCES = ["notion", "google", "distills"]

DOMAIN_TEMPLATES = {
    "operator": {
        "title": "Operator & Daily Execution Sub-Agent",
        "role": "Daily Execution & Operator Sub-Agent",
        "description": "Specialized sub-agent for daily task triage, personal execution, calendar alignment, and email action items.",
        "resp1": ("Daily & Weekly Triage", "Inspect active cards in Notion / Task DBs", "Cross-reference with upcoming calendar events to stage realistic top 3 must-dos"),
        "resp2": ("Task & Card Management", "Add new tasks, update statuses to Done, or transition cards", "Flag stale cards or items lingering without updates"),
        "resp3": ("Personal Commitments & Renewals", "Track personal renewal notices and urgent deadlines", "Filter high-signal action items from email digests"),
        "cache": ["cache/notion/board_summary.md", "cache/google/calendars/today_agenda.md", "cache/google/email/triaged_inbox.json"]
    },
    "personal_ops": {
        "title": "Personal Life & Household Operations Sub-Agent",
        "role": "Personal Life & Household Operations Partner",
        "description": "Specialized subagent for personal life management: household maintenance, personal errands, medical appointments, vehicle upkeep, and family logistics.",
        "resp1": ("Household & Family Logistics", "Track home maintenance schedules (HVAC filters, pest control, repairs)", "Coordinate family calendar events and personal appointments"),
        "resp2": ("Personal Errands & Procurements", "Manage errand batches, grocery lists, and pending purchases", "Group errands geographically and temporally for maximum efficiency"),
        "resp3": ("Vehicle & Asset Maintenance", "Track service intervals, registrations, insurance renewals, and inspections", "Audit recurring personal memberships and subscriptions"),
        "cache": ["cache/notion/cards/", "cache/google/calendars/personal.json"]
    },
    "professional_ops": {
        "title": "Professional Projects & OKR Sub-Agent",
        "role": "Professional Projects & Executive OKR Partner",
        "description": "Specialized subagent for career and project leadership: tracking OKRs, deliverables, 1-on-1 prep, meeting takeaways, and strategic initiatives.",
        "resp1": ("Quarterly OKR & Initiative Tracking", "Maintain visibility over top company/team key results and deliverables", "Flag off-track milestones before sprint deadlines slip"),
        "resp2": ("Meeting & Stakeholder Prep", "Review attendee agendas, recent email threads, and past decision logs prior to high-stakes syncs", "Synthesize post-meeting raw notes into clear next steps with owners"),
        "resp3": ("Career Accomplishment Chronicling", "Log shipped projects, metrics moved, and peer commendations in real-time", "Maintain backlogs of speculative architecture RFCs and strategic proposals"),
        "cache": ["cache/notion/cards/", "cache/google/calendars/work.json", "cache/distills/"]
    },
    "wealth": {
        "title": "Wealth & Asset Accumulation Sub-Agent",
        "role": "Wealth & Asset Accumulation Sub-Agent",
        "description": "Specialized subagent for total net worth tracking, asset accumulation, savings rates, cashflow projections, and multi-account wealth aggregation.",
        "resp1": ("Total Net Worth & Balance Sheet", "Aggregate all asset classes: real estate equity, public equities, liquid cash, retirement accounts", "Monitor net worth milestones and multi-year goals"),
        "resp2": ("Cashflow & Savings Rate Tracking", "Coordinate annual retirement contributions, after-tax savings, and reinvestment strategies", "Track cash buffers, fixed monthly burn, and net savings rate"),
        "resp3": ("Connected Accounts Integration", "Ingest and verify balance updates from connected bank and brokerage feeds", "Prepare quarterly balance sheet and portfolio snapshots"),
        "cache": ["cache/plaid/balances_summary.md", "cache/notion/cards/", "cache/google/sheets/wealth_model.json"]
    },
    "distill_engine": {
        "title": "Distillation & Continuous Ingestion Sub-Agent",
        "role": "Distillation & Continuous Ingestion Sub-Agent",
        "description": "Specialized background sub-agent for continuous distillation of voice notes, chat dumps, scheduled jobs, and updating local cache.",
        "resp1": ("Continuous Chat & Thought Distillation", "Parse raw conversation dumps, voice notes, and braindumps", "Extract actionable nuggets, decisions, and ideas, tagging them by domain"),
        "resp2": ("Scheduled Routine Processing", "Process scheduled morning briefings, evening recaps, and weekly reviews", "Format digests into cache/distills/ for the Master Chief of Staff"),
        "resp3": ("Cache Synchronization & Health", "Verify cache freshness across all sources", "Re-run sync routines when data becomes stale"),
        "cache": ["cache/distills/", "cache/notion/", "cache/google/"]
    },
    "career_chronicler": {
        "title": "Career Chronicler Sub-Agent",
        "role": "Executive Career Chronicler",
        "description": "Specialized subagent for tracking career growth, promo criteria, impact logs, and 1-on-1 records.",
        "resp1": ("Impact Logging", "Record quantitative wins and milestones as they happen", "Map achievements directly to leadership leveling competencies"),
        "resp2": ("1-on-1 & Feedback Tracking", "Maintain running agendas for manager and skip-level syncs", "Track commitments and feedback loops"),
        "resp3": ("Portfolio & Brag Document", "Generate polished bullet points for performance review cycles", "Synthesize quarterly impact summaries"),
        "cache": ["cache/notion/cards/", "cache/distills/career_log.md"]
    },
    "real_estate": {
        "title": "Real Estate & Property Portfolio Sub-Agent",
        "role": "Real Estate Asset Manager",
        "description": "Specialized subagent for managing real estate properties, leases, maintenance, mortgage amortization, and rental cashflows.",
        "resp1": ("Lease & Tenant Operations", "Track lease renewals, rent collections, and security deposits", "Monitor tenant communications and repair requests"),
        "resp2": ("Property Cashflow & CapEx", "Track gross rents, net operating income (NOI), and mortgage debt service", "Maintain capital expenditure reserves and depreciation schedules"),
        "resp3": ("Market & Acquisition Analysis", "Analyze prospective deals, cap rates, and cash-on-cash returns", "Track local property tax and insurance assessments"),
        "cache": ["cache/notion/cards/", "cache/google/sheets/real_estate.json"]
    },
    "business_sandbox": {
        "title": "Business Sandbox & Venture Ideation Sub-Agent",
        "role": "Business Sandbox & Venture Strategist",
        "description": "Specialized subagent for brainstorming, validating, and managing side ventures, SaaS prototypes, and business experiments.",
        "resp1": ("Idea Incubation & Validation", "Structure raw business concepts into lean canvases and market analyses", "Define minimum viable products (MVPs) and validation milestones"),
        "resp2": ("Venture Backlog Management", "Maintain feature backlogs, go-to-market checklists, and user feedback", "Track unit economics and customer acquisition hypotheses"),
        "resp3": ("Competitive Intelligence", "Monitor competitor moves, pricing models, and market positioning", "Synthesize market research into actionable product roadmaps"),
        "cache": ["cache/notion/cards/", "cache/distills/ventures.md"]
    }
}

def generate_composer_agents_md(user_name: str, domains: List[str]) -> str:
    subagent_bullets = []
    for d in domains:
        info = DOMAIN_TEMPLATES.get(d, {
            "role": f"{d.capitalize()} Partner",
            "description": f"Specialized partner for {d}."
        })
        subagent_bullets.append(f"     - **`{d}`**: {info['description']}")

    subagents_block = "\n".join(subagent_bullets)

    return f"""# 🏛️ Chief of Staff Pair-Programming & Executive Guidelines

You are the personal **Chief of Staff (CoS)** for {user_name}.
You operate as a trusted executive partner, strategic sounding board, and execution driver across personal and professional domains.

## Core Directives

1. **Strategic Thought Partner**:
   - Engage conversantly when {user_name} is brainstorming, strategizing, or planning.
   - Structure messy thoughts into clean initiatives, milestones, and actionable task cards.
   - Guard {user_name}'s time, focus, and energy ruthlessly.

2. **Reading the Local Cache (Zero-Latency Intelligence)**:
   - Always inspect `./cache/` before querying external APIs.
   - Task Board & Active Cards: Inspect `cache/notion/board_summary.md` or search in `cache/notion/cards/`.
   - Calendar & Schedule: Inspect `cache/google/calendars/today_agenda.md`.
   - Email Action Triage: Inspect `cache/google/email/triaged_inbox.json`.
   - Financial Balances: Inspect `cache/plaid/balances_summary.md`.
   - If cache is empty or stale, run the corresponding sync command (e.g. `python3 notion_cli.py sync`).

3. **Managing Cards & Tasks**:
   - **Add Cards**: When tasks or ideas are agreed upon:
     ```bash
     python3 notion_cli.py add "Title" --db "Database Name" --status "To Do" --tags "tag1,tag2" --body "Details..."
     ```
   - **Update Cards**: When status changes:
     ```bash
     python3 notion_cli.py update "Card Title or ID" --status "Done" --notes "Updated notes..."
     ```
   - **Archive Cards**:
     ```bash
     python3 notion_cli.py archive "Card Title or ID"
     ```

4. **Domain Delegation (Specialized Subagents)**:
   - When a request requires specialized focus, delegate to domain subagents via `invoke_subagent`:
{subagents_block}

5. **Executive Operating Rhythms**:
   - **Morning**: Deliver a 60-second executive briefing (Today's Agenda, Top 3 Focus Priorities, Action Alerts).
   - **Evening**: Facilitate a brief wrap-up, celebrate completed cards, and stage tomorrow's top 3.
   - **Weekly**: Provide a cross-domain scorecard (Wins, Financial pulse, Upcoming week lookahead).

6. **Visual Dashboards**:
   - Render clean Markdown Kanban tables or Mermaid diagrams whenever {user_name} asks for a visual board or roadmap.
"""

def generate_subagent_md(domain: str) -> str:
    info = DOMAIN_TEMPLATES.get(domain, {
        "title": f"{domain.capitalize()} Sub-Agent",
        "role": f"{domain.capitalize()} Sub-Agent",
        "description": f"Specialized sub-agent for {domain} domain operations.",
        "resp1": (f"{domain.capitalize()} Strategy", f"Analyze and manage {domain} tasks", f"Optimize {domain} workflows"),
        "resp2": (f"Execution & Monitoring", f"Track key metrics and deadlines for {domain}", f"Maintain up-to-date records"),
        "resp3": (f"Synthesis & Reporting", f"Provide structured reports to Master Chief of Staff", f"Flag risks and blockers"),
        "cache": [f"cache/{domain}/", "cache/notion/cards/"]
    })

    cache_bullets = "\n".join([f"- `{c}`" for c in info["cache"]])

    return f"""---
name: {domain}
role: {info['role']}
description: >-
  {info['description']}
---

# 🛡️ {info['title']}

You are the personal **{info['role']}** for the user. Your mandate is to maintain deep focus on {domain}, track long-term milestones, eliminate friction, and provide structured, high-signal intelligence.

## 🎯 Primary Responsibilities
1. **{info['resp1'][0]}**:
   - {info['resp1'][1]}
   - {info['resp1'][2]}
2. **{info['resp2'][0]}**:
   - {info['resp2'][1]}
   - {info['resp2'][2]}
3. **{info['resp3'][0]}**:
   - {info['resp3'][1]}
   - {info['resp3'][2]}

## 📂 Primary Data Sources
{cache_bullets}

## 💬 Operational Guidelines
- Maintain strict domain focus; route cross-domain dependencies back to the Master Chief of Staff.
- Be concise, high-signal, and biased toward actionable outcomes.
"""

def generate_env_example(sources: List[str]) -> str:
    lines = ["# Chief of Staff Environment Configuration", ""]
    if "notion" in sources:
        lines.extend([
            "# Notion API Integration",
            "NOTION_API_KEY=secret_xxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
            ""
        ])
    if "google" in sources or "gmail" in sources:
        lines.extend([
            "# Google Workspace (Calendar, Gmail, Sheets)",
            "# Place credentials.json (OAuth 2.0 Client) in workspace root",
            "GOOGLE_CALENDARS=primary,work_calendar_id@group.calendar.google.com",
            ""
        ])
    if "plaid" in sources:
        lines.extend([
            "# Plaid Financial Integration",
            "PLAID_CLIENT_ID=your_plaid_client_id",
            "PLAID_SECRET=your_plaid_secret",
            "PLAID_ENV=development",
            ""
        ])
    return "\n".join(lines)

def main():
    parser = argparse.ArgumentParser(description="Scaffold an AI Chief of Staff setup.")
    parser.add_argument("--target", default=".", help="Target workspace path (default: current directory)")
    parser.add_argument("--user-name", default="the user", help="Principal / User name (default: 'the user')")
    parser.add_argument("--domains", default=",".join(DEFAULT_DOMAINS), help="Comma-separated list of domains to scaffold")
    parser.add_argument("--sources", default=",".join(DEFAULT_SOURCES), help="Comma-separated list of sources (notion, google, plaid, distills, notes)")
    parser.add_argument("--dry-run", action="store_true", help="Print actions without writing files")

    args = parser.parse_args()
    target_dir = Path(args.target).resolve()
    domains = [d.strip() for d in args.domains.split(",") if d.strip()]
    sources = [s.strip() for s in args.sources.split(",") if s.strip()]

    print(f"🏛️ Scaffolding AI Chief of Staff in: {target_dir}")
    print(f"   Domains: {', '.join(domains)}")
    print(f"   Sources: {', '.join(sources)}")
    print(f"   Dry Run: {args.dry_run}")
    print("-" * 50)

    # Directories to create
    dirs_to_create = [
        target_dir / ".agents" / "subagents",
        target_dir / ".agents" / "skills",
        target_dir / "cache"
    ]
    for s in sources:
        dirs_to_create.append(target_dir / "cache" / s)

    for d in dirs_to_create:
        if args.dry_run:
            print(f"[DRY RUN] Create directory: {d}")
        else:
            d.mkdir(parents=True, exist_ok=True)
            print(f"📁 Created directory: {d.relative_to(target_dir)}")

    # 1. Master AGENTS.md
    agents_md_file = target_dir / "AGENTS.md"
    composer_content = generate_composer_agents_md(args.user_name, domains)
    if args.dry_run:
        print(f"[DRY RUN] Write: {agents_md_file}")
    else:
        with open(agents_md_file, "w", encoding="utf-8") as f:
            f.write(composer_content)
        print(f"📝 Generated Master Composer prompt: {agents_md_file.name}")

    # 2. Subagents
    for domain in domains:
        subagent_file = target_dir / ".agents" / "subagents" / f"{domain}.md"
        subagent_content = generate_subagent_md(domain)
        if args.dry_run:
            print(f"[DRY RUN] Write subagent: {subagent_file}")
        else:
            with open(subagent_file, "w", encoding="utf-8") as f:
                f.write(subagent_content)
            print(f"🤖 Generated Subagent: .agents/subagents/{domain}.md")

    # 3. .env.example
    env_example_file = target_dir / ".env.example"
    env_content = generate_env_example(sources)
    if args.dry_run:
        print(f"[DRY RUN] Write: {env_example_file}")
    else:
        with open(env_example_file, "w", encoding="utf-8") as f:
            f.write(env_content)
        print(f"⚙️ Generated Environment Template: .env.example")

    # 4. Cache Placeholders & Summary Stubs
    for s in sources:
        summary_stub = target_dir / "cache" / s / "summary.md"
        if not summary_stub.exists():
            if args.dry_run:
                print(f"[DRY RUN] Create cache stub: {summary_stub}")
            else:
                with open(summary_stub, "w", encoding="utf-8") as f:
                    f.write(f"# 📊 {s.capitalize()} Local Cache Summary\n*No sync recorded yet. Run sync adapter to populate.*\n")
                print(f"📄 Created cache stub: cache/{s}/summary.md")

    print("-" * 50)
    print("✨ AI Chief of Staff Scaffolding Complete!")
    print("\nNext Steps:")
    print("1. Copy `.env.example` to `.env` and fill in your API tokens.")
    print("2. Run your source sync adapters to populate `cache/`.")
    print("3. Start conversing with Antigravity as your Master Chief of Staff!")

if __name__ == "__main__":
    main()
