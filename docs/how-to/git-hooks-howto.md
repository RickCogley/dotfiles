# Git Hooks and Code Formatting Setup Guide

This guide explains how to set up automated code formatting and quality checks using a **modular git hooks system** with intelligent configuration precedence. The approach provides sensible defaults while allowing per-project customization and easy extensibility.

## Table of Contents

- [Overview](#overview)
- [The Configuration Precedence System](#the-configuration-precedence-system)
- [Modular Hooks Architecture](#modular-hooks-architecture)
- [Quick Start](#quick-start)
- [Installation Methods](#installation-methods)
- [Configuration Files](#configuration-files)
- [Managing Individual Hooks](#managing-individual-hooks)
- [Troubleshooting](#troubleshooting)
- [Advanced Usage](#advanced-usage)

## Overview

### The Problem

Different projects need different code formatting rules, but you want:
- **Consistent defaults** across your projects
- **Per-project customization** when needed
- **Zero setup** for new projects
- **Team collaboration** without configuration conflicts

### The Solution

A **universal git hook** with inline defaults that automatically defers to local configuration files when they exist. This gives you:

✅ **One script works everywhere** - no per-project customization needed  
✅ **Smart precedence** - config files override script defaults automatically  
✅ **Gradual adoption** - start simple, add configs when needed  
✅ **Team friendly** - commit configs for consistent team formatting  

## The Configuration Precedence System

Understanding how tools resolve configuration is key to this approach:

### Priority Order (High to Low)

1. **Command line arguments** - `prettier --print-width=120`
2. **Project config files** - `.prettierrc` in repo root
3. **Global config files** - `~/.prettierrc` in home directory  
4. **Built-in tool defaults** - what the tool uses if no config found

### How Our Approach Works

```bash
# Our git hook runs:
prettier --write '**/*.md' --print-width=100 --prose-wrap=preserve

# What actually happens:
# ✅ Project has .prettierrc? → Uses .prettierrc, ignores command line
# ✅ Global ~/.prettierrc exists? → Uses ~/.prettierrc, ignores command line
# ✅ No config files? → Uses command line args (our sensible defaults)
```

This means **one hook script provides defaults but respects local preferences**.

## Modular Hooks Architecture

### The Structure

The git hooks system creates a modular, extensible structure:

```
.githooks/
├── pre-commit                 # Orchestrator (runs all enabled hooks)
├── hooks.d/                   # Individual hook scripts
│   ├── 10-format-code        # ✅ Code formatting (enabled)
│   ├── 20-lint-markdown      # ✅ Markdown linting (enabled)
│   ├── 30-run-tests          # ⏸️  Tests (disabled by default)
│   └── 40-security-check     # ⏸️  Security scanning (disabled by default)
└── lib/
    └── common.sh             # 📚 Shared functions and utilities
```

### How It Works

1. **Git calls** `.githooks/pre-commit` (the orchestrator)
2. **Orchestrator runs** all executable scripts in `hooks.d/` in alphabetical order
3. **Each hook** focuses on one specific task (formatting, linting, testing, etc.)
4. **Numbering system** (10-, 20-, 30-) controls execution order
5. **Enable/disable** hooks by making them executable/non-executable

### Benefits

✅ **Modular** - Add/remove specific checks easily  
✅ **Ordered** - Number prefixes ensure proper execution sequence  
✅ **Selective** - Enable only the hooks you need per project  
✅ **Extensible** - Add custom hooks as simple shell scripts  
✅ **Debuggable** - Run individual hooks manually for testing  
✅ **Team-friendly** - Different team members can have different hook preferences  

### Hook Management

```bash
# Enable optional hooks
chmod +x .githooks/hooks.d/30-run-tests
chmod +x .githooks/hooks.d/40-security-check

# Disable specific hooks
chmod -x .githooks/hooks.d/20-lint-markdown

# Add custom hook
cat > .githooks/hooks.d/50-custom-check << 'EOF'
#!/bin/sh
echo "Running my custom check..."
# Your custom logic here
EOF
chmod +x .githooks/hooks.d/50-custom-check

# Test individual hook
.githooks/hooks.d/10-format-code

# See which hooks are enabled
ls -la .githooks/hooks.d/
```

## Quick Start

### 1. Basic Installation

For a new project, get instant formatting with sensible defaults:

```bash
# From any git repository
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash
```

### 2. What You Get

- ✅ **Modular git hooks system** with orchestrator and individual hook scripts
- ✅ **Code formatting** (TypeScript/JavaScript with Deno or Prettier, Markdown with Prettier)
- ✅ **Markdown linting** with markdownlint-cli2
- ✅ **Optional hooks** for tests and security checks (disabled by default)
- ✅ **Easy extensibility** - add custom hooks as executable scripts
- ✅ **Sensible defaults** for line length, spacing, etc.

### 3. Test It

```bash
# Make a change
echo "# test" >> README.md

# Commit - you'll see the formatting happen
git add README.md
git commit -m "test formatting"
```

## Installation Methods

### Method 1: Interactive Installer (Recommended)

```bash
# Local installation (if you have dotfiles repo)
~/.dotfiles/adhoc/setup-git-hooks.sh

# Remote installation  
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash
```

**Features:**
- Detects project type automatically
- Prompts for what you want to install
- Handles permissions and git config

### Method 2: Automated Installation

For scripts or when you know what you want:

```bash
# Install hook only (uses inline defaults)
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash -s --auto

# Install hook + config files
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash -s --auto --configs

# Specify project type
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash -s --auto --type=deno --configs
```

### Method 3: Manual Installation

```bash
# Create hooks directory
mkdir -p .githooks

# Download and install hook
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/git/hooks/pre-commit-universal -o .githooks/pre-commit
chmod +x .githooks/pre-commit

# Configure git to use the hooks
git config core.hooksPath .githooks
```

### Method 4: Shell Aliases

Add to your `~/.zshrc` or `~/.bashrc`:

```bash
# Quick project setup aliases
alias setup-hooks='curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash'
alias setup-full='curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/setup-git-hooks.sh | bash -s --auto --configs'
```

## Configuration Files

### When to Use Config Files

**Use inline defaults** (no config files) when:
- Quick personal projects
- Prototypes and experiments  
- You're happy with the defaults

**Add config files** when:
- Working with a team (commit configs for consistency)
- Project has specific requirements (different line length, etc.)
- Integrating with existing project standards

### Available Config Files

#### `.prettierrc` - Code and Markdown Formatting

Controls formatting for JavaScript, TypeScript, Markdown, JSON, YAML:

```json
{
  "printWidth": 100,
  "tabWidth": 2,
  "semi": true,
  "singleQuote": false,
  "proseWrap": "preserve",
  "overrides": [
    {
      "files": "*.md", 
      "options": {
        "printWidth": 100,
        "proseWrap": "preserve"
      }
    }
  ]
}
```

#### `.markdownlint-cli2.jsonc` - Markdown Linting Rules

Controls markdown quality and consistency checking:

```jsonc
{
  "config": {
    // Line length - disabled for code blocks and tables
    "MD013": {
      "line_length": 100,
      "code_blocks": false,
      "tables": false
    },
    // Allow inline HTML (for flexibility)
    "MD033": false,
    // Don't require H1 as first line
    "MD041": false
  },
  "globs": ["**/*.md"],
  "ignores": ["node_modules/", "CHANGELOG.md"]
}
```

### Installing Config Files

```bash
# Get the standard config files
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/configs/.prettierrc -o .prettierrc
curl -fsSL https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc/configs/.markdownlint-cli2.jsonc -o .markdownlint-cli2.jsonc

# Or use the installer
./setup-project.sh --configs
```

## Troubleshooting

### Hook Not Running

**Check if hook is installed:**
```bash
ls -la .githooks/pre-commit
git config core.hooksPath
```

**Expected output:**
```
-rwxr-xr-x  1 user  staff  2.1K  .githooks/pre-commit
.githooks
```

**Fix:**
```bash
chmod +x .githooks/pre-commit
git config core.hooksPath .githooks
```

### Tools Not Found

**Install required tools:**
```bash
# macOS
brew install deno prettier markdownlint-cli2

# Or check what's missing
which deno prettier markdownlint-cli2
```

### VS Code Conflicts

If VS Code flags markdown issues after formatting:

1. **Install markdownlint extension** for VS Code
2. **Add to VS Code settings** (`.vscode/settings.json`):

```json
{
  "markdownlint.config": {
    "MD013": { "line_length": 100, "code_blocks": false },
    "MD033": false,
    "MD041": false
  },
  "[markdown]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  }
}
```

### Hook Fails on Commit

**Debug the hook:**
```bash
# Run hook manually to see errors
.githooks/pre-commit

# Check git status
git status

# See what files would be affected  
git diff --name-only
```

**Common issues:**
- Permission denied → `chmod +x .githooks/pre-commit`
- Tool not found → Install missing tools
- Config file syntax error → Validate JSON/JSONC

## Advanced Usage

### Bypassing Hooks Temporarily

```bash
# Skip hooks for emergency commits
git commit --no-verify -m "emergency fix"

# Skip hooks for work-in-progress
git commit --no-verify -m "WIP: debugging"
```

### Team Adoption Strategy

1. **Phase 1**: Install hooks with inline defaults
2. **Phase 2**: Add config files and commit them
3. **Phase 3**: Team members run installer to get same setup
4. **Phase 4**: Customize configs for project needs

### Multiple Project Types

For projects mixing multiple languages:

```bash
# The universal hook handles multiple languages automatically
# It detects: Deno, Node.js, Rust, Python, Go
# And formats each with appropriate tools
```

### Custom Configuration Per Project

Override defaults by creating local config files:

```bash
# Tighter line limits for documentation
echo '{"printWidth": 80}' > .prettierrc

# More strict markdown linting
echo '{"config": {"MD013": {"line_length": 80}}}' > .markdownlint-cli2.jsonc
```

### Global Defaults

Set personal defaults in your home directory:

```bash
# Your personal formatting preferences
cp ~/dotfiles/adhoc/configs/.prettierrc ~/.prettierrc
cp ~/dotfiles/adhoc/configs/.markdownlint-cli2.jsonc ~/.markdownlint-cli2.jsonc
```

### Continuous Integration

The same hook works in CI environments:

```yaml
# .github/workflows/quality.yml
name: Code Quality
on: [push, pull_request]
jobs:
  format-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install tools
        run: |
          npm install -g prettier markdownlint-cli2
          curl -sSfL https://deno.land/install.sh | sh
      - name: Check formatting
        run: .githooks/pre-commit
```

## Summary

This approach gives you:

- **Zero-configuration defaults** that work everywhere
- **Intelligent precedence** that respects local preferences
- **Team collaboration** through committed config files
- **Gradual complexity** - start simple, add configs when needed
- **Tool consistency** - same formatting rules across all projects

The key insight is leveraging how formatting tools naturally resolve configuration, allowing one script to provide smart defaults while remaining flexible for customization.

**Start simple** with just the git hook, then **add config files** when you need project-specific settings. The system grows with your needs while maintaining consistency.
