---
name: mac-disk-maintenance
description: >-
  Audit macOS disk usage, diagnose storage bloat, generate tiered cleanup menus, and safely execute system maintenance to keep macOS running smooth. Use whenever the user asks to clean up disk space, audit storage, remove developer or app bloat, or optimize Mac performance.
---

# macOS Disk Maintenance & Storage Health Guide

This skill provides a structured, safe, multi-phase procedure to audit disk space, identify storage hogs, present categorized cleanup menus, and safely execute approved deletions while preventing accidental data loss.

---

## 4-Phase Operational Workflow

### Phase 1: Comprehensive Read-Only Audit
Perform a non-destructive, read-only system scan across all standard storage sinks:

1. **System & Volume State**:
   - Check filesystem free space: `df -h / /System/Volumes/Data`
   - Check APFS container & purgeable space: `diskutil apfs list`
   - Check local Time Machine / OS update snapshots: `tmutil listlocalsnapshots /`
2. **Top-Level Storage Breakdown**:
   - Home directory breakdown: `du -hd 1 ~ | sort -hr | head -25`
   - Applications, system libraries, Homebrew: `du -hd 1 /Applications /Library /usr/local /opt/homebrew | sort -hr | head -25`
3. **Subsystem Scans**:
   - **Xcode & Simulators**: `~/Library/Developer/CoreSimulator/Devices`, `~/Library/Developer/CoreSimulator/Caches`, `/Library/Developer/CoreSimulator/Profiles/Runtimes`, `~/Library/Developer/Xcode/DerivedData`, `~/Library/Developer/Xcode/iOS DeviceSupport`, `~/Library/Developer/Xcode/Archives`.
   - **App Data & Electron Caches**: `~/Library/Caches/*`, `~/Library/Application Support/*` (Notion, Chrome, Discord, Slack, Asana, Box, Adobe, Steam, Spotify).
   - **Containers**: `~/Library/Containers/*`, `~/Library/Group Containers/*`.
   - **Package Managers & Compilers**: `brew --cache` (`~/Library/Caches/Homebrew`), `~/.npm`, `~/.pnpm-store`, `~/.cargo`, `~/.rustup`, `~/.gradle`, `~/.m2`, `~/.cache/pip`, `~/.conda`.
   - **Virtual Environments & Build Artifacts**: Search for large `node_modules/`, `.venv/`, `target/`, `Pods/`, `.build/` (>300 MB).
   - **User Downloads, Trash, Mail & Media**: `~/Downloads`, `~/.Trash`, `~/Library/Mail`, `~/Library/Messages/Attachments`, `~/Pictures/*.photoslibrary`, `~/Movies/*.imovielibrary`.
   - **Large Individual Files**: `find ~ -type f -size +1G -not -path "*/.Trash/*" 2>/dev/null`.

---

### Phase 2: Menu Generation & Categorization
Group all identified cleanup targets into a numbered markdown table across three tiers with running totals:

* **Tier 1: Zero-Risk (Safe Caches, Logs, Temp Files)**
  - Fully ephemeral; regenerates automatically without user interaction.
  - Examples: Homebrew download cache (`brew cleanup -s`), browser/electron web caches, simulator runtime dyld cache, npm/pnpm caches, system temp logs.
* **Tier 2: Tradeoffs (Developer Environments, Legacy Runtimes, Inactive App Data)**
  - Requires deliberate re-installation or re-download if needed again.
  - Examples: Old iOS Simulator runtimes (`/Library/Developer/CoreSimulator/Profiles/Runtimes`), erased simulator devices (`xcrun simctl erase all`), offline database partitions (Notion/Slack offline cache), browser on-device AI models, stale `node_modules` or `.venv` directories, outdated standalone applications (e.g. past tax software).
* **Tier 3: Structural & Large Apps (Requires Interactive Review)**
  - Large desktop application bundles, stock media apps (iMovie, GarageBand), personal working datasets, active Wine bottles, or local file archives.
  - Requires explicit confirmation or walkthrough.

#### Menu Column Format
Every menu item must present:
`ID | Path | Size | What it is | Regenerates? | What breaks if it's gone | Exact Command`

*Always calculate and display the running total reclaimable per tier and the cumulative grand total.*

---

### Phase 3: Safe Execution Protocol
Carry out user selections strictly under the following safety rules:

1. **Restate Batch & Total Size**: Always print the selected IDs and the predicted total GB reclaimed before executing.
2. **Reversible-First**:
   - For user files and apps under 5 GB, move items to `~/.Trash` via `mv <path> ~/.Trash/`.
   - Use `rm -rf` ONLY for ephemeral caches and build artifacts that regenerate on demand, or when moving to Trash would duplicate disk usage on large single files.
3. **Prefer Vendor Tools**:
   - Homebrew: `brew cleanup -s`
   - Simulators: `xcrun simctl erase all` or `xcrun simctl delete unavailable`
   - Docker: `docker system prune -a --volumes` (interactive confirmation)
   - Node: `npm cache clean --force`, `pnpm store prune`
4. **Safety Against Path Expansion**:
   - Never run `rm -rf` against unquoted variables or wildcards at the root of a home directory without echoing the fully expanded path first.
5. **Sudo Approval**:
   - If any command touches root-owned system directories (e.g., `/Library/Developer/...`), explain why `sudo` is needed and confirm before proceeding.
6. **Logging**:
   - Append every command executed and its exit code/output to `~/disk-cleanup-$(date +%F).log`.
7. **Stop on Error**:
   - If any command fails, halt the batch immediately and report the error to the user without guessing or improvising destructive fixes.

---

### Phase 4: Post-Cleanup Verification & Reporting
1. Re-run `df -h / /System/Volumes/Data` to measure before/after disk space.
2. Report actual vs. predicted GB reclaimed.
3. If reclaimed space is less than predicted:
   - Check if APFS local snapshots retain deleted blocks: `tmutil listlocalsnapshots /`.
   - Check if running background processes hold open file descriptors on unlinked files: `lsof +L1 2>/dev/null` or `lsof | grep deleted`.
4. List any declined items so the user can easily reference them in future maintenance passes.

---

## Proactive Smooth Mac Habits
- **Quarterly Cache Reset**: Clear electron caches (`~/Library/Application Support/<App>/Cache`) to maintain snappy app performance and reduce memory pressure.
- **Xcode Pruning**: Regularly purge unavailable simulator instances via `xcrun simctl delete unavailable` and purge old runtime images.
- **Homebrew Maintenance**: Run `brew cleanup -s` after upgrading formulae.
