#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
CANONICAL_SKILLS_DIR="$CONFIG_DIR/ai/skills"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

TARGETS=(
  "$HOME/.claude/skills"
  "$HOME/.config/opencode/skills"
  "$HOME/.codex/skills"
)

if [[ ! -d "$CANONICAL_SKILLS_DIR" ]]; then
  echo "[ERROR] Canonical skills directory not found: $CANONICAL_SKILLS_DIR"
  exit 1
fi

for target in "${TARGETS[@]}"; do
  parent_dir="$(dirname "$target")"
  backup_path="$parent_dir/skills.backup-$TIMESTAMP"

  mkdir -p "$parent_dir"

  if [[ -L "$target" ]]; then
    rm -f "$target"
  elif [[ -e "$target" ]]; then
    mv "$target" "$backup_path"
    echo "[INFO] Backed up $target -> $backup_path"
  fi

  ln -s "$CANONICAL_SKILLS_DIR" "$target"
  echo "[OK] $target -> $CANONICAL_SKILLS_DIR"
done

echo "[DONE] AI skills symlinks refreshed."
