#!/usr/bin/env python3
"""
Chief of Staff Healthcheck & Diagnostic Tool
---------------------------------------------
Audits:
1. Master Composer configuration (AGENTS.md)
2. Domain Subagent markdown definitions (.agents/subagents/*.md)
3. Proactive Radar & Content Tracking (cache/preferences/proactive_radar.md)
4. Executive Priorities & Decisions Log (cache/preferences/*)
5. Local Cache freshness and entity counts (cache/*)
6. Environment & integration readiness (.env)
"""

import os
import sys
import json
import time
from pathlib import Path
from datetime import datetime, timedelta

def load_env(env_path: Path) -> dict:
    env_vars = {}
    if env_path.exists():
        with open(env_path, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("#") or "=" not in line:
                    continue
                k, v = line.split("=", 1)
                env_vars[k.strip()] = v.strip().strip("'\"")
    return env_vars

def main():
    root = Path.cwd()
    print(f"\n🔍 Running AI Chief of Staff Healthcheck on: {root}\n" + "=" * 60)

    issues = []
    warnings = []
    successes = []

    # 1. Check Master AGENTS.md
    agents_md = root / "AGENTS.md"
    if agents_md.exists():
        size = agents_md.stat().st_size
        successes.append(f"Master Composer found: AGENTS.md ({size} bytes)")
    else:
        issues.append("Missing AGENTS.md at workspace root (Master Composer prompt)")

    # 2. Check Proactive Radar & Preferences
    radar_file = root / "cache" / "preferences" / "proactive_radar.md"
    prefs_file = root / "cache" / "preferences" / "user_preferences.md"
    decisions_file = root / "cache" / "preferences" / "decisions_log.md"

    if radar_file.exists() and radar_file.stat().st_size > 0:
        successes.append(f"Proactive Radar active: cache/preferences/proactive_radar.md ({radar_file.stat().st_size} bytes)")
    else:
        warnings.append("Missing or empty cache/preferences/proactive_radar.md (Proactive Content Radar)")

    if prefs_file.exists() and prefs_file.stat().st_size > 0:
        successes.append(f"User Priorities active: cache/preferences/user_preferences.md ({prefs_file.stat().st_size} bytes)")
    else:
        warnings.append("Missing or empty cache/preferences/user_preferences.md")

    if decisions_file.exists() and decisions_file.stat().st_size > 0:
        successes.append(f"Decisions Log active: cache/preferences/decisions_log.md ({decisions_file.stat().st_size} bytes)")
    else:
        warnings.append("Missing or empty cache/preferences/decisions_log.md")

    # 3. Check Subagents
    subagents_dir = root / ".agents" / "subagents"
    if subagents_dir.exists():
        subagents = list(subagents_dir.glob("*.md"))
        if subagents:
            successes.append(f"Found {len(subagents)} domain subagents in .agents/subagents/:")
            for sa in subagents:
                # Basic frontmatter check
                content = sa.read_text(encoding="utf-8")
                if content.startswith("---") and "name:" in content:
                    print(f"   ✅ {sa.name}")
                else:
                    warnings.append(f"Subagent {sa.name} missing YAML frontmatter ('---')")
        else:
            warnings.append("No domain subagent markdown files found in .agents/subagents/")
    else:
        warnings.append("No .agents/subagents/ directory found.")

    # 4. Check Cache
    cache_dir = root / "cache"
    if cache_dir.exists():
        subdirs = [d for d in cache_dir.iterdir() if d.is_dir()]
        successes.append(f"Cache root verified: {cache_dir.name}/ ({len(subdirs)} source folders)")
        
        now = datetime.now()
        for d in subdirs:
            files = list(d.rglob("*.*"))
            if not files:
                warnings.append(f"Cache directory cache/{d.name}/ is empty.")
                continue
            
            # Find latest modification time
            latest_mtime = max(f.stat().st_mtime for f in files)
            latest_dt = datetime.fromtimestamp(latest_mtime)
            age = now - latest_dt

            age_str = (
                f"{int(age.total_seconds() // 60)} mins ago" if age < timedelta(hours=1)
                else f"{int(age.total_seconds() // 3600)} hours ago" if age < timedelta(days=1)
                else f"{age.days} days ago"
            )

            if age > timedelta(days=7):
                warnings.append(f"Cache cache/{d.name}/ is stale (last synced {age_str}, {len(files)} files)")
            else:
                successes.append(f"cache/{d.name}/ is fresh (last synced {age_str}, {len(files)} files)")
    else:
        issues.append("Missing cache/ directory. Run sync adapters to initialize.")

    # 5. Check Environment & Tokens
    env_path = root / ".env"
    if env_path.exists():
        env_vars = load_env(env_path)
        configured_keys = [k for k, v in env_vars.items() if v and not v.startswith("secret_xxx") and not v.startswith("your_")]
        successes.append(f".env found with {len(configured_keys)} active configuration keys ({', '.join(configured_keys) if configured_keys else 'none'})")
        
        if "NOTION_API_KEY" not in env_vars:
            warnings.append("NOTION_API_KEY is not defined in .env")
    else:
        warnings.append("No .env file found. Run 'cp .env.example .env' and configure secrets.")

    # Print Summary
    print("\n📊 HEALTH SUMMARY")
    print("-" * 60)
    for s in successes:
        print(f"  🟢 {s}")
    for w in warnings:
        print(f"  🟡 WARNING: {w}")
    for i in issues:
        print(f"  🔴 ERROR: {i}")

    print("-" * 60)
    if not issues:
        print("🎉 Chief of Staff system is healthy and operational!\n")
    else:
        print(f"⚠️ Chief of Staff has {len(issues)} issue(s) that need attention.\n")

if __name__ == "__main__":
    main()
