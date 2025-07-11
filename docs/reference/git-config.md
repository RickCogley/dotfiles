# Git Configuration Reference

## Overview

Git configuration for this dotfiles setup, providing aliases, tools integration, and security settings.

## Synopsis

```
~/.gitconfig                 # Main configuration (symlinked)
~/.config/git/ignore        # Global ignore patterns
~/.gitmessage              # Commit message template
```

## Configuration Sections

### `[user]` {#user}

Identifies you as the author of commits.

**Fields:**

- `name` - Your full name displayed in commits
- `email` - Email address for commit attribution  
- `signingKey` - GPG key fingerprint for commit signing

**Example:**
```gitconfig
[user]
    name = Your Name
    email = your.email@example.com
    signingKey = E8404D8E8DAB59CD1E5255BD56BCDEBC6448A091
```

### `[core]` {#core}

Core Git behavior settings.

**Fields:**

#### `autocrlf` {#autocrlf}
**Type**: `true` | `false` | `input`  
**Default**: `false`  
**Current**: `input`

Controls line ending conversion. `input` converts CRLF to LF on commit but not on checkout (recommended for macOS/Linux).

#### `safecrlf` {#safecrlf}
**Type**: `true` | `false` | `warn`  
**Default**: `false`  
**Current**: `true`

Prevents commits with mixed line endings when enabled.

#### `editor` {#editor}
**Type**: `string`  
**Current**: `code --new-window --wait`

Default editor for commit messages and interactive operations.

#### `excludesfile` {#excludesfile}
**Type**: `path`  
**Current**: `~/.gitignore_global`

Path to global gitignore file.

#### `pager` {#pager}
**Type**: `string`  
**Current**: `bat`

Program used to page through output (logs, diffs, etc.).

### `[alias]` {#alias}

Custom shortcuts for Git commands.

**Available Aliases:**

| Alias | Expands To | Description |
|-------|------------|-------------|
| `co` | `checkout` | Switch branches or restore files |
| `ci` | `commit` | Record changes to repository |
| `st` | `status` | Show working tree status |
| `br` | `branch` | List, create, or delete branches |
| `hist` | `log --pretty=format:"%h %ad \| %s%d [%an]" --graph --date=short` | Graphical history view |
| `type` | `cat-file -t` | Show object type |
| `dump` | `cat-file -p` | Show object content |

### `[diff]` & `[difftool]` {#diff}

Diff viewing configuration.

**Fields:**
- `tool` - External diff tool (`code`)

**VSCode Difftool Config:**
```gitconfig
[difftool "code"]
    cmd = code --wait --new-window --diff $LOCAL $REMOTE
```

### `[merge]` & `[mergetool]` {#merge}

Merge conflict resolution settings.

**Fields:**
- `tool` - External merge tool (`code`)

**VSCode Mergetool Config:**
```gitconfig
[mergetool "code"]
    cmd = code --wait --new-window --merge $REMOTE $LOCAL $BASE $MERGED
```

### `[push]` {#push}

Push behavior configuration.

**Fields:**
- `default` - Push strategy
  - `tracking` - Push to upstream branch
  - `current` - Push current branch
  - `simple` - Default in Git 2.0+

### `[pull]` {#pull}

Pull behavior settings.

**Fields:**
- `rebase` - Rebase instead of merge
  - `true` - Always rebase
  - `false` - Always merge
  - `interactive` - Interactive rebase

### `[filter]` {#filter}

Content filters for large files and media.

**LFS Filter:**
```gitconfig
[filter "lfs"]
    smudge = git-lfs smudge -- %f
    required = true
    clean = git-lfs clean -- %f
    process = git-lfs filter-process
```

### `[color]` {#color}

Output colorization settings.

**Fields:**
- `ui` - Enable colors
  - `auto` - Color when outputting to terminal
  - `always` - Always use colors
  - `never` - Never use colors

### `[branch]` {#branch}

Branch behavior configuration.

**Fields:**
- `autosetupmerge` - Auto-track remote branches
  - `true` - Set up tracking
  - `false` - No automatic tracking
  - `always` - Always set up tracking

### `[rerere]` {#rerere}

Reuse recorded resolution for merge conflicts.

**Fields:**
- `enabled` - Enable rerere
  - `true` - Record and reuse resolutions
  - `false` - Disabled

### `[commit]` {#commit}

Commit behavior settings.

**Fields:**
- `gpgsign` - Sign commits with GPG
  - `true` - Always sign
  - `false` - Don't sign
- `template` - Path to commit message template

### `[gpg]` {#gpg}

GPG signing configuration.

**Fields:**
- `format` - Signature format (`openpgp` or `x509`)

## Global Ignore Patterns

Located at `~/.config/git/ignore`:

```gitignore
# macOS
*.DS_Store
.AppleDouble
.LSOverride
Icon
._*

# Thumbnails
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent

# Directories on AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

# Claude local settings
**/.claude/settings.local.json

# Zsh compiled files
*.zwc
*.zwc.*
```

## Examples

### Basic Usage

```bash
# Check current configuration
git config --list

# Get specific setting
git config user.name

# Set configuration value
git config --global core.editor "vim"
```

### Using Aliases

```bash
# Instead of: git checkout feature-branch
git co feature-branch

# Instead of: git status
git st

# View pretty history
git hist
```

### External Tools

```bash
# Open diff in VSCode
git difftool HEAD~1

# Resolve merge conflicts in VSCode
git mergetool
```

## Environment Variables

Git respects these environment variables:

| Variable | Purpose | Example |
|----------|---------|---------|
| `GIT_EDITOR` | Override core.editor | `export GIT_EDITOR=vim` |
| `GIT_PAGER` | Override core.pager | `export GIT_PAGER=less` |
| `GIT_AUTHOR_NAME` | Override user.name | `export GIT_AUTHOR_NAME="Bot"` |
| `GIT_AUTHOR_EMAIL` | Override user.email | `export GIT_AUTHOR_EMAIL="bot@example.com"` |

## Security Considerations

1. **GPG Signing**: Commits are signed with the configured GPG key
2. **Credentials**: Stored in system keychain via credential helpers
3. **Tokens**: GitHub tokens stored in macOS keychain (see `[ghi]` section)
4. **SSH**: Prefer SSH URLs over HTTPS for better security

## See Also

- [Zsh configuration reference](zsh-config.md)
- [How to add git aliases](../how-to/add-git-alias.md)
- [How to configure GPG signing](../how-to/configure-gpg-signing.md)
- [Git documentation](https://git-scm.com/docs/git-config)