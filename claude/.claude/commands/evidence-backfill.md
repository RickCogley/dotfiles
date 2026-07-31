# Evidence Backfill

Guided ISO 27001 evidence-pdf backfill for the **current repo** — milestone curation, per-PR PDF rendering, milestone-aggregate rendering.

Reference docs (in `~/dev/devkit`):
- `docs/eSolia-EvidencePipeline-Design-Spec-INTERNAL-20260503-en.md` — what / why
- `docs/eSolia-EvidencePipeline-Runbook-INTERNAL.md` — full operations

Tooling lives in `~/dev/devkit/scripts/`. Worker is `esolia-evidence-pdf` on the eSolia CF account; live at `https://esolia-evidence-pdf.esolia.workers.dev`.

## Instructions

### 1. Identify the repo

```bash
gh repo view --json owner,name --jq '.owner.login + "/" + .name'
```

The user already knows which repos are in scope — don't second-guess. Just confirm the slug back to them in one line and continue.

### 2. Survey merged PRs since the backfill floor

The floor is **2024-05-11** (saved in `~/dev/devkit/workers/evidence-pdf/wrangler.jsonc` as `BACKFILL_FLOOR`). Show what's eligible:

```bash
gh pr list --state merged --base main --limit 200 \
  --json number,title,mergedAt,labels \
  --jq '.[] | select(.mergedAt >= "2024-05-11") | "#\(.number) [\(.mergedAt[:10])] \(.title)"'
```

Show the count and a sample. Ask:

- **Curate milestones first?** (recommended if the user can identify feature groupings)
- **Skip milestones and backfill ungrouped?** (acceptable; cover page just shows empty milestone block)

### 3. Curate milestones (if chosen)

The grouping is judgment-based — only the user can decide. Help by suggesting starting groupings (by month, by `feat(scope):` commit prefix, by label clusters), but let them call it.

Update `~/dev/devkit/scripts/evidence-milestones.json` — add entries under the repo's key. Each entry:

```json
{
  "name": "Feature Name",
  "description": "One-line context for the auditor.",
  "state": "closed",
  "prs": [10, 11, 12, 14]
}
```

Then preview and apply:

```bash
cd ~/dev/devkit
./scripts/apply-evidence-milestones.sh --dry-run --repo <owner>/<repo>
./scripts/apply-evidence-milestones.sh --repo <owner>/<repo>
```

Idempotent — re-runs skip already-correct assignments.

### 4. Backfill per-PR PDFs

Locate `BACKFILL_TOKEN`. Two cases:

**Case A — token saved.** Source it (preferred persistent location is `~/.config/esolia/evidence-pdf.env`, `chmod 600`, containing the two `export` lines):

```bash
source ~/.config/esolia/evidence-pdf.env   # exports BACKFILL_WORKER_URL + BACKFILL_TOKEN
```

**Case B — token missing.** The worker has a secret set on it, but Cloudflare stores it encrypted — there is no plaintext copy to recover. Rotate to a fresh value:

```bash
TOKEN=$(openssl rand -base64 32 | tr -d '=+/' | head -c 48)
umask 077
mkdir -p ~/.config/esolia
cat > ~/.config/esolia/evidence-pdf.env <<EOF
export BACKFILL_WORKER_URL=https://esolia-evidence-pdf.esolia.workers.dev
export BACKFILL_TOKEN=$TOKEN
EOF
chmod 600 ~/.config/esolia/evidence-pdf.env
( cd ~/dev/devkit/workers/evidence-pdf && printf '%s' "$TOKEN" | wrangler secret put BACKFILL_TOKEN )
unset TOKEN
source ~/.config/esolia/evidence-pdf.env
```

**Never echo the token in persistent logs or commit messages.** Rotation invalidates the previous token immediately.

Then run the backfill:

```bash
cd ~/dev/devkit
./scripts/backfill-evidence-pdfs.sh --dry-run --repo <owner>/<repo>
./scripts/backfill-evidence-pdfs.sh --repo <owner>/<repo>
```

For **retroactive backfills** (many old PRs, some may have content the renderer can't handle), use `--continue-on-error` so one bad PR doesn't halt the whole run:

```bash
./scripts/backfill-evidence-pdfs.sh --continue-on-error --repo <owner>/<repo>
```

Throughput: ~6 PRs/minute default. State:
- `.backfill-state/<owner>_<repo>.done` — successfully rendered PRs (resume safe)
- `.backfill-state/<owner>_<repo>.failed` — PRs that errored on the most recent run (when using `--continue-on-error`); re-run picks them up automatically

Common failures:
- `repo_not_allowed` — add to `BACKFILL_ALLOWED_REPOS` var in `workers/evidence-pdf/wrangler.jsonc`, redeploy worker
- `render_failed` — could be Typst rendering, the GraphQL query, or downstream dispatch. Tail `wrangler tail esolia-evidence-pdf --format=json` while triggering one of the failures to see the full error (the worker logs up to 1000 chars). If the `detail` is `graphql error: Resource not accessible by integration`, the GitHub App token lacks scope for some field this PR exercises — try the same query with `gh api graphql` (user token) to isolate the failing field, then either widen App permissions or relax the query.
- GraphQL secondary rate limit → lower `--rate-per-minute` and re-run

### 5. Render milestone aggregates

Either close the milestone in GitHub (auto-fires via webhook — the App is subscribed to `Milestone` events) **or** trigger manually.

Single milestone:

```bash
curl -sS -X POST "$BACKFILL_WORKER_URL/aggregate" \
  -H "Authorization: Bearer $BACKFILL_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"repo":"<owner>/<repo>","milestone_number":<N>}'
```

When there are many milestones (typical for an initial backfill), loop over the closed ones. Each aggregate render is ~5–10 seconds:

```bash
MILESTONES=$(gh api "repos/<owner>/<repo>/milestones?state=closed&per_page=100" --jq '.[].number')
for m in $MILESTONES; do
  printf 'M#%s → POST\n' "$m"
  resp=$(curl -sS -o /tmp/r.json -w '%{http_code}' \
    --max-time 120 \
    -X POST "$BACKFILL_WORKER_URL/aggregate" \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $BACKFILL_TOKEN" \
    -d "{\"repo\":\"<owner>/<repo>\",\"milestone_number\":$m}")
  if [[ "$resp" =~ ^2 ]]; then
    printf 'M#%s OK %s\n' "$m" "$(jq -r .r2_key /tmp/r.json)"
  else
    printf 'M#%s FAIL http=%s %s\n' "$m" "$resp" "$(jq -r .error /tmp/r.json)"
  fi
  sleep 3
done
```

### 6. Verify

`wrangler r2` has no `object list` subcommand — listing happens via the Cloudflare API. Easiest is to check the state file count against the eligible-PRs count, plus open the SharePoint folder.

```bash
# Backfill state count (should equal eligible PR count)
wc -l ~/dev/devkit/.backfill-state/<owner>_<repo>.done
gh pr list --repo <owner>/<repo> --state merged --base main --limit 200 \
  --json mergedAt --jq '[.[] | select(.mergedAt >= "2024-05-11")] | length'

# R2 listing via API (if you need it)
curl -sS \
  "https://api.cloudflare.com/client/v4/accounts/ab2ac8ca4000c79ae4a66377276585be/r2/buckets/esolia-isms-evidence/objects?prefix=change-management/$(date +%Y)/<repo-slug>/&per_page=100" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  | jq -r '.result[].key' | sort

# SharePoint (visual confirmation)
open "https://esolia1.sharepoint.com/sites/IMS/Records/Change%20Management/$(date +%Y)/<repo-slug>/"
```

Filename pattern (set by the worker):
- Per-PR: `eSolia-CM-<repo>-PR-<n>-<short-sha>.pdf`
- Milestone aggregate: `eSolia-CM-<repo>-MILESTONE-<n>-<slug>.pdf`

The `eSolia-CM-` prefix carries org + change-management context so files keep their meaning if they ever leave the system.

### 7. Report back

Tell the user:
- Backfilled PR count (and any in `.failed`)
- Created milestone count + aggregate PDF count
- Any failures with reasons (capture the actual error detail from the response, not a generic placeholder)
- PRs still ungrouped (if applicable) and whether to curate later

## Notes

**Token hygiene.** `BACKFILL_TOKEN` never goes in commit messages, shared logs, or persistent files the user didn't request. The CF-side Worker secret is encrypted and cannot be recovered; if no plaintext copy exists locally, rotate using the Case B recipe in step 4.

**Idempotency everywhere.** Both the milestone-apply and the backfill scripts are designed to be re-run safely. Wrong milestone assignment? Edit the JSON, re-apply, then delete the affected PRs from `.backfill-state/<owner>_<repo>.done` and re-backfill. The `/backfill` route does not gate on idempotency (it always re-renders), so clearing the local state is sufficient.

**`--continue-on-error` for retroactive runs.** Default behavior is to halt on the first `render_failed` so persistent issues surface immediately. For a one-shot historical backfill, pass `--continue-on-error` so a single bad PR doesn't block the rest. Failed PRs are written to `.backfill-state/<owner>_<repo>.failed` and re-attempted on the next run.

**Filename changes mid-stream.** If the worker's filename pattern changes (as it did with the `eSolia-CM-…` prefix), re-rendering produces new names but leaves the old files orphaned in R2 + SharePoint. Either delete them manually or script R2 list + delete + Graph move. The worker does not own old-name cleanup.

**Streaming logs from a background loop.** Bash inside a `$(curl …)` capture buffers stdout when stdout is a pipe (the Claude Code Bash tool wraps it in one). For a long-running loop where you want per-iteration notifications, write the loop to a file and run it with `stdbuf -oL`:

```bash
cat > /tmp/loop.sh <<'EOF'
#!/bin/bash
# ...your loop with printf, not echo $(...)
EOF
chmod +x /tmp/loop.sh
stdbuf -oL /tmp/loop.sh > /tmp/loop.log 2>&1 &
```

**The image-bump gotcha.** If a future `typst-pdf` image bump doesn't seem to take effect, check `CONTAINER_VERSION` in `~/dev/codex/packages/typst-pdf/src/index.ts` — that constant keys the DO singleton and must match the wrangler.jsonc image tag.

**Out-of-scope repos.** `RickCogley/pub-cogley` is intentionally not in ISMS evidence scope. If the user asks to run this against pub-cogley, stop and confirm before adding it.
