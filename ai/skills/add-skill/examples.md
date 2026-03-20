# Skill Creation Examples

## Getting Help

**Show available flags**:
```bash
/add-skill help
# or
/add-skill --help
# or
/add-skill
```

This displays all available flags and usage examples without creating a skill.

---

## Example 1: Simple Code Formatting Skill

**User Request**:
```
/add-skill Create a skill that formats code files using prettier for TypeScript/JavaScript projects
```

**Generated Skill**:

**Location**: `~/dotfiles/ai/skills/format-code/SKILL.md\[backtick\]

```yaml
---
name: format-code
description: Format code files using prettier for consistent styling
argument-hint: [file-pattern]
disable-model-invocation: true
allowed-tools: Bash, Read, Glob
---

You are a code formatting specialist. Your goal is to format code files consistently using prettier.

## Target Files

Format the following: ${ARGUMENTS:-.}

## Execution Steps

1. **Detect prettier configuration**:
   - Check for .prettierrc, .prettierrc.json, prettier.config.js
   - If none found, use default configuration

2. **Identify files to format**:
   - If argument is a directory, find all JS/TS files
   - If argument is a file pattern, use it directly
   - If no argument, format changed files: `git diff --name-only --diff-filter=ACMRTUXB "*.{js,jsx,ts,tsx}"\[backtick\]

3. **Run prettier**:
   ```bash
   npx prettier --write [files]
   ```

4. **Report results**:
   - Number of files formatted
   - Any errors encountered
   - Git status if applicable

## Safety

- Only format files in current project
- Never format node_modules or dist directories
- Preserve git history
```

**Usage**:
```bash
/format-code src/              # Format entire src directory
/format-code src/utils/*.ts    # Format specific pattern
/format-code                   # Format changed files
```

---

## Example 2: API Documentation Generator

**User Request**:
```
/add-skill I need a skill that generates API documentation from TypeScript types and JSDoc comments. It should create markdown files with endpoints, request/response types, and examples.
```

**Generated Skill**:

**Location**: `~/dotfiles/ai/skills/generate-api-docs/\[backtick\]

**Files**:
- `SKILL.md` - Main instructions
- `template.md` - API doc template
- `examples.md` - Example outputs

**SKILL.md**:
```yaml
---
name: generate-api-docs
description: Generate API documentation from TypeScript types and JSDoc comments
argument-hint: [api-directory]
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Write, LSP
---

You are an API documentation specialist. Generate comprehensive, accurate API documentation from TypeScript source code.

## Source Directory

Document APIs from: ${ARGUMENTS:-src/api}

## Documentation Process

### 1. Discover API Files

Search for API routes, controllers, handlers:
- Files matching: `**/*{route,controller,handler,api}*.ts\[backtick\]
- Files with `@api` or `@endpoint` JSDoc tags
- Express/Fastify route definitions

### 2. Extract API Information

For each endpoint, extract:
- HTTP method (GET, POST, PUT, DELETE, etc.)
- Route path
- Request parameters (path, query, body)
- Response types
- Status codes
- Authentication requirements
- JSDoc description and examples

Use LSP tool to get type information for complex types.

### 3. Generate Documentation

Use [template.md](template.md) to structure each endpoint's documentation.

Create one markdown file per API module:
- `docs/api/{module-name}.md\[backtick\]

Include:
- Overview of the module
- Authentication requirements
- Base URL
- Endpoint list with methods
- Detailed endpoint documentation
- Request/response examples
- Error handling

### 4. Create Index

Generate `docs/api/README.md` with:
- Table of contents
- Getting started guide
- Authentication overview
- Links to all module docs

## Output Format

See [template.md](template.md) for detailed structure.

## Remember

- Extract real types, don't invent them
- Include actual examples from tests if available
- Note deprecated endpoints
- Document error responses
- Link related endpoints
```

**template.md**:
```markdown
# {Module Name} API

## Overview

{Brief description of this API module}

## Base URL

\`\`\\[backtick\]
{base-url}
\`\`\\[backtick\]

## Authentication

{Authentication requirements: Bearer token, API key, etc.}

## Endpoints

{List of endpoints with brief descriptions}

---

## {Method} {Path}

{Detailed endpoint description}

### Request

**Parameters:**

| Name | Type | Location | Required | Description |
|------|------|----------|----------|-------------|
| {param} | {type} | {path/query/body} | {yes/no} | {description} |

**Body:**

\`\`\`typescript
{request-type}
\`\`\\[backtick\]

### Response

**Success (200):**

\`\`\`typescript
{response-type}
\`\`\\[backtick\]

**Example:**

\`\`\`json
{example-response}
\`\`\\[backtick\]

### Errors

| Status | Description |
|--------|-------------|
| 400 | {Bad request description} |
| 401 | {Unauthorized description} |
| 404 | {Not found description} |

### Example Request

\`\`\`bash
curl -X {METHOD} \\
  {base-url}{path} \\
  -H "Authorization: Bearer {token}" \\
  -H "Content-Type: application/json" \\
  -d '{example-body}'
\`\`\\[backtick\]

---
```

**Usage**:
```bash
/generate-api-docs src/api      # Document API directory
/generate-api-docs             # Document default src/api
```

---

## Example 3: Dependency Analyzer

**User Request**:
```
/add-skill Analyze project dependencies for security vulnerabilities, outdated packages, and unused dependencies --read-only
```

**Generated Skill**:

**Location**: `~/dotfiles/ai/skills/analyze-deps/SKILL.md\[backtick\]

```yaml
---
name: analyze-deps
description: Analyze dependencies for security issues, outdated packages, and unused imports
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob, Bash
---

You are a dependency security and maintenance specialist. Analyze project dependencies for issues.

## Project Information

- **Package file**: !\[backtick\][ -f package.json ] && echo "package.json" || [ -f Cargo.toml ] && echo "Cargo.toml" || [ -f requirements.txt ] && echo "requirements.txt" || echo "unknown"\[backtick\]
- **Lock file**: !\[backtick\][ -f package-lock.json ] && echo "package-lock.json" || [ -f yarn.lock ] && echo "yarn.lock" || [ -f Cargo.lock ] && echo "Cargo.lock" || echo "none"\[backtick\]

## Analysis Tasks

### 1. Security Vulnerabilities

Run security audit:
- **npm**: `npm audit --json\[backtick\]
- **yarn**: `yarn audit --json\[backtick\]
- **cargo**: `cargo audit\[backtick\]
- **pip**: `pip-audit` or `safety check\[backtick\]

Report:
- Critical vulnerabilities (CVSS >= 9.0)
- High vulnerabilities (CVSS >= 7.0)
- Available fixes
- Required actions

### 2. Outdated Packages

Check for updates:
- **npm**: `npm outdated --json\[backtick\]
- **yarn**: `yarn outdated --json\[backtick\]
- **cargo**: `cargo outdated\[backtick\]
- **pip**: `pip list --outdated\[backtick\]

Report:
- Major version updates available
- Minor/patch updates available
- Breaking change risks
- Recommended update strategy

### 3. Unused Dependencies

Search codebase for actual usage:
- Read all source files
- Search for import/require statements
- Check against declared dependencies
- Identify unused packages

Report:
- Dependencies in package.json but never imported
- devDependencies that should be dependencies
- Dependencies that should be devDependencies
- Estimated size savings from removal

### 4. Dependency Health

Analyze each dependency:
- Maintenance status (last update, activity)
- Known security history
- License compatibility
- Bundle size impact
- Alternative suggestions

## Report Format

### Executive Summary
- Total dependencies: X
- Critical issues: Y
- Recommended actions: Z

### Security Issues (Critical First)
| Package | Version | Severity | CVE | Fix Available |
|---------|---------|----------|-----|---------------|
| ... | ... | ... | ... | ... |

### Outdated Packages
| Package | Current | Latest | Type | Breaking |
|---------|---------|--------|------|----------|
| ... | ... | ... | ... | ... |

### Unused Dependencies
| Package | Type | Size | Safe to Remove |
|---------|------|------|----------------|
| ... | ... | ... | ... |

### Recommendations

1. **Immediate Actions** (security critical)
2. **Short-term** (outdated major versions)
3. **Maintenance** (cleanup, minor updates)
4. **Long-term** (architecture improvements)

## Remember

- This is read-only analysis, make no changes
- Flag breaking changes clearly
- Consider transitive dependencies
- Note any deprecated packages
- Provide actionable recommendations
```

**Usage**:
```bash
/analyze-deps    # Analyze current project
```

---

## Example 4: Git Commit Convention Enforcer

**User Request**:
```
/add-skill Background knowledge skill for commit message conventions following Conventional Commits format
```

**Generated Skill**:

**Location**: `~/dotfiles/ai/skills/commit-conventions/SKILL.md\[backtick\]

```yaml
---
name: commit-conventions
description: Conventional Commits format guidelines for consistent commit messages
user-invocable: false
---

When creating commit messages in this project, always follow the Conventional Commits specification:

## Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Type (Required)

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation only
- **style**: Formatting, missing semi colons, etc; no code change
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **perf**: Performance improvement
- **test**: Adding tests
- **chore**: Maintain, config, dependencies, etc
- **ci**: CI/CD changes
- **build**: Build system changes

## Scope (Optional)

Component or module affected:
- `feat(auth): add OAuth support\[backtick\]
- `fix(api): handle null responses\[backtick\]
- `docs(readme): update installation steps\[backtick\]

## Subject (Required)

- Imperative mood: "add feature" not "added feature"
- No capitalization of first letter
- No period at the end
- Max 50 characters

## Body (Optional)

- Explain *what* and *why*, not *how*
- Wrap at 72 characters
- Separate from subject with blank line

## Footer (Optional)

- Breaking changes: `BREAKING CHANGE: description\[backtick\]
- Issue references: `Closes #123`, `Fixes #456\[backtick\]
- Co-authors: `Co-authored-by: Name <email>\[backtick\]

## Examples

### Feature
```
feat(search): add fuzzy search algorithm

Implement fuzzy search using Levenshtein distance for better
user experience when searching products.

Closes #234
```

### Bug Fix
```
fix(cart): prevent duplicate items

Adds check for existing items before adding to cart to prevent
duplicate entries that caused checkout errors.

Fixes #567
```

### Breaking Change
```
refactor(api)!: remove deprecated endpoints

BREAKING CHANGE: Removed /api/v1/old-endpoint. Use /api/v2/endpoint instead.

Migration guide: docs/migration-v2.md
```

### Simple Commit
```
docs: fix typo in README
```

## Validation Rules

- Type is always lowercase
- Scope is lowercase (optional)
- Subject is lowercase, imperative, < 50 chars
- Body wraps at 72 chars (if present)
- Footer has proper format (if present)
- Breaking changes marked with `!\[backtick\] after type/scope or in footer

When generating commits, always validate against these rules.
```

**Usage**:
This skill is automatically loaded when relevant (e.g., when user asks to create commits). User cannot invoke manually since `user-invocable: false`.

---

## Example 5: Test Generator

**User Request**:
```
/add-skill Create tests for TypeScript functions - should generate Jest tests with proper mocking, edge cases, and coverage
```

**Generated Skill**:

**Location**: `~/dotfiles/ai/skills/generate-tests/\[backtick\]

**Files**:
- `SKILL.md` - Main instructions
- `template.md` - Test template
- `examples.md` - Test examples

**SKILL.md**:
```yaml
---
name: generate-tests
description: Generate comprehensive Jest tests for TypeScript functions with mocking and edge cases
argument-hint: <file-path>
disable-model-invocation: true
allowed-tools: Read, Write, Grep, Glob, LSP
model: sonnet
---

You are a test engineering specialist. Generate comprehensive, maintainable tests with high coverage.

## Target Function

Generate tests for: $ARGUMENTS

## Test Generation Process

### 1. Analyze Function

Read the source file and analyze:
- Function signature (parameters, return type)
- Dependencies (imports, external calls)
- Logic paths (conditions, loops, exceptions)
- Side effects (API calls, state mutations, file I/O)
- Edge cases (null, undefined, empty, boundary values)

Use LSP tool for type information.

### 2. Identify Test Cases

Categorize test cases:

**Happy Path**:
- Normal inputs
- Expected behavior
- Successful returns

**Edge Cases**:
- Null/undefined inputs
- Empty collections
- Boundary values (min, max)
- Zero, negative numbers
- Very large inputs

**Error Cases**:
- Invalid inputs
- Type mismatches
- Exceptions thrown
- Async rejections

**Integration**:
- External dependencies
- API calls
- Database operations

### 3. Generate Test Suite

Structure using [template.md](template.md):

```typescript
describe('functionName', () => {
  // Setup
  beforeEach(() => {
    // Reset mocks, state
  });

  afterEach(() => {
    // Cleanup
  });

  describe('Happy Path', () => {
    it('should [expected behavior]', () => {
      // Test
    });
  });

  describe('Edge Cases', () => {
    it('should handle null input', () => {
      // Test
    });
  });

  describe('Error Handling', () => {
    it('should throw error when [condition]', () => {
      // Test
    });
  });

  describe('Integration', () => {
    it('should call [dependency]', () => {
      // Mock and verify
    });
  });
});
```

### 4. Mock Dependencies

For external dependencies:
- **Modules**: `jest.mock('./module')\[backtick\]
- **Functions**: `jest.fn()\[backtick\]
- **APIs**: Mock with jest-fetch-mock or MSW
- **Timers**: `jest.useFakeTimers()\[backtick\]
- **Random**: `jest.spyOn(Math, 'random')\[backtick\]

### 5. Write Assertions

Use appropriate matchers:
- `toBe()` - Primitive equality
- `toEqual()` - Deep equality
- `toThrow()` - Exception checking
- `toHaveBeenCalledWith()` - Mock verification
- `resolves/rejects` - Async testing

### 6. Calculate Coverage

Ensure test coverage:
- All branches covered
- All edge cases handled
- All error paths tested
- Mock verification complete

## Output

Generate test file at: `{source-path}.test.ts` or `__tests__/{source-file}.test.ts\[backtick\]

Include:
- All necessary imports
- Mock setup
- Complete test suite
- Coverage comments

## Best Practices

- One assertion per test (where reasonable)
- Clear test names describing behavior
- Arrange-Act-Assert pattern
- Independent tests (no shared state)
- Fast execution (mock slow operations)
- Deterministic (no random values)

## Example

See [examples.md](examples.md) for complete examples.
```

**Usage**:
```bash
/generate-tests src/utils/calculateTotal.ts
/generate-tests src/api/userController.ts
```

---

## Example 6: Simple Alias Skill

**User Request**:
```
/add-skill Quick skill that just runs git status with pretty formatting --manual-only
```

**Generated Skill**:

**Location**: `~/dotfiles/ai/skills/gs/SKILL.md\[backtick\]

```yaml
---
name: gs
description: Show git status with pretty formatting
disable-model-invocation: true
allowed-tools: Bash
model: haiku
---

Run git status with clear formatting:

```bash
git status --short --branch
```

Then provide a summary:
- Current branch
- Commits ahead/behind
- Number of changes by type (modified, added, deleted)
- Untracked files
```

**Usage**:
```bash
/gs
```

---

## Example 7: Skill with Help Documentation

**User Request**:
```
/add-skill Create a skill that runs database migrations with various options like --up, --down, --rollback, --seed, etc.
```

**Generated Skill**:

**Location**: `~/dotfiles/ai/skills/db-migrate/SKILL.md\[backtick\]

```yaml
---
name: db-migrate
description: Run database migrations with support for up, down, rollback, and seeding
argument-hint: [command] [--flags] | help
disable-model-invocation: true
allowed-tools: Bash, Read, Grep, Glob
---

You are a database migration specialist. Safely execute migration commands with proper validation.

## Migration Request

**Command**: $ARGUMENTS

---

## Quick Reference: Available Commands

**Show this help if $ARGUMENTS is empty, "help", or "--help":**

### Usage
```
/db-migrate <command> [options]
/db-migrate help
```

### Commands

**Migration Commands**:
- `up` - Run pending migrations
- `down` - Rollback last migration batch
- `rollback [n]` - Rollback last n batches (default: 1)
- `reset` - Rollback all migrations
- `refresh` - Reset and re-run all migrations
- `fresh` - Drop all tables and re-run migrations

**Data Commands**:
- `seed` - Run database seeders
- `seed [seeder]` - Run specific seeder

**Info Commands**:
- `status` - Show migration status
- `list` - List all migrations

### Options
- `--env=<env>` - Target environment (default: development)
- `--dry-run` - Show what would happen without executing
- `--force` - Skip confirmation prompts (use with caution)
- `--verbose` - Show detailed output

### Examples
```bash
/db-migrate status                    # Check migration status
/db-migrate up                        # Run pending migrations
/db-migrate rollback 2                # Rollback last 2 batches
/db-migrate refresh --env=staging    # Reset staging database
/db-migrate seed UserSeeder          # Run specific seeder
/db-migrate up --dry-run             # Preview migrations
```

### Safety Notes
- `reset`, `refresh`, `fresh` are destructive operations
- Always backup production data before migrations
- Use `--dry-run` to preview changes
- `--force` bypasses safety prompts (use carefully)

**If help was requested, stop here and show only the above reference. Otherwise, continue with migration execution.**

---

## Current Environment

- **Database**: !\[backtick\]grep -E "DB_CONNECTION|DB_DATABASE" .env 2>/dev/null | head -2 || echo "Could not detect database config"\[backtick\]
- **Environment**: !\[backtick\]echo ${NODE_ENV:-development}\[backtick\]
- **Migration tool**: !\[backtick\][ -f package.json ] && (grep -q "knex" package.json && echo "knex" || grep -q "sequelize" package.json && echo "sequelize" || echo "unknown") || echo "unknown"\[backtick\]

## Execution Process

### 1. Parse Command

Extract from $ARGUMENTS:
- Command (up, down, rollback, seed, etc.)
- Arguments (number for rollback, seeder name, etc.)
- Flags (--env, --dry-run, --force, --verbose)

### 2. Validate Command

Check:
- Command is valid
- Required tools are available (knex, sequelize-cli, etc.)
- Database connection is configured
- Environment is appropriate for destructive operations

### 3. Safety Checks

**For destructive commands** (reset, refresh, fresh):
- Verify environment is not production (unless --force)
- Warn user about data loss
- Require explicit confirmation (unless --force)
- Suggest backup if production

**For all commands**:
- Check if .env file exists
- Verify database credentials
- Ensure migration files exist

### 4. Execute Migration

Run the appropriate command:

**Knex**:
```bash
npx knex migrate:<command> [--env=<env>]
```

**Sequelize**:
```bash
npx sequelize-cli db:migrate:<command> [--env=<env>]
```

**Prisma**:
```bash
npx prisma migrate <command>
```

Include flags as appropriate:
- `--dry-run`: Use tool's preview mode
- `--verbose`: Add verbose flag
- `--force`: Skip prompts

### 5. Report Results

Provide:
- Migrations executed (or would be executed if dry-run)
- Time taken
- Any errors or warnings
- Next steps or recommendations

## Safety Reminders

- **Never run destructive commands on production without backup**
- **Always use --dry-run first for unfamiliar operations**
- **Verify environment before executing**
- **Keep migration files under version control**
- **Test migrations in staging before production**

## Error Handling

If errors occur:
- Show clear error message
- Suggest potential fixes
- Check common issues (connection, permissions, syntax)
- Do not continue with subsequent commands
```

**Usage**:
```bash
# Show help
/db-migrate help
/db-migrate

# Run migrations
/db-migrate up
/db-migrate rollback
/db-migrate seed

# With options
/db-migrate up --env=production --dry-run
/db-migrate refresh --env=staging
```

**Key Features Demonstrated**:
- ✅ Comprehensive help section with commands, options, examples
- ✅ Safety notes prominently displayed
- ✅ Clear instruction to stop if help requested
- ✅ Multiple command patterns documented
- ✅ Flag parsing explained
- ✅ Dynamic context injection for environment detection
- ✅ Example usage for common scenarios

---

## Tips for Effective Skill Creation

### Start Simple
Begin with minimal functionality. You can always expand later.

### Use Examples
Include concrete examples in the skill instructions to guide behavior.

### Test Incrementally
Test the skill after creation and refine based on actual usage.

### Leverage Features
Use dynamic context injection, forked context, and tool restrictions to optimize.

### Document Well
Even if `user-invocable: false`, clear descriptions help Claude know when to use it.

### Version Supporting Files
Keep supporting files in sync with SKILL.md. Reference them clearly.

### Consider Performance
Use `model: haiku` for simple/fast tasks, `context: fork` for research that doesn't need chat history.

### Include Help Documentation
For skills with multiple commands or flags, add a help section that displays when user invokes with no args, "help", or "--help". This makes your skills self-documenting and easier to use.
