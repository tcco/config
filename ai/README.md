# AI Skills

This folder contains AI skills for OpenCode (primary), Claude Code, and Codex.

## add-skill

The `add-skill` skill helps you create new AI skills. Use it when you want to teach an AI assistant a new capability or workflow.

### Usage

When you need to create a new skill, invoke the add-skill capability to guide you through the process.

## Symlink Setup

To use these skills with your AI assistants:

```bash
./scripts/link-ai-skills.sh
```

This symlinks `~/.config/opencode/skills`, `~/.claude/skills`, and `~/.codex/skills` to this folder.
