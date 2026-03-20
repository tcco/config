---
name: add-skill
description: Create a new Claude Code skill with optimal configuration and all best practices
argument-hint: <description> [--flags] | help
disable-model-invocation: true
allowed-tools: Read, Grep, Bash, Write, Glob, WebFetch
---

You are an expert Claude Code skill architect. Your goal is to create production-ready, optimally configured skills that follow all best practices and leverage the full feature set of the Claude Code skills system.

## User Request

**Skill Requirements**: $ARGUMENTS

---

## Quick Reference: Available Flags

**Show this help if $ARGUMENTS is empty, "help", or "--help":**

### Usage
```
/add-skill <description> [flags]
/add-skill help
```

### Scope Flags
- `--global` - Create in ~/dotfiles/ai/skills/ (default shared global location)
- `--project` - Create in .claude/skills/ (current project only)

### Invocation Flags
- `--auto-invoke` - Allow Claude to auto-invoke (override auto-detection)
- `--manual-only` - Require manual /skill-name invocation (override auto-detection)

### Context Flags
- `--fork` - Run in isolated forked context (override auto-detection)
- `--agent=<type>` - Specify agent type: Explore, Plan, general-purpose
- `--read-only` - Restrict to read-only tools (Read, Grep, Glob)

### Supporting Files Flags
- `--reference` - Force create reference.md
- `--examples` - Force create examples.md
- `--template` - Force create template.md

### Examples
```bash
/add-skill Create a skill for deploying to production
/add-skill Generate API docs from TypeScript --project
/add-skill Analyze codebase architecture --fork --agent=Explore
/add-skill Format code with prettier --manual-only --read-only
```

**If help was requested, stop here and show only the above reference. Otherwise, continue with skill creation.**

---

## Skills System Reference

### Core Principles

Skills extend Claude's capabilities through custom slash commands. They follow the Agent Skills open standard with Claude Code extensions.

**Directory Structure**:
```
skill-name/
├── SKILL.md           # Required: main instructions
├── reference.md       # Optional: detailed documentation
├── examples.md        # Optional: usage examples
├── template.md        # Optional: template for Claude to fill
└── scripts/           # Optional: executable helper scripts
```

**Storage Locations**:
- **Global**: `~/dotfiles/ai/skills/<skill-name>/` (all projects, shared across Claude Code, OpenCode, and Codex in this setup)
- **Project**: `.claude/skills/<skill-name>/` (current project only, use `--project` flag)

### YAML Frontmatter Fields

Every `SKILL.md` requires frontmatter. All fields:

```yaml
---
name: skill-name                          # Lowercase, hyphens, max 64 chars (defaults to directory name)
description: What it does and when        # CRITICAL: Claude uses this for auto-invocation
argument-hint: [arg1] [arg2]             # Autocomplete hint
disable-model-invocation: true|false     # true = manual /cmd only, false = Claude can auto-invoke
user-invocable: true|false               # false = hidden from / menu (background knowledge)
allowed-tools: Read, Grep, Bash          # Tools Claude can use without permission
model: sonnet|opus|haiku                 # Override model for this skill
context: fork                            # Run in isolated subagent (no conversation history)
agent: Explore|Plan|general-purpose      # Subagent type when context: fork
---
```

### String Substitutions

- `$ARGUMENTS` - Arguments passed when invoking (include explicitly or they append at end)
- `${CLAUDE_SESSION_ID}` - Current session ID

### Dynamic Context Injection

Use the pattern `![backtick]command[backtick]` to run shell commands before sending to Claude:

**Example format**:
```
Current branch: ![backtick]git branch --show-current[backtick]
Recent commits: ![backtick]git log -5 --oneline[backtick]
```

Commands execute immediately; output replaces the placeholder.

**Note**: Replace `[backtick]` with actual backtick characters (`) when writing skills.

### Invocation Patterns

**User-only (disable auto)**: Side-effect actions like deploy, commit, creating files
```yaml
disable-model-invocation: true
```

**Claude-only (hide from menu)**: Background knowledge, reference docs
```yaml
user-invocable: false
```

**Read-only mode**: Restrict tools for safety
```yaml
allowed-tools: Read, Grep, Glob
```

### Forked Context Pattern

Run in isolated subagent for research/exploration:
```yaml
context: fork
agent: Explore
```

- No access to conversation history
- Skill content becomes subagent task
- Results summarized and returned

### Best Practices

1. **Clear descriptions**: Claude recognizes when skill is relevant
2. **Use $ARGUMENTS explicitly**: Better control over argument placement
3. **Supporting files for large skills**: Keep SKILL.md < 500 lines, reference others
4. **Restrict tools for side effects**: Use allowed-tools to limit scope
5. **Dynamic injection for context**: Fetch git, PR, or system info automatically

## Skill Creation Process

### 1. Analyze Request

Parse `$ARGUMENTS` to understand:
- **Purpose**: What does the skill do?
- **Scope**: Narrow task or broad capability?
- **Invocation**: User-triggered, Claude-triggered, or both?
- **Side effects**: Does it modify files, run commands, deploy, etc.?
- **Context needs**: Requires conversation history or isolated?
- **Arguments**: Does it need parameters?
- **Tech stack**: Language/framework specific?

### 2. Determine Skill Type & Settings

**Auto-detect and set:**

#### Invocation Control
- **Side-effect actions** (create files, commit, deploy, modify state):
  - Set `disable-model-invocation: true`
  - User must explicitly invoke with `/skill-name`
  - Examples: /commit, /deploy, /add-skill, /cleanup

- **Background knowledge** (reference docs, guidelines, context):
  - Set `user-invocable: false`
  - Claude auto-loads when relevant
  - Examples: coding-standards, architecture-guide, api-reference

- **Research/analysis** (no side effects, informational):
  - Allow both invocation methods (default)
  - Examples: /explain-code, /find-bugs, /analyze-performance

#### Context & Execution
- **Exploration/search tasks** across codebase:
  - Set `context: fork` with `agent: Explore`
  - Examples: understanding architecture, finding patterns, research

- **Planning tasks**:
  - Set `context: fork` with `agent: Plan`
  - Examples: designing implementation strategy

- **Standard execution**: No context forking (default)

#### Tool Restrictions
- **Read-only skills** (no modifications):
  - Set `allowed-tools: Read, Grep, Glob, LSP`
  - Examples: code review, analysis, explanation

- **Modification skills**:
  - Set `allowed-tools: Read, Grep, Bash, Edit, Write, Glob, LSP`
  - Examples: refactoring, creating files, running commands

- **Command-heavy skills**:
  - Set `allowed-tools: Bash, Read`
  - Examples: git operations, deployment, testing

### 3. Structure SKILL.md

**Template structure:**

```markdown
---
[frontmatter fields]
---

[Opening statement: role, goal, context]

## User Request / Arguments

**[Context for what to process]**: $ARGUMENTS

---

## Quick Reference: [If skill has flags/options]

**Show this help if $ARGUMENTS is empty, "help", or "--help":**

### Usage
```
/skill-name <args> [options]
/skill-name help
```

### [Document any flags, options, or argument patterns]

**If help was requested, stop here. Otherwise, continue.**

---

## [Dynamic context injection if needed]
[Use the pattern: exclamation-backtick-command-backtick to inject shell output]
[Example: Current branch: exclamation-backtick git branch --show-current backtick]

## [Core instructions]

### Step 1: [Action]
[Detailed guidance]

### Step 2: [Action]
[Detailed guidance]

## [Output format/expectations]

## [Best practices/reminders]
```

**Content guidelines:**
- Start with role and goal (e.g., "You are an expert X. Your goal is to Y.")
- Use `$ARGUMENTS` explicitly where inputs are needed
- **If the skill accepts arguments with flags/options**, add a "Quick Reference" help section that displays when user invokes with no args, "help", or "--help"
- **Help section should include**:
  - Usage examples
  - Available flags/options with descriptions
  - Common usage patterns
  - Clear instruction to stop if help was requested
- Include dynamic context injection for git/system info when relevant
- Structure steps clearly with headers
- Provide output format expectations
- Include reminders of key constraints
- Keep SKILL.md focused (< 500 lines) - use supporting files for large content

**Help Section Criteria:**
Add help section if ANY of these apply:
- Skill accepts multiple argument patterns (e.g., file path, URL, or pattern)
- Skill has optional flags (--flag-name)
- Skill behavior changes based on argument format
- Arguments have specific format requirements
- Multiple ways to invoke the skill

Skip help section if:
- Skill has no arguments
- Skill has single, simple argument (just a value, no options)
- Usage is self-explanatory from argument-hint

### 4. Determine Supporting Files

**Create supporting files if:**

- **reference.md**: Skill instructions > 400 lines OR requires detailed API/technical docs
- **examples.md**: Skill is complex enough to benefit from usage examples
- **template.md**: Skill generates structured output (reports, configs, documents)
- **scripts/**: Skill needs helper scripts for preprocessing or complex operations

**Reference from SKILL.md:**
```markdown
For complete API details, see [reference.md](reference.md)
For usage examples, see [examples.md](examples.md)
```

### 5. Generate Skill Files

Create the skill with:
1. **Directory**: `~/dotfiles/ai/skills/<skill-name>/` (or project if `--project` flag detected)
2. **SKILL.md**: Complete with frontmatter + instructions
3. **Supporting files**: If complexity warrants (see step 4)
4. **README**: Brief overview for user reference (optional)

**Naming conventions:**
- Use lowercase with hyphens: `code-review`, `create-pr`, `analyze-deps`
- Max 64 characters
- Be specific: `review-pr` not just `review`
- Avoid Claude- prefixes (reserved)

### 6. Validate Generated Skill

Run these checks:

1. **YAML frontmatter syntax**:
   - Valid YAML
   - Required fields present (name, description)
   - Field values are correct types

2. **Arguments handling**:
   - If `argument-hint` exists, verify `$ARGUMENTS` is used in content
   - Check argument placement makes sense
   - If skill has flags/options, verify help section is included
   - Help section should handle empty args, "help", and "--help"

3. **File references**:
   - Any markdown links reference existing files
   - Supporting files are created if referenced

4. **Naming conventions**:
   - Directory name is lowercase-with-hyphens
   - Name matches directory name (or uses directory name as default)
   - Max 64 characters

5. **Logic consistency**:
   - If `disable-model-invocation: true`, description is still clear for user
   - If `user-invocable: false`, description is optimized for Claude recognition
   - If `context: fork`, agent type is specified
   - If side effects, appropriate warnings included

6. **Dynamic context**:
   - Shell commands in dynamic injection patterns are safe and won't fail badly
   - Commands handle errors with `|| echo "fallback"` or `2>/dev/null`

### 7. Present Results

After creation, provide:

1. **Summary**:
   - Skill name and location
   - Purpose and invocation method
   - Key configuration choices made

2. **Usage**:
   - How to invoke the skill
   - Example arguments
   - Expected behavior

3. **Files Created**:
   - List all files with brief descriptions
   - Note any supporting files

4. **Next Steps**:
   - Suggest testing the skill
   - Mention any customization opportunities
   - Note if user should edit any sections

5. **Validation Results**:
   - Confirm all checks passed
   - Note any warnings or optional improvements

## Special Flags & Arguments

Parse these special flags from `$ARGUMENTS`:

- `--project`: Create in `.claude/skills/` instead of `~/dotfiles/ai/skills/`
- `--global`: Explicitly create in `~/dotfiles/ai/skills/` (default, for clarity)
- `--auto-invoke`: Override auto-detection, allow Claude to auto-invoke
- `--manual-only`: Override auto-detection, require manual invocation
- `--fork`: Override auto-detection, use forked context
- `--agent=<type>`: Specify agent type (Explore, Plan, general-purpose)
- `--read-only`: Override auto-detection, restrict to read-only tools
- `--reference`: Force creation of reference.md
- `--examples`: Force creation of examples.md
- `--template`: Force creation of template.md

**Example**:
```
/add-skill Create a skill for deploying to production --project --manual-only
```

## Example Skill Patterns

### Pattern 1: Side-Effect Action (File Creation/Modification)
```yaml
---
name: cleanup-code
description: Remove unused imports, variables, and dead code
disable-model-invocation: true
allowed-tools: Read, Grep, Bash, Edit, Write, Glob
---

You are a code cleanup specialist...
$ARGUMENTS

[Steps to safely cleanup code]
```

### Pattern 2: Research/Exploration Task
```yaml
---
name: find-api-usage
description: Find all usages of a specific API or function across the codebase
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob
---

Find all usages of: $ARGUMENTS

[Steps to search and analyze]
```

### Pattern 3: Background Knowledge
```yaml
---
name: api-conventions
description: API design and naming conventions for this codebase
user-invocable: false
---

When designing APIs in this codebase:
[Guidelines and conventions]
```

### Pattern 4: Git Operation
```yaml
---
name: sync-branch
description: Sync current branch with main and resolve conflicts
disable-model-invocation: true
allowed-tools: Bash, Read
---

## Current Branch Info
[Dynamic: git branch --show-current]

## Status
[Dynamic: git status --short]

[Steps to sync safely]
```

## Implementation Checklist

Before completing, verify:

- [ ] Skill purpose is clearly understood from user input
- [ ] Skill type correctly identified (user/claude/both invocation)
- [ ] Settings auto-detected based on skill type
- [ ] YAML frontmatter includes all relevant fields
- [ ] `$ARGUMENTS` placeholder used appropriately
- [ ] Help documentation included if skill has flags/options/multiple commands
- [ ] argument-hint includes "| help" if help section exists
- [ ] Dynamic context injection added where beneficial
- [ ] Tool restrictions appropriate for the task
- [ ] Supporting files created if complexity warrants
- [ ] Directory and file names follow conventions
- [ ] All validation checks pass
- [ ] Clear usage instructions provided to user
- [ ] Skill follows all best practices from documentation

## Remember

- **Be opinionated**: Make smart choices based on skill type
- **Use all features**: Dynamic injection, forked context, tool restrictions, supporting files, help documentation
- **Optimize for UX**: Clear descriptions, helpful argument hints, proper invocation control, self-documenting help
- **Validate thoroughly**: Catch issues before user tries to use the skill
- **Explain choices**: Help user understand why you configured things a certain way
