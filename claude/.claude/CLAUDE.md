# Global Claude Code Configuration

Universal guidance for Claude Code across all repositories and projects.

```yaml
# Core Configuration
config:
  version: "2.0"
  memory_files:
    global: "~/.claude/CLAUDE.md"  # This file - read at session start
    project: "./CLAUDE.md"         # Project-specific (if exists)
  
  user:
    name: "Rick"
    home_folders: ["/Users/rcogley", "/Users/rickcogley"]

# Critical Rules - ALWAYS APPLY
critical_rules:
  - NEVER add AI attribution to commits (no "Co-authored-by: Claude")
  - NEVER add marketing strings ("Generated with Claude Code")
  - ALWAYS run preflight checks before commits
  - ALWAYS perform security checks FIRST (OWASP Top 10)
  - ALWAYS use InfoSec comments for security-relevant changes
  - NEVER use 'any' type in TypeScript
  - ALWAYS read memory files at session start
  - ALWAYS read CLAUDE.md in subfolders when working on code there for better context
  - ALWAYS check project linting rules BEFORE writing code (deno.json, eslint, etc.)
  - ALWAYS follow the change management workflow (issue → branch → PR → merge → verify) for non-trivial changes
  - ALWAYS verify CI and Dependabot after merging to main

# General Directives
directives:
  approach:
    - Give honest assessments, don't sugarcoat solutions
    - Don't make assumptions without asking
    - Be skeptical and questioning
    - Fix all formatting/linting/type issues (no workarounds)
  
  programming_paradigm:
    preferred: "pragmatic_hybrid"
    principles:
      - Object-oriented for structure and state
      - Functional for critical operations
      - Language-specific idioms respected
      - Type safety enforced
      - Fail-fast validation

# Security Standards
security:
  frameworks:
    - OWASP Top 10 (mandatory verification - run the security:owasp skill for the full checklist)
    - ISO 27001 (compliance documentation)
  
  infosec_comments_required_for:
    - Input validation/sanitization changes
    - Authentication/authorization modifications
    - Cryptographic operations
    - Error handling changes
    - Dependency updates
    - Rate limiting/DoS protection
    - Security headers/CORS changes
    - Logging modifications

# Development Workflow
workflow:
  change_management: "See ~/.claude/rules/change-management.md (always loaded) for the full issue → branch → PR → merge → verify workflow, fast-track exceptions, and branching safety"

  git_safety:
    - NEVER use `git stash drop` without first verifying stash contents with `git stash show -p`
    - When uncommitted changes exist and you need to pull, commit to a temp branch first — do NOT stash-drop-stash
    - During long sessions with multiple iterations (container builds, deploy cycles), commit working states incrementally rather than accumulating all changes uncommitted
    - Prefer `git stash pop` (auto-drops on success) over `git stash apply` + manual drop

  preflight_checks:
    universal_steps: [format, lint, typecheck, test, audit]
    reference: "Run the dev:preflight skill for per-language commands; prefer the project's own task runner (deno task, npm run) when defined"
  
  commit_format:
    pattern: "type(scope): description"
    types: ["feat", "fix", "docs", "style", "refactor", "test", "chore", "security"]
    annotation_required: true  # ALWAYS include one of these on the last line
    annotation_types:
      - "InfoSec: [security impact or 'no security impact']"
      - "Quality: [quality consideration, e.g., writing standards compliance]"
      - "Privacy: [privacy impact or 'no PII handling changes']"
    examples:
      - "feat: add input validation for contact form\\n\\nInfoSec: prevents injection attacks on user-supplied parameters"
      - "style: remove em dashes from JA content\\n\\nQuality: writing standards compliance per localization guide"
      - "docs: update README installation steps\\n\\nInfoSec: no security impact — documentation only"
      - "chore: bump lodash to 4.17.22\\n\\nInfoSec: addresses CVE-2026-XXXX prototype pollution"

# Project Structure
project_structure:
  root_directory:
    keep_minimal: true
    allowed: ["entry points", "config files", "type definitions", "README", "LICENSE"]
  
  standard_directories:
    "/src":        "Production code"
    "/scripts":    "Development tools (not distributed)"
    "/tests":      "Test suites"
    "/docs":       "Documentation"
    "/examples":   "Usage examples"
    "/assets":     "Static resources"

# Security Scanning
security_scanning:
  devskim:
    placement: "inline at end of line"
    format: "// DevSkim: ignore DS######"
    common_rules:
      DS162092: "Hardcoded tokens (test data)"
      DS137138: "Regex patterns (intentional)"
      DS189424: "eval usage (security tests)"
  
  codeql:
    placement: "separate line before code"
    format: "// codeql[rule-id]"
    common_rules:
      "js/redos": "RegEx DoS"
      "js/sql-injection": "SQL injection"
      "js/xss": "Cross-site scripting"

# CI/CD Guidelines
cicd:
  release_verification:
    - Local tests pass
    - CI/CD workflows succeed
    - Package published to registry
    - Verify final publication
  
  automation_flags: ["--yes", "-y", "--skip-confirmation"]
  
  test_environment:
    skip_in_ci: ["filesystem operations", "git operations", "network-dependent"]
    pattern: 'ignore: Deno.env.get("CI") === "true"'

# Session Initialization
session_init:
  steps:
    1: "Read global memory (~/.claude/CLAUDE.md)"
    2: "Read project memory (./CLAUDE.md if exists)"
    3: "Use Glob tool to find all CLAUDE.md files in project subfolders with pattern '**/CLAUDE.md', read and understand their context for the specific code areas they document"
    4: "Note includeCoAuthoredBy: false setting"
    5: "Apply all critical rules"
```

## Cloudflare Workers

Authentication uses a single Account API Token (not OAuth):
- Token stored in `~/.ssh/tokens/CLOUDFLARE_API_TOKEN`, loaded by `.zshrc`
- **Never run `wrangler login`** — if `~/.wrangler/config/default.toml` exists, delete it
- Wrangler reads `CLOUDFLARE_API_TOKEN` env var automatically

**Every `wrangler.jsonc` MUST have `account_id`:**

```jsonc
{
  "account_id": "ab2ac8ca4000c79ae4a66377276585be",
  "name": "worker-name",
  // ...
}
```

Account API tokens cannot call `/memberships` (a user-level endpoint). Without `account_id`, wrangler tries `/memberships` to discover the account and fails with code 9106/10001. This applies to ALL wrangler operations (deploy, R2, D1, secrets, etc.).

**Every Worker should have full observability:**

```jsonc
"observability": {
  "enabled": true,
  "logs": { "enabled": true, "invocation_logs": true, "head_sampling_rate": 1 },
  "traces": { "enabled": true, "head_sampling_rate": 1 }
}
```

**Cloudflare MCP:**
- Configured at user scope: `claude mcp add --transport http --header "Authorization: Bearer $TOKEN" -s user cloudflare https://mcp.cloudflare.com/mcp`
- MCP stores the literal token at add-time — must re-add after token rotation

## Working Habits (model-agnostic, mandatory on Opus/Sonnet)

Before starting any non-trivial task, apply these:

1. **Plan first** — use plan mode for multi-file or architectural work; present the plan before executing
2. **Delegate searches** — use Explore subagents for broad codebase searches instead of reading many files into the main context
3. **Verify changes** — run /code-review (or the verify skill) after non-trivial changes before committing
4. **Keep context lean** — suggest /clear between unrelated tasks; prefer skills over pasting reference material
5. **Think deeply when it matters** — for hard design or debugging problems, reason step-by-step before acting

## Override Hierarchy

1. This global configuration provides defaults
2. Project-specific `CLAUDE.md` overrides where needed
3. Security standards (OWASP, InfoSec) are never overridden
