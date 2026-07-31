# Harden GitHub Organization and Repository Settings

Audit and harden security settings for the eSolia GitHub organization and its repositories. This command operates in two phases: a read-only audit, then an interactive hardening pass that requires explicit confirmation before making changes.

**Prerequisites:** `gh` CLI must be installed, authenticated, and have `admin:org` and `repo` scopes.

## Phase 1: Preflight checks

Verify the environment:

```bash
gh auth status
```

Confirm the authenticated user has **Owner** role in the target org. Determine the org name — default to `esolia` but allow the user to specify a different org if they did. If the user is not an org owner, warn that some settings cannot be read or changed and proceed with what is available.

Check required `gh` scopes:

```bash
gh auth status 2>&1 | grep -i "scopes"
```

If `admin:org` or `repo` scopes are missing, advise:

```bash
gh auth refresh -s admin:org,repo,read:org
```

## Phase 1.5: Load the hardening guide

Fetch the companion reference guide from the eSolia Standards MCP:

```
eSolia Standards:get_standard({ slug: "github-actions-security-hardening" })
```

Use the "Operational impact of hardening settings" section as context when presenting impact notes during Phase 5. If the MCP is unavailable, proceed without it and note the gap.

## Phase 2: Audit organization settings

Read current org-level configuration. For each setting, record the current value and whether it matches the hardened target.

### 2.1 Core org settings

```bash
gh api /orgs/{org} --jq '{
  two_factor_requirement_enabled: .two_factor_requirement_enabled,
  default_repository_permission: .default_repository_permission,
  members_can_create_repositories: .members_can_create_repositories,
  members_can_create_public_repositories: .members_can_create_public_repositories,
  members_can_create_private_repositories: .members_can_create_private_repositories,
  members_can_create_internal_repositories: .members_can_create_internal_repositories,
  members_can_fork_private_repositories: .members_can_fork_private_repositories,
  members_can_create_pages: .members_can_create_pages,
  members_can_create_public_pages: .members_can_create_public_pages,
  web_commit_signoff_required: .web_commit_signoff_required
}'
```

**Hardened targets:**

| Setting | Target | Rationale |
|---------|--------|-----------|
| `two_factor_requirement_enabled` | `true` | Non-negotiable baseline authentication |
| `default_repository_permission` | `"read"` | Least privilege; grant write via teams |
| `members_can_create_repositories` | `true` | Keep if devs need to create repos; restrict public visibility below |
| `members_can_create_public_repositories` | `false` | Prevent accidental public exposure of client work |
| `members_can_create_private_repositories` | `true` | Allow private repos |
| `members_can_create_internal_repositories` | `false` | Not applicable outside Enterprise |
| `members_can_fork_private_repositories` | `false` | Keep code within org perimeter |
| `members_can_create_pages` | `false` | eSolia uses Cloudflare Pages; close unused surface |
| `members_can_create_public_pages` | `false` | Same reason |
| `web_commit_signoff_required` | `false` | Optional; set `true` if DCO compliance needed |

### 2.2 Actions org settings

```bash
gh api /orgs/{org}/actions/permissions --jq '{
  enabled_repositories: .enabled_repositories,
  allowed_actions: .allowed_actions
}'
```

```bash
gh api /orgs/{org}/actions/permissions/workflow --jq '{
  default_workflow_permissions: .default_workflow_permissions,
  can_approve_pull_request_reviews: .can_approve_pull_request_reviews
}'
```

**Hardened targets:**

| Setting | Target | Rationale |
|---------|--------|-----------|
| `enabled_repositories` | `"all"` | Allow Actions in all repos (restrict at action level) |
| `allowed_actions` | `"selected"` | Only allow curated actions |
| `default_workflow_permissions` | `"read"` | Least privilege for GITHUB_TOKEN |
| `can_approve_pull_request_reviews` | `false` | Workflows must not auto-approve PRs |

If `allowed_actions` is `"selected"`, also fetch the current allowlist:

```bash
gh api /orgs/{org}/actions/permissions/selected-actions --jq '{
  github_owned_allowed: .github_owned_allowed,
  verified_creators_allowed: .verified_creators_allowed,
  patterns_allowed: .patterns_allowed
}'
```

**Hardened targets for selected actions:**

| Setting | Target |
|---------|--------|
| `github_owned_allowed` | `true` |
| `verified_creators_allowed` | `false` |
| `patterns_allowed` | `["cloudflare/*", "step-security/*"]` (plus any other actions eSolia actually uses — ask the user to confirm this list) |

### 2.3 Member 2FA compliance

If 2FA requirement is already enabled, list any members without 2FA (they will have been removed, but check):

```bash
gh api /orgs/{org}/members?filter=2fa_disabled --jq '.[].login'
```

Report the count and list of non-compliant members. **Warn the user** that enabling `two_factor_requirement_enabled` will immediately remove any member without 2FA configured.

## Phase 3: Audit repository settings

List all repos in the org:

```bash
gh repo list {org} --limit 100 --json name,visibility,isArchived,isFork --jq '.[] | select(.isArchived == false)'
```

For each non-archived repository, audit the following settings.

### 3.1 Repository features

```bash
gh api /repos/{org}/{repo} --jq '{
  has_wiki: .has_wiki,
  has_projects: .has_projects,
  has_discussions: .has_discussions,
  has_pages: .has_pages,
  delete_branch_on_merge: .delete_branch_on_merge,
  allow_auto_merge: .allow_auto_merge,
  allow_squash_merge: .allow_squash_merge,
  allow_merge_commit: .allow_merge_commit,
  allow_rebase_merge: .allow_rebase_merge,
  visibility: .visibility
}'
```

**Hardened targets:**

| Setting | Target | Rationale |
|---------|--------|-----------|
| `has_wiki` | `false` | Not used; close attack surface |
| `has_projects` | `false` | Not used; close attack surface (unless repo uses GH Projects) |
| `has_discussions` | `false` | Discussions content can trigger Actions via `discussion` event |
| `delete_branch_on_merge` | `true` | Clean up merged branches automatically |
| `allow_auto_merge` | `false` | Require human merge; prevent automation bypass |

Present per-repo findings as a table.

### 3.2 Branch protection / Rulesets on main

Check for existing rulesets:

```bash
gh api /repos/{org}/{repo}/rulesets --jq '.[].name'
```

If no rulesets exist, check for legacy branch protection:

```bash
gh api /repos/{org}/{repo}/branches/main/protection 2>/dev/null
```

**Hardened target ruleset for `main`:**

- Require pull request with at least 1 approving review
- Dismiss stale reviews on new pushes
- Require status checks to pass before merging
- Require conversation resolution
- Block force pushes
- Block deletions

### 3.3 Security features

```bash
gh api /repos/{org}/{repo}/vulnerability-alerts -i 2>&1 | head -1
```

A `204` response means Dependabot alerts are enabled. A `404` means disabled.

Also check:

```bash
gh api /repos/{org}/{repo} --jq '{
  security_and_analysis: .security_and_analysis
}'
```

**Hardened targets:**

| Feature | Target |
|---------|--------|
| Dependabot alerts | Enabled |
| Dependabot security updates | Enabled |
| Dependency graph | Enabled |
| Secret scanning | Enabled (if available on plan) |
| Secret scanning push protection | Enabled (if available on plan) |

### 3.4 CODEOWNERS file

Check if `.github/CODEOWNERS` exists:

```bash
gh api /repos/{org}/{repo}/contents/.github/CODEOWNERS 2>/dev/null
```

If missing, flag it. The recommended CODEOWNERS content is:

```
# Require review for workflow and CI changes
.github/                @{org}/security-reviewers

# Require review for dependency changes
package.json            @{org}/security-reviewers
package-lock.json       @{org}/security-reviewers
pnpm-lock.yaml          @{org}/security-reviewers
renovate.json           @{org}/security-reviewers
```

Note: this requires a `security-reviewers` team to exist. If the team doesn't exist, note this in the report and ask the user what team name to use.

### 3.5 SECURITY.md file

Check if `SECURITY.md` exists at repo level or org `.github` repo:

```bash
gh api /repos/{org}/{repo}/contents/SECURITY.md 2>/dev/null
```

If missing, flag it. A minimal `SECURITY.md` template:

```markdown
# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly.

**Email:** security@esolia.co.jp
**Response time:** We aim to acknowledge reports within 48 hours.

Please do not open public issues for security vulnerabilities.
```

## Phase 4: Present audit report

Write the audit report to:

```
docs/eSolia-GitHub-Org-Security-Audit-YYYY-MM-DD.md
```

Create the `docs/` directory if it does not exist. The report format:

```markdown
# GitHub Organization Security Audit — {org}

> **CONFIDENTIAL** — eSolia Inc. internal use only. Do not distribute outside eSolia.

**Date:** [today's date]
**Organization:** {org}
**Repositories audited:** [count]
**Preparer:** eSolia Inc. (rick.cogley@esolia.co.jp)

## Organization Settings

| Setting | Current | Target | Status | Impact if changed |
|---------|---------|--------|--------|-------------------|
| 2FA required | ... | true | / | Members without 2FA immediately removed |
| Base permission | ... | read | / | Members lose default write; use teams |
| Public repo creation | ... | false | / | Owner must set public visibility |
| Private forking | ... | false | / | Use branches instead of forks |
| Pages creation | ... | false | / | None expected (using Cloudflare Pages) |
| ... | ... | ... | ... | ... |

## Actions Settings

| Setting | Current | Target | Status | Impact if changed |
|---------|---------|--------|--------|-------------------|
| Workflow permissions | ... | read | / | Workflows need explicit permissions: block |
| PR approval by workflows | ... | false | / | Human approval required for all PRs |
| Allowed actions | ... | selected | / | Unlisted actions blocked org-wide |
| ... | ... | ... | ... | ... |

## Allowed Actions

[current allowlist vs recommended]

## Repository Audit Summary

| Repository | Wiki | Projects | Discussions | Delete on merge | Dependabot | Ruleset on main | CODEOWNERS | SECURITY.md |
|------------|------|----------|-------------|-----------------|------------|-----------------|------------|-------------|
| repo-a | off | off | off | on | on | yes | yes | missing |
| ... | | | | | | | | |

## Findings requiring manual action

[list any settings that cannot be changed via API, e.g., 2FA grace period, SAML]

---

## Contact

**eSolia Inc.**
Shiodome City Center 5F (Work Styling)
1-5-2 Higashi-Shimbashi, Minato-ku, Tokyo, Japan 105-7105
**Tel (Main):** +813-4577-3380
**Web:** https://esolia.co.jp/en
**Preparer:** rick.cogley@esolia.co.jp
```

After writing the report, present the summary to the user and ask: **"Do you want to proceed with applying the hardened settings? I'll walk through each change and ask for confirmation."**

## Phase 5: Apply hardening (interactive, requires confirmation)

**CRITICAL: Do not proceed with Phase 5 unless the user explicitly confirms they want to apply changes.** Phase 5 modifies org and repo settings. Each category of changes must be confirmed separately.

### 5.1 Organization settings

Show the user exactly which org settings will change. Only include settings that currently differ from the target. For each setting, include a brief impact note. Present them as a confirmation block like this:

> **Proposed org setting changes:**
>
> - `default_repository_permission` -> `read`
>   _Impact: Members lose default write access. Grant write via teams instead. Existing direct collaborator grants are unaffected._
>
> - `members_can_create_public_repositories` -> `false`
>   _Impact: Members can only create private repos. Org owner must change visibility for any repo that needs to be public._
>
> - `members_can_fork_private_repositories` -> `false`
>   _Impact: Members cannot fork private repos to personal accounts. Use branches within the repo instead._
>
> - `members_can_create_pages` -> `false`
>   _Impact: Members cannot enable GitHub Pages. Existing Pages sites continue working. eSolia uses Cloudflare Pages, so no expected impact._
>
> - `members_can_create_public_pages` -> `false`
>   _Impact: Same as above — prevents public Pages sites._
>
> **Apply these changes?**

Wait for confirmation, then apply:

```bash
gh api --method PATCH /orgs/{org} \
  -f default_repository_permission="read" \
  -F members_can_create_public_repositories=false \
  -F members_can_fork_private_repositories=false \
  -F members_can_create_pages=false \
  -F members_can_create_public_pages=false
```

**Special handling for 2FA:** If `two_factor_requirement_enabled` is `false`, present this as a separate confirmation with a stronger warning:

> **Enable 2FA requirement?**
>
> _Impact: Members without 2FA are **immediately removed** from the org. They lose all repo access and team memberships. Re-invitation after enabling 2FA does not restore team assignments — those must be manually recreated._
>
> Members currently without 2FA: [list from 2.3]
>
> Recommended: notify these members first and set a deadline before enabling.
>
> **Proceed with 2FA enforcement?**

Only enable 2FA if the user confirms after seeing the member list:

```bash
gh api --method PATCH /orgs/{org} \
  -F two_factor_requirement_enabled=true
```

### 5.2 Actions settings

Present the proposed changes with impact notes:

> **Proposed Actions setting changes:**
>
> - `default_workflow_permissions` -> `read`
>   _Impact: All workflows start with read-only GITHUB_TOKEN. Any workflow that writes (deploys, creates releases, comments on PRs) will fail with "Resource not accessible by integration" unless it declares a `permissions:` block. **Audit and fix workflow YAML first.**_
>
> - `can_approve_pull_request_reviews` -> `false`
>   _Impact: Workflows cannot auto-approve PRs. Dependency update PRs (Renovate, Dependabot) will need a human approval. Consider using auto-merge with required status checks as an alternative._
>
> - `allowed_actions` -> `selected`
>   _Impact: Only allow-listed actions can run. Any workflow using an unlisted action fails immediately at job start. **Review the proposed allowlist carefully** — missing an action you use will break CI._
>
> **Apply these changes?**

Wait for confirmation, then apply:

```bash
# Set default workflow permissions to read
gh api --method PUT /orgs/{org}/actions/permissions/workflow \
  -f default_workflow_permissions="read" \
  -F can_approve_pull_request_reviews=false

# Restrict to selected actions
gh api --method PUT /orgs/{org}/actions/permissions \
  -f enabled_repositories="all" \
  -f allowed_actions="selected"
```

For the allowlist, present a separate confirmation:

> **Proposed Actions allowlist:**
>
> - `actions/*` (GitHub-owned) — allowed
> - Verified creators — not allowed (verified badge doesn't guarantee security)
> - `cloudflare/*` — allowed
> - `step-security/*` — allowed
> - [any additional patterns detected from workflow audit]
>
> _Impact: Any action not matching these patterns is blocked org-wide. To add a new action later, an org owner must update this list._
>
> **Add or remove any patterns before applying?**

After user confirms the final list:

```bash
gh api --method PUT /orgs/{org}/actions/permissions/selected-actions \
  -F github_owned_allowed=true \
  -F verified_creators_allowed=false \
  -f 'patterns_allowed[]=cloudflare/*' \
  -f 'patterns_allowed[]=step-security/*'
```

### 5.3 Repository settings (batch)

For each non-archived repo where settings differ from targets, show the proposed changes with impact notes:

> **Proposed repo setting changes** (applies to [N] repos):
>
> - `has_wiki` -> `false`
>   _Impact: Wiki tab disappears. Existing wiki content is preserved — re-enabling restores it._
>
> - `has_projects` -> `false`
>   _Impact: Repo-level Projects tab disappears. Org-level Projects are unaffected. Existing project boards are preserved._
>
> - `has_discussions` -> `false`
>   _Impact: Discussions tab disappears. Reduces attack surface for Actions triggered by `discussion` events. Existing discussions are preserved._
>
> - `delete_branch_on_merge` -> `true`
>   _Impact: Source branches are auto-deleted after PR merge. "Restore branch" button is available briefly if needed. Do not use long-lived branches across multiple PRs._
>
> - `allow_auto_merge` -> `false`
>   _Impact: PRs cannot be set to auto-merge when checks pass. All merges require a manual click. Consider leaving `true` for repos where Renovate auto-merge is desired (can override per-repo)._
>
> **Repos affected:** [list repo names]
> **Apply to all, or review per-repo?**

If the user wants per-repo control, iterate. Otherwise batch apply:

```bash
for repo in {list}; do
  gh api --method PATCH /repos/{org}/$repo \
    -F has_wiki=false \
    -F has_projects=false \
    -F has_discussions=false \
    -F delete_branch_on_merge=true \
    -F allow_auto_merge=false
done
```

### 5.4 Enable Dependabot alerts and security updates

Present with impact note:

> **Enable Dependabot alerts and security updates** for [N] repos:
>
> _Impact: You will start receiving security vulnerability alerts for dependencies. Dependabot will automatically open PRs to fix known vulnerabilities. This adds PR volume — expect a burst of initial PRs for existing vulnerabilities, then a steady trickle. Works alongside Renovate without conflict (Renovate handles version updates; Dependabot handles security patches)._
>
> **Repos affected:** [list]
> **Enable?**

For each repo where Dependabot is not enabled:

```bash
for repo in {list}; do
  # Enable vulnerability alerts (Dependabot alerts)
  gh api --method PUT /repos/{org}/$repo/vulnerability-alerts
  # Enable automated security fixes (Dependabot security updates)
  gh api --method PUT /repos/{org}/$repo/automated-security-fixes
done
```

### 5.5 Create rulesets on main

For each repo missing branch protection or rulesets on `main`, present with impact notes:

> **Create branch ruleset on `main`** for [repo name]:
>
> - Require PR with 1 approving review
>   _Impact: **No more direct pushes to main.** All changes require a branch, PR, review, merge workflow. This is the biggest daily habit change._
>
> - Dismiss stale reviews on push
>   _Impact: Pushing new commits after approval invalidates the review — you need a fresh approval. Prevents post-approval code injection but adds friction to iterative PRs._
>
> - Require conversation resolution
>   _Impact: All review threads must be marked "resolved" before merge. Prevents merging with unaddressed feedback._
>
> - Block force pushes and deletions
>   _Impact: Cannot `git push --force` or delete the `main` branch. Protects history integrity._
>
> - Required status checks: [list detected checks, or empty]
>   _Impact: PR cannot merge until these CI checks pass. If a check is flaky, it blocks all merges._
>
> _Bypass actors: none by default. Add org owners for emergency bypasses?_
>
> **Apply this ruleset?**

```bash
gh api --method POST /repos/{org}/{repo}/rulesets \
  --input - << 'EOF'
{
  "name": "main-protection",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": {
      "include": ["refs/heads/main"],
      "exclude": []
    }
  },
  "rules": [
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 1,
        "dismiss_stale_reviews_on_push": true,
        "require_last_push_approval": false,
        "required_review_thread_resolution": true
      }
    },
    {
      "type": "required_status_checks",
      "parameters": {
        "strict_required_status_checks_policy": false,
        "required_status_checks": []
      }
    },
    {
      "type": "non_fast_forward"
    },
    {
      "type": "deletion"
    }
  ],
  "bypass_actors": []
}
EOF
```

**Note:** The `required_status_checks` array should be populated with the actual CI check names from each repo. Inspect the repo's recent check runs:

```bash
gh api /repos/{org}/{repo}/commits/main/check-runs --jq '.check_runs[].name' | sort -u
```

Present the list and ask which checks to require. Warn: _Including a check that doesn't run on every PR (e.g., a deploy check that only runs on `main`) will block all PRs. Only include checks that run on pull request events._

### 5.6 Create CODEOWNERS file

For each repo missing CODEOWNERS, present with impact note:

> **Create CODEOWNERS** for [repo name]:
>
> _Impact: PRs touching `.github/`, `package.json`, lockfiles, or `renovate.json` will require review from the designated team. If the team has no members or doesn't exist, PRs touching these paths will be blocked waiting for review from nobody — **the team must exist and have members before creating this file.**_
>
> **Create CODEOWNERS?**

```bash
# First check if the designated team exists
gh api /orgs/{org}/teams --jq '.[].slug' | grep -i security
```

If the team doesn't exist, ask the user what team name to use, or offer to skip CODEOWNERS until the team is set up.

```bash
gh api --method PUT /repos/{org}/{repo}/contents/.github/CODEOWNERS \
  --input - << EOF
{
  "message": "chore: add CODEOWNERS for security review requirements",
  "content": "$(echo '# Require review for workflow and CI changes\n.github/                @{org}/{team}\n\n# Require review for dependency changes\npackage.json            @{org}/{team}\npackage-lock.json       @{org}/{team}\npnpm-lock.yaml          @{org}/{team}\nrenovate.json           @{org}/{team}' | base64 -w0)"
}
EOF
```

Substitute `{team}` with the team name confirmed by the user.

### 5.7 Create SECURITY.md

> **Create SECURITY.md?**
>
> _Impact: No functional impact — purely informational. Adds a security reporting policy visible in the repo's "Security" tab. Creating it in the org-level `.github` repo applies it to all repos that don't have their own. No downside._
>
> **Create per-repo or org-wide (`.github` repo)?**

For org-wide:

```bash
gh api --method PUT /repos/{org}/.github/contents/SECURITY.md \
  --input - << EOF
{
  "message": "chore: add org-wide security policy",
  "content": "$(echo '# Security Policy\n\n## Reporting a Vulnerability\n\nIf you discover a security vulnerability, please report it responsibly.\n\n**Email:** security@esolia.co.jp\n**Response time:** We aim to acknowledge reports within 48 hours.\n\nPlease do not open public issues for security vulnerabilities.' | base64 -w0)"
}
EOF
```

This requires the `.github` repo to exist in the org. If it doesn't, ask the user if they want to create it:

```bash
gh repo create {org}/.github --private --description "Org-level community health files"
```

## Phase 6: Post-hardening summary

After all changes are applied, re-run the Phase 2 and Phase 3 audit commands to verify the new state. Append a "Post-Hardening Verification" section to the audit report showing before/after.

Confirm the report path to the user and provide a count of changes made.

## Reference guide

The companion hardening guide with threat models, code examples, and monorepo patterns is available via the eSolia Standards MCP:

```
eSolia Standards:get_standard({ slug: "github-actions-security-hardening" })
```

The GitHub Actions-specific audit can be run separately with the `audit-github-actions` slash command.
