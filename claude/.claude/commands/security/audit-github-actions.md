# Audit GitHub Actions Security

Perform a comprehensive security audit of all GitHub Actions workflow files in this repository. Follow each step in order and report findings in a structured summary.

## Step 0: Verify prerequisites

Check that the required tools are available:

```bash
command -v zizmor && command -v actionlint && command -v pinact && command -v gh
```

If any tool is missing, inform the user and recommend:

```bash
brew install zizmor actionlint pinact gh
```

Proceed with the audit regardless — note missing tools in the report and skip any tool-dependent steps that cannot be completed.

## Step 0.5: Load the hardening guide

Fetch the companion reference guide from the eSolia Standards MCP:

```
eSolia Standards:get_standard({ slug: "github-actions-security-hardening" })
```

Use this guide as context for threat models and recommended fixes throughout the audit. If the MCP is unavailable, proceed without it and note the gap.

## Step 1: Inventory workflows

List all files under `.github/workflows/`. For each file, identify:

- Filename
- Triggers (`on:` events)
- Number of jobs
- Third-party actions used (anything not defined in this repo)

## Step 2: Detect monorepo structure

Determine whether this repository is a monorepo. Indicators include:

- Multiple `paths:` filters in workflow triggers scoping to different subdirectories
- Multiple deploy jobs targeting different services, environments, or Cloudflare Workers
- A `packages/`, `apps/`, `services/`, or similar top-level directory structure
- Local composite actions in `.github/actions/` or reusable workflows in `.github/workflows/` called with `uses: ./.github/workflows/...`
- A workspace config (e.g., `pnpm-workspace.yaml`, npm workspaces in `package.json`, or Turborepo/Nx config)

Record whether the repo is a monorepo and list the detected sub-projects or apps. If it is a monorepo, the monorepo-specific checks in Step 12 will apply and the report will include the monorepo checklist items.

## Step 3: Check action pinning

For every `uses:` reference in every workflow file:

- Flag any action referenced by **tag** (e.g., `@v4`, `@main`, `@latest`) instead of a full-length **commit SHA** (40-character hex string)
- For each unpinned action, look up the current SHA for the referenced tag and provide the pinned replacement line with a `# tag` comment

**Format findings as:**

```
FILE: .github/workflows/ci.yml
  UNPINNED: actions/checkout@v4
  FIX:      actions/checkout@<current-sha> # v4
```

## Step 4: Check GITHUB_TOKEN permissions

For every workflow file:

- Check if top-level `permissions:` is declared. If missing, flag it — the default may be read-write
- Check if `permissions` is set to the minimum required (prefer `contents: read` at workflow level)
- Flag any job with `permissions: write-all` or no job-level override where write access is used
- Check org/repo setting: is "Allow GitHub Actions to create and approve pull requests" mentioned or implied?

## Step 5: Detect dangerous triggers

Flag any workflow using these triggers, with severity:

- **CRITICAL:** `pull_request_target` — especially if combined with `actions/checkout` referencing the PR head
- **HIGH:** `workflow_run` — can inherit dangerous context from triggering workflow
- **MEDIUM:** `issue_comment`, `issues`, `discussion`, `discussion_comment` — user-controlled event data

For each finding, check whether the workflow checks out untrusted code or uses event data in `run:` blocks.

## Step 6: Detect script injection

Search all workflow files for `${{ }}` expressions inside `run:` blocks. These are potential injection vectors.

**High-risk expressions** (attacker-controlled input):

- `${{ github.event.issue.title }}`
- `${{ github.event.issue.body }}`
- `${{ github.event.pull_request.title }}`
- `${{ github.event.pull_request.body }}`
- `${{ github.event.pull_request.head.ref }}`
- `${{ github.event.comment.body }}`
- `${{ github.event.discussion.title }}`
- `${{ github.event.discussion.body }}`
- `${{ github.head_ref }}`

**Medium-risk expressions** (less commonly exploited but still risky):

- `${{ github.event.commits[*].message }}`
- `${{ github.event.commits[*].author.name }}`

For each finding, provide the fix: move the expression to an `env:` block.

## Step 7: Check checkout credential persistence

For every `actions/checkout` step, check whether `persist-credentials: false` is set. Flag any checkout step missing this setting — persisted credentials can be extracted by subsequent compromised steps.

## Step 8: Check runner security

- Flag any use of `self-hosted` runners. Note whether they appear to be ephemeral.
- Check if `step-security/harden-runner` or equivalent egress monitoring is present
- Flag any workflow running as `root` or using `sudo` without clear justification

## Step 9: Check secrets handling

- Flag any step that might log secrets (e.g., `echo ${{ secrets.* }}`, debug logging of environment)
- Check for use of OIDC (`id-token: write` permission) vs. long-lived secrets for cloud provider authentication
- Flag any hardcoded credentials, API keys, or tokens in workflow files

## Step 10: Check for GITHUB_ENV / GITHUB_PATH writes

Search for any step that writes to `$GITHUB_ENV` or `$GITHUB_PATH` using attacker-controlled content. These files influence subsequent steps and can be used to inject malicious binaries or environment variable overrides (e.g., `LD_PRELOAD`).

## Step 11: Check branch protection alignment

- Verify that workflows deploying to production require the `environment:` key with a protected environment
- Flag any deploy workflow that runs on `push` to `main` without an environment gate

## Step 11.5: Check central security workflow integration

eSolia maintains a hardened reusable security scanning workflow at `eSolia/.github/.github/workflows/security.yml@main`. Every eSolia repo should have a thin caller workflow that invokes it.

**Check for the caller workflow:**

Search all workflow files for `uses: eSolia/.github/.github/workflows/security.yml`. If not found:

- **Flag as HIGH** — the repo is missing centralized security scanning
- Recommend creating `.github/workflows/security.yml` with this template:

```yaml
# Security scanning using eSolia's shared workflow
# See: https://github.com/eSolia/.github/blob/main/.github/workflows/security.yml

name: Security Scanning

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 0 * * 0'  # Weekly Sunday midnight UTC
  workflow_dispatch:

jobs:
  security:
    uses: eSolia/.github/.github/workflows/security.yml@main
    with:
      package-manager: auto
      source-paths: 'src/ packages/'
      run-typecheck: true
      run-lint: true
    secrets: inherit
```

**If found**, verify:

- The reference points to `@main` (the central workflow is maintained by eSolia and updated in place)
- The `source-paths` input covers the repo's actual source directories
- `secrets: inherit` is acceptable for single-project repos but should be flagged with a note for monorepos (prefer explicit secret passing)

## Step 12: Monorepo-specific checks (conditional)

Skip this step if Step 2 determined the repository is not a monorepo.

If the repository is a monorepo, perform the following additional checks:

**Secret scope isolation:**

- Flag any deploy job that uses repo-level secrets (e.g., `${{ secrets.CLOUDFLARE_API_TOKEN }}`) instead of environment-scoped secrets via a named `environment:`
- For each detected sub-project/app, verify it has a dedicated GitHub Environment with its own secrets
- Flag any workflow where multiple apps could access each other's deployment credentials

**Path filter security:**

- Flag any `paths:` filter used alongside a dangerous trigger (`pull_request_target`, `workflow_run`, `issue_comment`) — path filters are ignored for these triggers and provide no security boundary
- Note any workflow that assumes path filtering provides isolation between sub-projects

**Per-job permission scoping:**

- Flag any monorepo workflow that sets workflow-level `permissions` with write access rather than using `permissions: {}` at the workflow level with per-job overrides
- Each job in a monorepo workflow should declare its own minimal permissions

**Local composite actions and reusable workflows:**

- List all composite actions in `.github/actions/` (or similar directories)
- List all reusable workflows (called with `uses: ./.github/workflows/...`)
- For each, check that any `uses:` references to external actions are pinned to full-length SHAs
- Flag any reusable workflow that uses `secrets: inherit` — this passes all repository secrets, breaking isolation

**Sparse checkout:**

- For deploy jobs scoped to a single app, note if full checkout is used where sparse checkout could limit exposure

## Output format

After completing all steps, write the summary report to a markdown file at:

```
docs/eSolia-GitHub-Actions-Security-Audit-YYYY-MM-DD.md
```

Use today's date. Create the `docs/` directory if it does not exist. If the repo is not a monorepo, set `Repo structure` to `single-project` and omit the checklist lines prefixed with "Monorepo only." The report contents should be:

```markdown
# GitHub Actions Security Audit — [repo name]

> **CONFIDENTIAL** — eSolia Inc. internal use only. Do not distribute outside eSolia.

**Date:** [today's date]
**Repository:** [org/repo name]
**Workflows scanned:** [count]
**Actions referenced:** [count]
**Preparer:** eSolia Inc. (rick.cogley@esolia.co.jp)
**Repo structure:** [single-project | monorepo (list detected apps)]

## Findings Summary

| Severity | Count | Category |
|----------|-------|----------|
| CRITICAL | X     | [categories] |
| HIGH     | X     | [categories] |
| MEDIUM   | X     | [categories] |
| LOW      | X     | [categories] |

## Critical Findings
[details]

## High Findings
[details]

## Medium Findings
[details]

## Low Findings
[details]

## Recommended Fixes (Priority Order)
1. [highest impact fix first]
2. ...

## Checklist Status
- [ ] All actions pinned to SHA
- [ ] Permissions set to read-only default
- [ ] No dangerous triggers (or properly gated)
- [ ] No script injection in run blocks
- [ ] persist-credentials: false on all checkouts
- [ ] No long-lived cloud credentials
- [ ] Runners hardened
- [ ] Fork PRs require approval
- [ ] harden-runner integrated
- [ ] Renovate/Dependabot covers github-actions
- [ ] No secrets in logs
- [ ] Branch protection active on main
- [ ] **Monorepo only:** Secrets scoped to GitHub Environments per app
- [ ] **Monorepo only:** Per-job permissions (workflow-level `permissions: {}`)
- [ ] **Monorepo only:** Local composite actions / reusable workflows audited for unpinned refs
- [ ] **Monorepo only:** Path filters not relied on as security boundaries
- [ ] **Monorepo only:** No `secrets: inherit` in reusable workflow calls

---

## Contact

**eSolia Inc.**
Shiodome City Center 5F (Work Styling)
1-5-2 Higashi-Shimbashi, Minato-ku, Tokyo, Japan 105-7105
**Tel (Main):** +813-4577-3380
**Web:** https://esolia.co.jp/en
**Preparer:** rick.cogley@esolia.co.jp
```

If `zizmor` is available, run `zizmor .github/workflows/` and include its output in the report. If `actionlint` is available, run `actionlint` and include its output. For any tool that is not available, note that it should be installed via `brew install <tool>`.

After writing the file, confirm the output path to the user and provide a brief summary of the finding counts by severity.

## Reference guide

The companion hardening guide with threat models, code examples, and monorepo patterns is available via the eSolia Standards MCP:

```
eSolia Standards:get_standard({ slug: "github-actions-security-hardening" })
```

If you need background on a specific finding or hardening control during the audit, consult the guide before recommending fixes.

## Related commands

The `harden-github-org` slash command audits and applies hardened settings at the GitHub organization and repository level (base permissions, member privileges, Actions policies, rulesets, Dependabot, CODEOWNERS, SECURITY.md). Run it after this Actions-specific audit for comprehensive coverage.
