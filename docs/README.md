# Dotfiles Documentation

This documentation follows the [Diátaxis framework](https://diataxis.fr/) combined with [Google's developer documentation style guide](https://developers.google.com/style). The documentation is organized into four distinct categories to serve different user needs.

## Documentation Structure

### 🎓 [Tutorials](tutorials/)
Learning-oriented guides that take you through setting up and using these dotfiles from scratch.

- [Getting started with dotfiles](tutorials/getting-started.md) - First-time setup guide
- [Customizing your shell environment](tutorials/customizing-shell.md) - Personalize your terminal experience

### 🔧 [How-to Guides](how-to/)
Task-oriented recipes for solving specific problems.

- [How to add a new git alias](how-to/add-git-alias.md)
- [How to configure GPG signing](how-to/configure-gpg-signing.md)
- [How to update shell plugins](how-to/update-shell-plugins.md)
- [How to backup and restore settings](how-to/backup-restore.md)

### 📖 [Reference](reference/)
Information-oriented technical descriptions of components.

- [Git configuration reference](reference/git-config.md)
- [Zsh configuration reference](reference/zsh-config.md)
- [Environment variables reference](reference/environment-variables.md)
- [Directory structure reference](reference/directory-structure.md)

### 💡 [Explanations](explanations/)
Understanding-oriented discussions of concepts and architecture.

- [Understanding dotfiles architecture](explanations/architecture.md)
- [Why GNU Stow for dotfile management](explanations/gnu-stow.md)
- [Shell startup sequence explained](explanations/shell-startup.md)
- [Security considerations](explanations/security.md)

## Quick Start

If you're new to these dotfiles:
1. Start with the [Getting started tutorial](tutorials/getting-started.md)
2. Review the [Architecture explanation](explanations/architecture.md) to understand the structure
3. Check the [How-to guides](how-to/) for specific tasks

## Project Overview

This dotfiles repository provides a comprehensive, modular configuration system for macOS development environments. Key features include:

- **GNU Stow-based management** - Symlink management for easy installation/removal
- **Modular organization** - Separate configurations for git, zsh, vim, etc.
- **Security-first approach** - GPG signing, secure credential storage
- **Cross-machine compatibility** - Works across different macOS systems
- **Version controlled** - Track changes and rollback when needed

## Prerequisites

- macOS 12.0 or later
- Homebrew package manager
- Git 2.32 or later
- GNU Stow 2.3 or later

## Support

For issues or questions:
- Check the [troubleshooting guide](how-to/troubleshooting.md)
- Review [security considerations](explanations/security.md)
- Submit issues on the project repository