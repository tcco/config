# Skill Creation Reference

## Quick Help

To see all available flags and usage examples:
```bash
/add-skill help
/add-skill --help
/add-skill
```

## Complete Frontmatter Field Reference

### name
- **Type**: String
- **Required**: No (defaults to directory name)
- **Format**: lowercase-with-hyphens
- **Max Length**: 64 characters
- **Examples**: `code-review`, `create-pr`, `analyze-performance\[backtick\]

### description
- **Type**: String
- **Required**: Yes (strongly recommended)
- **Purpose**: Claude uses this to determine when to auto-invoke
- **Best Practice**: Be specific about what it does and when to use it
- **Examples**:
  - ✅ "Explains code with visual diagrams and analogies"
  - ✅ "Deploy application to staging or production environments"
  - ❌ "Code tool" (too vague)

### argument-hint
- **Type**: String
- **Required**: No
- **Format**: `[arg1] [arg2]` or `<required> [optional]\[backtick\]
- **Purpose**: Shows in autocomplete to guide users
- **Examples**:
  - `[issue-number]\[backtick\]
  - `[filename] [format]\[backtick\]
  - `<branch-name>\[backtick\]
  - `[--flag] <path>\[backtick\]

### disable-model-invocation
- **Type**: Boolean
- **Default**: false
- **Purpose**: When true, prevents Claude from auto-invoking; user must use `/skill-name\[backtick\]
- **Use When**: Skill has side effects (creates files, commits, deploys, modifies state)
- **Examples**: `/commit`, `/deploy`, `/add-skill`, `/delete-files\[backtick\]

### user-invocable
- **Type**: Boolean
- **Default**: true
- **Purpose**: When false, hides from `/` menu (Claude loads automatically when relevant)
- **Use When**: Skill is background knowledge, reference docs, or context
- **Examples**: coding-standards, api-reference, architecture-guidelines

### allowed-tools
- **Type**: Comma-separated string
- **Default**: All tools require permission
- **Purpose**: Pre-approve tools so Claude doesn't need to ask
- **Available Tools**: Read, Write, Edit, Bash, Grep, Glob, LSP, WebFetch, TodoWrite
- **Patterns**:
  - Read-only: `Read, Grep, Glob, LSP\[backtick\]
  - Modification: `Read, Grep, Bash, Edit, Write, Glob, LSP\[backtick\]
  - Git operations: `Bash, Read\[backtick\]
  - Research: `Read, Grep, Glob, WebFetch\[backtick\]
- **Wildcard Patterns**: `Bash(gh:*)` - only allow bash commands starting with `gh\[backtick\]

### model
- **Type**: String
- **Values**: `sonnet`, `opus`, `haiku\[backtick\]
- **Default**: Inherits from session
- **Purpose**: Override model for this specific skill
- **Use When**:
  - `haiku` - Quick, straightforward tasks (formatting, simple lookups)
  - `sonnet` - Standard tasks (most skills)
  - `opus` - Complex reasoning, critical decisions

### context
- **Type**: String
- **Values**: `fork\[backtick\]
- **Default**: Normal context (access to conversation history)
- **Purpose**: Run skill in isolated subagent without conversation history
- **Use When**: Research, exploration, planning tasks that don't need chat context
- **Requires**: Must also specify `agent` field

### agent
- **Type**: String
- **Values**: `Explore`, `Plan`, `general-purpose\[backtick\]
- **Required When**: `context: fork` is set
- **Purpose**: Determines which specialized subagent runs the skill
- **Agent Types**:
  - `Explore` - Fast exploration, search, codebase understanding
  - `Plan` - Implementation planning, architecture design
  - `general-purpose` - Complex multi-step tasks

## Dynamic Context Injection Syntax

### Basic Usage
```markdown
!\[backtick\]command\[backtick\]
```

The command executes immediately when skill loads. Output replaces the placeholder.

### Safe Patterns

**With error handling**:
```markdown
!\[backtick\]git branch --show-current 2>/dev/null || echo "unknown"\[backtick\]
```

**Conditional output**:
```markdown
!\[backtick\]gh pr view 2>/dev/null || echo "No PR found"\[backtick\]
```

**Multiple commands**:
```markdown
!\[backtick\]git status --short && git diff --stat\[backtick\]
```

### Common Use Cases

**Git information**:
```markdown
- Current branch: !\[backtick\]git rev-parse --abbrev-ref HEAD\[backtick\]
- Remote URL: !\[backtick\]git remote get-url origin 2>/dev/null || echo "none"\[backtick\]
- Recent commits: !\[backtick\]git log -5 --oneline\[backtick\]
- Uncommitted changes: !\[backtick\]git status --short || echo "none"\[backtick\]
```

**GitHub PR info**:
```markdown
!\[backtick\]gh pr view --json number,title,body,author 2>/dev/null || echo "No PR"\[backtick\]
```

**Project detection**:
```markdown
- Package manager: !\[backtick\][ -f package.json ] && echo "npm" || [ -f Cargo.toml ] && echo "cargo" || echo "unknown"\[backtick\]
```

**Environment info**:
```markdown
- Node version: !\[backtick\]node --version 2>/dev/null || echo "not installed"\[backtick\]
- Python version: !\[backtick\]python3 --version 2>/dev/null || echo "not installed"\[backtick\]
```

## String Substitution

### $ARGUMENTS

**Purpose**: Insert user-provided arguments into skill instructions

**Placement**:
```markdown
<!-- Option 1: Explicit placement (recommended) -->
Process the following: $ARGUMENTS

<!-- Option 2: Auto-append (default if not included) -->
<!-- Arguments automatically appear at end -->
```

**With default values**:
```markdown
Target: ${ARGUMENTS:-main}  <!-- Use "main" if no args provided -->
```

### ${CLAUDE_SESSION_ID}

**Purpose**: Current session identifier for logging/correlation

**Usage**:
```markdown
Log file: /tmp/skill-${CLAUDE_SESSION_ID}.log
```

## File Organization Patterns

### Minimal Skill (< 100 lines)
```
skill-name/
└── SKILL.md
```

### Standard Skill (100-500 lines)
```
skill-name/
├── SKILL.md      # Main instructions
└── examples.md   # Usage examples
```

### Complex Skill (> 500 lines)
```
skill-name/
├── SKILL.md         # Overview and navigation
├── reference.md     # Detailed technical reference
├── examples.md      # Usage examples
├── template.md      # Output template
└── scripts/
    └── helper.sh    # Helper scripts
```

### Reference Pattern in SKILL.md
```markdown
## Additional Resources

For complete API details, see [reference.md](reference.md).
For usage examples, see [examples.md](examples.md).

Claude will automatically load these files when referenced.
```

## Validation Checklist

### YAML Frontmatter
- [ ] Valid YAML syntax (colons, quotes, spacing)
- [ ] name: lowercase-with-hyphens, < 64 chars
- [ ] description: clear, specific purpose
- [ ] argument-hint: matches actual usage (if applicable)
- [ ] disable-model-invocation: appropriate for side effects
- [ ] user-invocable: appropriate for skill type
- [ ] allowed-tools: sufficient for task
- [ ] context/agent: paired correctly if forking

### Content Structure
- [ ] Clear opening statement (role, goal)
- [ ] $ARGUMENTS used if hints provided
- [ ] Dynamic injection uses safe error handling
- [ ] Steps are actionable and specific
- [ ] Output format is defined
- [ ] Constraints/reminders included

### File Organization
- [ ] Directory name matches skill name
- [ ] Supporting files referenced if created
- [ ] No orphaned files
- [ ] README included (optional but helpful)

### Naming Conventions
- [ ] skill-name not skillName or skill_name
- [ ] Descriptive and specific
- [ ] Avoids reserved prefixes (claude-, anthropic-)
- [ ] Under 64 characters

### Logic & Safety
- [ ] Side effects have disable-model-invocation: true
- [ ] Forked context has agent specified
- [ ] Tools are restricted appropriately
- [ ] Shell commands won't fail catastrophically
- [ ] No exposed secrets or credentials

## Common Patterns by Use Case

### Code Review Skill
```yaml
---
name: code-review
description: Review code changes for quality, security, and best practices
disable-model-invocation: true
allowed-tools: Read, Grep, Bash, Glob
---

## Changes
!\[backtick\]git diff --stat\[backtick\]

Review criteria...
```

### Deployment Skill
```yaml
---
name: deploy
description: Deploy application to specified environment
argument-hint: <environment>
disable-model-invocation: true
allowed-tools: Bash, Read
---

Deploy to: $ARGUMENTS

Deployment steps...
```

### Exploration Skill
```yaml
---
name: find-pattern
description: Search codebase for specific patterns or usage
argument-hint: <pattern>
context: fork
agent: Explore
allowed-tools: Grep, Glob, Read
---

Search for: $ARGUMENTS

Search strategy...
```

### Background Knowledge Skill
```yaml
---
name: coding-standards
description: Coding standards and best practices for this project
user-invocable: false
---

Follow these standards when writing code:
[Guidelines...]
```

### Planning Skill
```yaml
---
name: plan-feature
description: Plan implementation strategy for a new feature
argument-hint: <feature description>
context: fork
agent: Plan
allowed-tools: Read, Grep, Glob
---

Plan implementation for: $ARGUMENTS

Planning approach...
```

## Troubleshooting

### Skill Not Appearing
- Check YAML frontmatter is valid
- Ensure directory name is valid (lowercase, hyphens)
- Verify file is named `SKILL.md` exactly
- Run `/context` to check char budget

### Skill Triggering Incorrectly
- Make description more specific
- Add `disable-model-invocation: true` for manual-only
- Adjust description to be less generic

### Arguments Not Working
- Include `$ARGUMENTS` in SKILL.md
- Check argument-hint matches expected format
- Verify substitution is in correct location

### Dynamic Injection Failing
- Add error handling: `command 2>/dev/null || echo "fallback"\[backtick\]
- Check command is available in environment
- Test command manually in terminal first

### Context Fork Issues
- Ensure `agent` field is specified
- Verify agent type is valid (Explore, Plan, general-purpose)
- Check that forked context is appropriate (no need for chat history)
