---
allowed-tools: Read, Glob, Grep, mcp__esolia-standards__get_standard, mcp__esolia-standards__search_standards, mcp__esolia-standards__list_standards
description: Review code against the relevant eSolia coding standard (auto-detects project type)
---

## Context
- Current directory: !`pwd`
- Project indicators: !`ls package.json deno.json Cargo.toml go.mod pyproject.toml svelte.config.js svelte.config.ts wrangler.jsonc wrangler.toml 2>/dev/null`

## Your task

Review code in this project against the relevant eSolia coding standard. Auto-detect the project type and pull the right standard from the MCP.

### Step 1: Detect project type

Based on the config files found above, determine which standard(s) to fetch:

| Indicator | Standard slug |
|-----------|--------------|
| `svelte.config.*` | `sveltekit-guide` + `sveltekit-backpressure` |
| `wrangler.jsonc` or `wrangler.toml` (without Svelte) | `cloudflare-security-hardening` + `typescript-practices` |
| `package.json` with TypeScript | `typescript-practices` |
| `deno.json` | `typescript-practices` |
| `Cargo.toml` | `tauri-practices` (if Tauri) |

Always also consider: `security-checklist` for any project.

### Step 2: Fetch the standard(s)

Use `get_standard` to fetch the relevant standard(s) by slug.

### Step 3: Review

If `$ARGUMENTS` specifies a file or directory, review that code against the standard.
If no arguments, review recently changed files (check `git diff --name-only HEAD~3` for recently modified source files).

For each issue found, report:
- The file and line number
- The standard rule being violated
- A concrete fix

### Arguments
$ARGUMENTS
