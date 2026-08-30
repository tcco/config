#!/usr/bin/env python3
"""
Chief of Staff Subagent Calibration & Test Runner
-------------------------------------------------
Audits and tests each configured subagent:
1. Verifies that all declared data sources in the subagent prompt exist in cache/
2. Generates domain-specific test calibration prompts
3. Simulates subagent readiness score
"""

import os
import sys
import json
import re
from pathlib import Path
from typing import Dict, List, Any

def extract_frontmatter_and_sources(file_path: Path) -> Dict[str, Any]:
    content = file_path.read_text(encoding="utf-8")
    frontmatter = {}
    
    # Extract YAML frontmatter
    fm_match = re.search(r"^---\s*\n(.*?)\n---", content, re.DOTALL)
    if fm_match:
        for line in fm_match.group(1).splitlines():
            if ":" in line:
                k, v = line.split(":", 1)
                frontmatter[k.strip()] = v.strip().strip("'\"")

    # Extract cache paths mentioned in markdown
    cache_paths = re.findall(r"`(cache/[^`]+)`", content)

    return {
        "name": frontmatter.get("name", file_path.stem),
        "role": frontmatter.get("role", "Specialized Subagent"),
        "description": frontmatter.get("description", ""),
        "declared_cache_paths": list(set(cache_paths)),
        "file_path": file_path
    }

SAMPLE_CALIBRATION_PROMPTS = {
    "operator": "Review my upcoming 48 hours of calendar events and my active 'Doing' and 'To Do' cards. What are my top 3 must-execute priorities for today, and are there any scheduling conflicts?",
    "personal_ops": "Audit our household maintenance items, personal errands, and vehicle registrations. What items are due in the next 14 days?",
    "professional_ops": "Summarize the status of our active quarterly OKRs and top engineering/project deliverables. What is currently blocked?",
    "career_chronicler": "Review recent accomplishments and project milestones. Generate 3 high-impact brag bullet points suitable for a performance review or manager 1-on-1.",
    "wealth": "Inspect our asset balances, passive cost models, and upcoming equity milestones. What is our current liquidity posture and savings trajectory?",
    "real_estate": "Audit property cashflows, upcoming lease renewals, and maintenance reserves across our real estate portfolio.",
    "business_sandbox": "Review our venture ideas and active MVP backlogs. What is the highest-leverage experiment we should run next?",
    "distill_engine": "Scan recent raw notes, chat logs, and meeting transcripts. Extract any uncaptured action items or key decisions."
}

def main():
    root = Path.cwd()
    subagents_dir = root / ".agents" / "subagents"

    print(f"\n🧪 Chief of Staff Subagent Calibration & Test Suite")
    print(f"   Scanning: {subagents_dir}\n" + "=" * 65)

    if not subagents_dir.exists():
        print("❌ No .agents/subagents/ directory found. Run scaffold_cos.py first.")
        sys.exit(1)

    subagent_files = sorted(list(subagents_dir.glob("*.md")))
    if not subagent_files:
        print("❌ No subagent markdown files found in .agents/subagents/.")
        sys.exit(1)

    total_subagents = len(subagent_files)
    ready_count = 0

    for sa_file in subagent_files:
        meta = extract_frontmatter_and_sources(sa_file)
        name = meta["name"]
        role = meta["role"]
        cache_paths = meta["declared_cache_paths"]

        print(f"\n🤖 Subagent: [{name}] — {role}")
        print(f"   File: .agents/subagents/{sa_file.name}")

        # Check data sources
        missing_sources = []
        found_sources = []

        if not cache_paths:
            print("   ⚠️ No explicit `cache/...` paths referenced in definition.")
        else:
            for cp in cache_paths:
                p = root / cp
                if p.exists():
                    # check if directory has files or file is non-empty
                    if p.is_dir():
                        files = list(p.rglob("*.*"))
                        if files:
                            found_sources.append(f"{cp} ({len(files)} items)")
                        else:
                            missing_sources.append(f"{cp} (folder exists but is empty)")
                    elif p.is_file() and p.stat().st_size > 0:
                        found_sources.append(f"{cp} ({p.stat().st_size} bytes)")
                    else:
                        missing_sources.append(f"{cp} (file empty)")
                else:
                    missing_sources.append(f"{cp} (not found)")

        for fs in found_sources:
            print(f"   🟢 Data Source OK: {fs}")
        for ms in missing_sources:
            print(f"   🔴 Data Source Missing: {ms}")

        # Calibration Prompt
        prompt = SAMPLE_CALIBRATION_PROMPTS.get(name, f"Review all available data in your domain cache and provide a status update on active {name} priorities.")
        print(f"   💡 Test Prompt to calibrate:")
        print(f"      👉 \"{prompt}\"")

        if not missing_sources:
            print("   ✅ Status: READY FOR ORCHESTRATION")
            ready_count += 1
        else:
            print("   ⚠️ Status: NEEDS DATA SYNC BEFORE TESTING")

    print("\n" + "=" * 65)
    print(f"📊 SUMMARY: {ready_count}/{total_subagents} Subagents fully calibrated with local cache data.")
    if ready_count < total_subagents:
        print("👉 Tip: Run your source ingestion scripts (e.g. `python3 notion_cli.py sync` or `python3 google_sync.py`) to hydrate missing data sources.")
    print("")

if __name__ == "__main__":
    main()
