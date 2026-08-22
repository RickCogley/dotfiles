# Time Entry Report

Generate a chronological work summary for client time entries (dbflex PROdb **Times** table), grouped by **Statement of Work (SOW)** then by **day**, with copy-pasteable bullets and suggested hours in 0.25 h increments.

Arguments: `$ARGUMENTS` — e.g. `2026-07` (month, required), optionally a client code (`JAC`) and/or explicit repo paths. Default client is JAC; default repos are `~/dev/jac-2026`, `~/dev/jac-systems`, and `~/dev/codex` (client reports).

## What this is for

Rick logs time in dbflex grouped by **day → SOW**. Each entry needs a few plain-language bullets and a duration in **0.25 h increments (0.25 min)**. Sometimes one monthly rollup entry (e.g. "Web maintenance, 4–5 h") with many bullets is preferred over granular daily entries — always produce **both** views.

## Instructions

### 1. Resolve the period and repos

Parse the month from `$ARGUMENTS` (`YYYY-MM`). Compute `--since`/`--until` (first day of month → first day of next month). Identify the repos:
- **Operational repos** (default `~/dev/jac-2026`, `~/dev/jac-systems`) — the client's website + systems work.
- **Reports repo** (default `~/dev/codex`) — client deliverables. This repo is large and multi-client, so **filter to the target client only** (see step 3).

### 2. Pull git history from the operational repos

For each operational repo:
```bash
git -C <repo> log --since=<start> --until=<end> --date=short \
  --pretty=format:"%ad | %h | %s" --no-merges
```
Also read any running work log the repo keeps for client reporting — check `docs/WORK_LOG.md` and `docs/plans/*worksheet*.md`. These are authored precisely so reports don't have to be reconstructed from git; prefer their plain-language wording for bullets.

### 3. Filter the reports repo to the client

Client reports carry metadata. Find them by path prefix and by manifest `client_code`:
```bash
git -C ~/dev/codex log --since=<start> --until=<end> --name-only --pretty=format: \
  | grep -iE '<client>' | sort -u
grep -l 'client_code: <CLIENT>' ~/dev/codex/content/manifests/*.yaml
```
For each matching document dir, read its manifest for `title`, `title_ja`, `updated_at`/`validity_date`, and get its git creation date (`git log --diff-filter=A --date=short --format=%ad -- <path> | tail -1`). A report is billable as the time to **research + assemble** it — attach that time to the SOW the report belongs to, **not** a separate "reports" line (avoid double-counting with the operational work it documents).

### 4. Classify each item into a SOW

Separate work the way Rick bills it. Typical JAC SOWs:
- **Website: Go-Live / project work** (distinct from maintenance — e.g. team restructure, structural changes)
- **Website: Footer/Legal page cleanup** (client-facing content pages)
- **Website: Maintenance & bug fixes** (Sentry-triggered defects, CI hygiene, dep syncs)
- **Website: SEO** (indexing, sitemap, IndexNow, hreflang, meta routes)
- **Website: Security** (Dependabot, ASVS, security headers, cost/cpu_ms guards)
- **Systems: Infrastructure & Monitoring** (OTEL/logging workers)
- **Security: Incident Response** (phishing/incident investigation + reports)
- **Infrastructure** (firewall/FortiOS, network)
- **Security: Audit/Review** (pre-audit questionnaires, assessments)

Use commit `type(scope)` prefixes as hints (`feat`/`fix`=website work, `security`/`chore(security)`=Security, SEO scopes=SEO, `chore(deps)`=Security/maintenance). When unsure which SOW an item belongs to, ask rather than guess.

### 5. Estimate hours

Assign a suggested duration per (day × SOW) entry in **0.25 h increments (min 0.25)**. **Always label estimates as estimates** — these are for grouping, not measured time; Rick replaces them with actual before entering. Never present estimated hours as fact.

### 6. Output

Write a markdown file to the scratchpad (or a path Rick names) and present it inline. Structure:
1. Header: client, period, sources, and the double-counting guard note.
2. One section per SOW, each a table of `Day | Bullets | Est. hrs` with a subtotal.
3. A **monthly rollup** table (one row per SOW) as the alternative to per-day entries, with an estimated month total.

Keep bullets plain-language and client-appropriate (they may be surfaced to the client): what changed, why it mattered, how it was verified. US English spelling; ISO 8601 dates in English; JPY for any currency.

### 7. Do not

- Do not commit anything or modify the repos — this is a read-only reporting command.
- Do not invent work not present in git or the work logs.
- Do not double-count a report against both its own line and the operational work it documents.
