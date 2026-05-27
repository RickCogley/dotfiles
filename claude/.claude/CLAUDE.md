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
    - OWASP Top 10 (mandatory verification)
    - ISO 27001 (compliance documentation)
  
  owasp_checklist:
    A01_access_control: "Validate authorization, least privilege"
    A02_crypto_failures: "Strong encryption, secure key management"
    A03_injection: "Parameterized queries, input sanitization"
    A04_insecure_design: "Security-first architecture"
    A05_misconfig: "Secure defaults, proper error handling"
    A06_vulnerable_components: "Dependency auditing"
    A07_auth_failures: "Strong authentication mechanisms"
    A08_data_integrity: "Validate processing operations"
    A09_logging_failures: "Log security events, no sensitive data"
    A10_ssrf: "Validate external requests"
  
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
  change_management:
    standard_workflow:
      - "1. Create or reference a GitHub issue (use change-request template)"
      - "2. Create feature branch: {type}/{short-description}"
      - "3. Work on branch, run preflight checks"
      - "4. Create PR with 'Closes #N' linking to issue"
      - "5. Merge with: gh pr merge --admin --merge --delete-branch"
      - "6. Post-merge: check GH CI (gh run list --limit 3), check CF build logs, check Dependabot alerts"
    fast_track:
      - "Direct push to main allowed ONLY for: single-file typos, whitespace/formatting, cosmetic copy edits"
      - "Still requires conventional commit with InfoSec annotation and post-push CI check"
    rationale: "ISO 27001 A.8.9/A.8.25/A.8.32 — every production change must be traceable from release → PR → issue → commits → CI"

  git_safety:
    - NEVER use `git stash drop` without first verifying stash contents with `git stash show -p`
    - When uncommitted changes exist and you need to pull, commit to a temp branch first — do NOT stash-drop-stash
    - During long sessions with multiple iterations (container builds, deploy cycles), commit working states incrementally rather than accumulating all changes uncommitted
    - Prefer `git stash pop` (auto-drops on success) over `git stash apply` + manual drop

  preflight_checks:
    universal_steps:
      - format      # Code formatting
      - lint        # Style/quality checks
      - typecheck   # Type validation
      - test        # Run test suite
      - audit       # Security vulnerabilities
    
    language_commands:
      deno: ["deno fmt", "deno check **/*.ts", "deno lint", "deno test"]
      node: ["npm run format", "npm run lint", "npm run type-check", "npm test", "npm audit"]
      python: ["black .", "mypy .", "flake8", "pytest", "safety check"]
      go: ["go fmt ./...", "go vet ./...", "golint ./...", "go test ./...", "govulncheck ./..."]
      rust: ["cargo fmt", "cargo clippy", "cargo test", "cargo audit"]
      java: ["./gradlew spotlessApply", "./gradlew checkstyleMain", "./gradlew test", "./gradlew dependencyCheckAnalyze"]
      csharp: ["dotnet format", "dotnet build", "dotnet test"]
  
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

## Quick Reference Commands

```bash
# Before ANY commit, run appropriate preflight:
deno fmt && deno check **/*.ts && deno lint && deno test     # Deno
npm run format && npm run lint && npm test && npm audit      # Node.js
black . && mypy . && flake8 && pytest && safety check        # Python
# ... etc
```

## Override Hierarchy

1. This global configuration provides defaults
2. Project-specific `CLAUDE.md` overrides where needed
3. Security standards (OWASP, InfoSec) are never overridden
