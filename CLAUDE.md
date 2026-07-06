# CLAUDE.md — dotfiles repo

Personal dotfiles for Rick Cogley, managed with GNU Stow. Each top-level
directory is a stow package whose contents mirror the home directory layout
(e.g. `claude/.claude/settings.json` → `~/.claude/settings.json`).

## Key packages

- `claude/` — Claude Code global config: `settings.json`, global `CLAUDE.md`,
  `commands/` (skills), `rules/` (always-loaded rules)
- `zsh/`, `git/`, `gpg/` — shell, git, and GPG configuration

## Conventions

- `claude/.claude/rules/change-management.md` mirrors the canonical rule in
  `eSolia/devkit` `.claude/shared-rules/`; update devkit first, then mirror here.
- Rules in `claude/.claude/rules/` load automatically (optionally path-scoped
  via `paths:` frontmatter). Reference material that is only needed on demand
  belongs in `commands/` as a skill, not in `rules/`.
- Changes follow the standard issue → branch → PR → merge → verify workflow.
- Never commit secrets; tokens live in `~/.ssh/tokens/` (untracked).
