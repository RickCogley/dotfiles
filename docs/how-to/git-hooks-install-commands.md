# Git Hooks Installation Commands Reference

Quick reference for all installation methods and commands for the modular git hooks system.

## Basic Installation

### Recommended: Simple Piped Installation

```bash
# Basic setup (hooks + config files, auto-detected project type)
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash
```

### Interactive Installation

```bash
# Download and run interactively for full control
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh -o setup-git-hooks.sh
chmod +x setup-git-hooks.sh
./setup-git-hooks.sh

# Or from local dotfiles
~/.dotfiles/adhoc/setup-git-hooks.sh
```

## Advanced Installation Options

### Explicit Control

```bash
# Hooks only (no config files)
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash -s --auto

# Full setup (explicit)
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash -s --auto --configs

# Force overwrite existing files
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash -s --auto --configs --force

# Update existing setup
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash -s --update
```

### Project-Specific Setup

```bash
# Deno/TypeScript project
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash -s --auto --type=deno --configs

# Node.js project  
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash -s --auto --type=node --configs

# Rust project
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash -s --auto --type=rust --configs

# Python project
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash -s --auto --type=python --configs

# Go project
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash -s --auto --type=go --configs
```

## Manual Installation

### Complete Manual Setup

```bash
# Create directory structure
mkdir -p .githooks/hooks.d .githooks/lib

# Download all components
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/git/hooks/pre-commit-orchestrator -o .githooks/pre-commit
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/git/hooks/lib/common.sh -o .githooks/lib/common.sh
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/git/hooks/10-format-code -o .githooks/hooks.d/10-format-code
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/git/hooks/20-lint-markdown -o .githooks/hooks.d/20-lint-markdown
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/git/hooks/30-run-tests -o .githooks/hooks.d/30-run-tests
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/git/hooks/40-security-check -o .githooks/hooks.d/40-security-check

# Set permissions (enable core hooks, disable optional hooks)
chmod +x .githooks/pre-commit
chmod +x .githooks/hooks.d/10-format-code
chmod +x .githooks/hooks.d/20-lint-markdown
chmod -x .githooks/hooks.d/30-run-tests
chmod -x .githooks/hooks.d/40-security-check

# Configure git
git config core.hooksPath .githooks
```

### Individual Hook Installation

```bash
# Install specific hooks only
mkdir -p .githooks/hooks.d .githooks/lib

# Get the library (required for all hooks)
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/git/hooks/lib/common.sh -o .githooks/lib/common.sh

# Install just formatting
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/git/hooks/10-format-code -o .githooks/hooks.d/10-format-code
chmod +x .githooks/hooks.d/10-format-code

# Install just testing
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/git/hooks/30-run-tests -o .githooks/hooks.d/30-run-tests
chmod +x .githooks/hooks.d/30-run-tests

# Install just security checks
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/git/hooks/40-security-check -o .githooks/hooks.d/40-security-check
chmod +x .githooks/hooks.d/40-security-check
```

## Configuration Files Only

```bash
# Install just the config files (no hooks)
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/configs/.prettierrc -o .prettierrc
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/configs/.markdownlint-cli2.jsonc -o .markdownlint-cli2.jsonc
```

## Shell Aliases

Add these to your `~/.zshrc` or `~/.bashrc` for quick access:

```bash
# Basic setup
alias setup-hooks='curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash'

# Full setup with configs
alias setup-hooks-full='curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash -s --auto --configs'

# Update existing setup
alias update-hooks='curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash -s --update'

# Interactive setup
alias setup-hooks-interactive='curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh -o setup-git-hooks.sh && chmod +x setup-git-hooks.sh && ./setup-git-hooks.sh'
```

## Troubleshooting Commands

```bash
# Check what's installed
ls -la .githooks/
ls -la .githooks/hooks.d/
git config core.hooksPath

# Test individual hooks
.githooks/hooks.d/10-format-code
.githooks/hooks.d/20-lint-markdown

# Run full pre-commit sequence
.githooks/pre-commit

# Enable optional hooks
chmod +x .githooks/hooks.d/30-run-tests
chmod +x .githooks/hooks.d/40-security-check

# Disable specific hooks
chmod -x .githooks/hooks.d/20-lint-markdown
```

## Copy Commands for Local Development

```bash
# Copy from local dotfiles (if you have the repo cloned)
mkdir -p .githooks/hooks.d .githooks/lib
cp ~/.dotfiles/adhoc/git/hooks/pre-commit-orchestrator .githooks/pre-commit
cp ~/.dotfiles/adhoc/git/hooks/lib/common.sh .githooks/lib/
cp ~/.dotfiles/adhoc/git/hooks/10-format-code .githooks/hooks.d/
cp ~/.dotfiles/adhoc/git/hooks/20-lint-markdown .githooks/hooks.d/
cp ~/.dotfiles/adhoc/configs/.prettierrc .
cp ~/.dotfiles/adhoc/configs/.markdownlint-cli2.jsonc .
chmod +x .githooks/pre-commit .githooks/hooks.d/*
git config core.hooksPath .githooks
```
