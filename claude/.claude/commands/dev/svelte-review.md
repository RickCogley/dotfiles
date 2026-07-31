---
allowed-tools: Read, Glob, Grep, Bash, mcp__esolia-standards__get_standard, mcp__esolia-standards__search_standards, WebFetch
description: Review SvelteKit code against modern Svelte 5 features and best practices
---

## Context
- Current directory: !`pwd`
- Svelte version: !`cat package.json 2>/dev/null | grep -E '"svelte"' | head -1 || echo "not found"`
- SvelteKit version: !`cat package.json 2>/dev/null | grep -E '"@sveltejs/kit"' | head -1 || echo "not found"`

## Your task

Review the SvelteKit code in this project against the **Modern Svelte Features Checklist** from the eSolia standards MCP.

### Step 1: Load the checklist

Fetch the standard: `get_standard('svelte-modern-features')` from the eSolia Standards MCP.
Also fetch `get_standard('sveltekit-guide')` for the full Svelte 5 reference.

### Step 2: Scan the codebase

Search for patterns that indicate outdated or underutilized Svelte features:

**Runes compliance:**
- `export let` instead of `$props()`
- `$:` reactive statements instead of `$derived()` / `$effect()`
- Missing `$state()` for reactive variables
- `createEventDispatcher()` instead of callback props

**Event handling:**
- `on:click` / `on:event` instead of `onclick` / `onevent`
- `on:click|preventDefault` instead of inline `e.preventDefault()`

**Slots vs Snippets:**
- `<slot />` / `<slot name="">` instead of `{@render children?.()}` / snippets
- `<div slot="name">` instead of `{#snippet name()}`

**Compiler features (underutilized):**
- Unused CSS rules (compiler detects these -- check for warnings in build output)
- Missing `transition:` / `animate:` directives where manual JS animations exist
- Manual JS animations that could use Svelte's built-in `fade`, `fly`, `slide`, `scale`, `draw`, `crossfade`
- Missing `use:enhance` on forms (progressive enhancement)
- Accessibility: run `svelte-check` and report a11y warnings

**Modern patterns:**
- `.svelte.ts` reactive modules vs old-style stores (`writable()`, `readable()`)
- Class-based stores with `$state` fields vs Svelte store contract
- `$inspect()` for debugging vs `console.log` in `$effect`
- `$bindable()` for two-way binding props
- Scoped CSS being bypassed with `:global()` unnecessarily
- `{@html}` usage without `sanitizeHtml()` wrapper

**SvelteKit patterns:**
- Forms without `use:enhance` (work without JS but miss progressive enhancement)
- `+page.ts` vs `+page.server.ts` usage (server-only data should use `.server.ts`)
- Missing `fail()` returns in form actions
- Platform bindings leaking to client from load functions

### Step 3: Report findings

Organize results into:

1. **Critical** -- Security issues or broken Svelte 5 patterns (old syntax that may break)
2. **Recommended** -- Modern features that would improve the code
3. **Opportunities** -- Nice-to-have improvements (transitions, animations, progressive enhancement)

For each finding, show:
- File and line number
- Current code
- Suggested modern replacement
- Link to relevant Svelte docs section if applicable

### Step 4: Version check

Compare installed `svelte` and `@sveltejs/kit` versions against the minimum safe versions from the sveltekit-guide standard (CVE mitigations). Flag any outdated packages.

### Optional: Svelte MCP autofixer

If the official Svelte MCP server is configured (`@sveltejs/mcp`), run `svelte-autofixer` on any flagged components for additional suggestions.

Handle any arguments: $ARGUMENTS
