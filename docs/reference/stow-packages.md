# Stow package manifest

Each top-level directory in this repo is a [GNU Stow](https://www.gnu.org/software/stow/)
package whose contents mirror the home-directory layout. `stow <pkg>` symlinks a
package into `~`; `stow -D <pkg>` removes it.

This manifest records what each package configures and whether it is currently
**stowed** (symlinked into `~`). "Not stowed" does not always mean "dead" — a few
packages are kept in the repo but deliberately managed outside stow (see notes).

Last audited: 2026-08-22.

## Active (stowed)

| Package | Configures | Notes |
|---|---|---|
| `zsh` | Zsh shell (`.zshrc`, functions, `.zprofile`…) | Primary shell |
| `claude` | Claude Code (`~/.claude`) | |
| `git` | Git (`~/.config/git`) | delta pager, aliases |
| `starship` | Starship prompt | Active prompt |
| `ssh` | SSH client config | |
| `shell` | Shared `~/bin` scripts (`claude-scan`, `44brew`…) | |
| `stow` | Stow's own config | |
| `bat` | bat (cat replacement) config | |
| `ghostty` | Ghostty terminal | Current terminal (replaced kitty/iterm2, #12) |
| `zed` | Zed editor | |
| `vim` | Vim | |

## Present but intentionally not stowed

| Package | Configures | Why kept |
|---|---|---|
| `bash` | Bash (`.bashrc`, `.bash_profile`, `.fzf.bash`) | Fallback shell; some contexts still require bash |
| `gpg` | GnuPG (`~/.gnupg`) | `~/.gnupg` is a real dir (holds sockets/runtime state that must not be symlinked); managed directly, not via stow |
| `nerd-fonts` | Patched Nerd Font archives (`.gpg`) | One-time install artifacts, not live config |
| `adhoc` | Misc linter configs (markdownlint…) | Referenced ad hoc |
| `vscode` | VS Code settings | `code` CLI installed (2026-08); stow if you want it managed |
| `tmux` | tmux config (`~/.config/tmux`) | tmux installed (2026-08) but config not stowed — stow it or drop the package |

## Removed

Deleted from the repo on 2026-08-22 (all experiments no longer in use; still
recoverable from git history if ever needed):

`oni2` (Onivim 2), `gqrx` (SDR GUI), `twty` (Twitter CLI), `valet` (Laravel
Valet), `vnote` (note app), `jgit`, `streamdeck` (Elgato profile),
`karabiner` (key remapping — used previously, unstowed), `hammerspoon`
(automation — used previously, unstowed).

## Archived

Moved under `archive/` (kept for reference, never stowed):

| Package | Was | Retired |
|---|---|---|
| `nushell` | Nushell config | 2026-08-22 — back on zsh |
| `liquidprompt` | Liquidprompt prompt | 2026-08-22 — replaced by Starship |
| `archive/zsh`, `archive/nvim`, `archive/homemaker` | Older prezto/prompt-cogger, nvim, homemaker configs | Prior |

## Re-auditing

```sh
# Which packages are symlinked into ~ (walks folded dirs):
for pkg in */; do
  pkg=${pkg%/}
  [ "$pkg" = archive ] || [ "$pkg" = docs ] && continue
  # ...see the probe used in the 2026-08-22 audit
done
```

When adding a package, add a row here. When a tool is uninstalled, move its
package to `archive/` or delete it, and update this file.
