---
allowed-tools: Read, Glob, mcp__esolia-standards__get_standard, mcp__esolia-standards__search_standards
description: Review markdown content against eSolia writing standards (AI-proof editing, article structure, localization)
---

## Your task

Review a markdown file against all 3 eSolia writing standards. This is used to check content before publishing.

### Step 1: Get the content to review

The user's argument: $ARGUMENTS

If a file path is provided, read that file.
If no argument, ask which file to review.

### Step 2: Fetch writing standards from MCP

Fetch all 3 standards in parallel using `get_standard`. These are Knowledge documents in D1 with `mcp_exposed=1`:

1. `writing-ai-proof-editing-20260304` — vocabulary red flags, structural patterns, tonal issues
2. `writing-article-writing-guide-20260304` — structure frameworks, voice/tone, anti-patterns
3. `writing-content-localization-strategy-20260304` — audience-specific adaptation, EN vs JA framing

If `get_standard` returns "not found" for any of these, fall back to `search_standards` with the keyword (e.g. "ai-proof editing").

If the content is in Japanese, the ai-proof-editing document includes a JA section.

### Step 3: Review against each standard

**AI-Proof Editing check:**
- Scan for overused AI vocabulary (delve, navigate, leverage, robust, streamline, holistic, etc.)
- Check for overused phrases ("It's worth noting", "Let's dive in", "In today's X landscape", etc.)
- Look for structural patterns: validation sandwiches, triple hedges, uniform paragraph lengths, bookend compulsion, false parallelism, list addiction
- Check tonal red flags: emotional uncanny valley, over-politeness, signposting overkill ("Here's what...", "Let's explore...")

**Article Writing Guide check:**
- Does the structure match an appropriate framework?
- Is the hook effective?
- Are there concrete examples and specifics (not just abstractions)?
- Does it avoid anti-patterns: cookie-cutter sections, bullet-point lists where prose works better, bookend CTAs?
- Is the voice authoritative but conversational?

**Content Localization check (if bilingual or if you can detect the target audience):**
- Does EN content provide cultural/educational context for international readers?
- Does JA content support the "explaining to HQ" framing?
- Is it following the "not 1:1" principle (content adapted, not just translated)?

### Step 4: Report

For each issue found, provide:
- The specific text that triggered the flag (quote it)
- Which standard and rule it violates
- A concrete rewrite suggestion

At the end, provide an overall score:
- **Vocabulary**: Clean / Minor issues / Needs revision
- **Structure**: Strong / Adequate / Needs work
- **Tone**: Natural / Mostly natural / AI-sounding
- **Localization**: N/A / Good / Needs adaptation

Group issues by severity (critical issues that sound obviously AI-generated first, then minor style issues).
