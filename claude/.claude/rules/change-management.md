# Change Management Rule (ISO 27001)

> **Provenance.** This global copy mirrors the canonical rule at
> `eSolia/devkit` → `.claude/shared-rules/change-management.md`, which is
> auto-synced into consumer repos' `.claude/rules/`. This dotfiles copy is
> **not** a devkit consumer, so it does not update automatically. When the
> canonical rule changes, update it there first, then mirror the change here.
> If the two diverge, the devkit `shared-rules` copy wins.

All code and content changes must follow a traceable workflow that an auditor can verify: **issue → branch → PR → merge → verify**.

## Standard Workflow

Every change that modifies behavior, configuration, content, or dependencies:

1. **Issue first.** Create a GitHub issue describing the change before starting work. Use the `change-request` issue template. If an issue already exists, reference it.
2. **Branch.** Create a feature branch from `main` named `{type}/{short-description}` (e.g., `feat/engagement-model`, `fix/ja-em-dash-cleanup`).
3. **Work.** Make changes on the branch. Run the project's verify/preflight checks before committing.
4. **PR.** Create a pull request linking to the issue with `Closes #N` or `Fixes #N` in the body. PR body must include a Summary and Test Plan.
5. **Merge.** Merge with `gh pr merge --admin --merge --delete-branch` (org policy blocks auto-merge; admin override is authorized for the repo owner).
6. **Post-merge verification.** After every merge to main:
   - Check GitHub CI: `gh run list --limit 3`
   - Check Cloudflare build logs (if the repo deploys to CF): verify the build succeeds and deploy completes
   - Check Dependabot: `gh api repos/{owner}/{repo}/dependabot/alerts --jq '[.[] | select(.state=="open")] | length'` — address any new alerts
7. **Release.** Releases are created periodically (not per-change) via `gh release create` with hand-written notes. The release cadence is at the developer's discretion.

## Branching correctly

The `git push -u origin <branch>` in step 2 of the Standard Workflow does **not** reliably push to a remote branch of the same name. What it actually does is push to whatever upstream the local branch is tracking. If the branch was created in a way that sets the upstream to `origin/main`, a push meant for a feature branch lands directly on `main` — bypassing the whole PR process. This has happened in production; it's quiet and easy to miss.

**Correct patterns:**

```bash
# From an already-up-to-date local main:
git switch main && git pull --ff-only
git switch -c feat/whatever
# ...work...
git push -u origin HEAD          # creates origin/feat/whatever

# Or equivalently:
git checkout -b feat/whatever
git push -u origin HEAD
```

**The incorrect pattern that causes the direct-push incident:**

```bash
# ✗ Don't do this:
git checkout origin/main -b feat/whatever
# Upstream is now origin/main. A later `git push -u origin feat/whatever`
# pushes to origin/main, not to a new remote branch.
```

If you genuinely need `origin/<something>` as the starting point, use `--no-track` to avoid inheriting its upstream:

```bash
git switch -c feat/whatever origin/main --no-track
```

**Pre-push sanity check** before your first push on a new branch:

```bash
git branch -vv
# The line for your current branch should NOT show [origin/main] or any
# [origin/something-else] upstream. An unset upstream (no brackets) is
# what you want on a fresh feature branch.
```

If `git branch -vv` shows an upstream set to a branch you didn't intend (typically `origin/main`), fix it before pushing:

```bash
git branch --unset-upstream
git push -u origin HEAD
```

## Client review branches (dev / staging)

The default flow above — feature branch → `main` — applies to most changes (including Dependabot and other dependency/security bumps, which route straight to `main`, no client preview). Some clients, however, want to **preview a change before it goes live**. For those repos we keep a long-lived **review branch** wired to a stable preview deployment, so the client always reviews at the **same URL** instead of a new per-change preview link.

**Which branch is the review branch is per-repo, not universal:** some use `dev`, some use `staging`. Each repo that uses this flow declares its review branch in `.claude/rules/local/branch-strategy.md`. If that file is absent, the repo follows the plain feature → `main` flow with no review branch. A repo's production branch is not always `main` either; the local file states that too. Read it before branching.

**Flow when a change needs client review:**

1. **Issue + feature branch** as normal (`{type}/{short-description}` from the production branch).
2. **PR the feature branch into the review branch** (`dev` or `staging`), not into `main`. Merging deploys it to the fixed preview URL.
3. **Client reviews at the stable preview URL.** Iterate on the feature branch and re-merge to the review branch until approved.
4. **Promote to production.** Once the client approves, merge to the production branch via PR, so the approval is captured in the evidence chain (note the approval in the promoting PR).
5. **Post-merge verification** as in the Standard Workflow.

**Keep the review branch and production reconciled.** Changes land on the review branch first, so `dev`/`staging` can drift ahead of `main`. After promoting, make sure nothing approved is left stranded on the review branch. After a direct-to-`main` change (e.g. Dependabot), refresh the review branch from `main` so it stays even. The review branch is a preview staging area, not a second trunk.

## Fast Track (Exceptions)

These changes may go directly to `main` without an issue or PR:

- Single-file typo corrections
- Whitespace/formatting-only changes (e.g., Prettier runs)
- Cosmetic copy edits that don't change meaning

Fast-track changes still require:
- A descriptive conventional commit message
- The InfoSec/quality annotation line
- Post-push CI verification

## Conventional Commits

All commits must follow the conventional commits format:

```
type(scope): description

Body explaining the change (if needed).

InfoSec: [security/quality/privacy consideration]
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

**InfoSec line** — required for all changes. Examples:
- `InfoSec: input validation added for user-supplied query parameters`
- `InfoSec: no security impact — content-only change`
- `InfoSec: dependency update addresses CVE-2026-XXXX`
- `Quality: writing standards compliance — em dash removal per localization guide`
- `Privacy: no PII handling changes`

If a change has no security, quality, or privacy implications, state that explicitly. The purpose is auditability, not bureaucracy.

## Rationale

This workflow produces the evidence chain that ISO 27001 (A.8.9 Configuration Management, A.8.25 Secure Development Lifecycle, A.8.32 Change Management) requires:

- **Change request** → GitHub issue with description and acceptance criteria
- **Authorization** → PR review and merge approval
- **Testing** → CI checks (lint, typecheck, test, security scan)
- **Implementation** → Commits on feature branch
- **Verification** → Post-merge CI and deploy confirmation
- **Release** → Tagged release with changelog

An auditor can trace any production change from release → PR → issue → commits → CI results.
