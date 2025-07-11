# Getting Started with Dotfiles

In this tutorial, you'll learn how to set up and use this dotfiles repository on a new macOS system. By the end, you'll have a fully configured development environment with version-controlled settings.

## Prerequisites

- macOS 12.0 or later
- Administrator access to your machine
- Basic familiarity with the terminal

## What you'll learn

- How to install required dependencies
- How to clone and set up the dotfiles repository
- How to apply configurations using GNU Stow
- How to verify your installation

## Step 1: Install Homebrew

First, install Homebrew, the package manager for macOS:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installation, add Homebrew to your PATH:

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

**Expected output:**
```
==> Installation successful!
==> Homebrew has enabled anonymous aggregate analytics
==> Next steps:
- Run these commands in your terminal to add Homebrew to your PATH
```

## Step 2: Install GNU Stow

Install GNU Stow to manage symlinks:

```bash
brew install stow
```

Verify the installation:

```bash
stow --version
```

**Expected output:**
```
stow (GNU Stow) version 2.3.1
```

## Step 3: Clone the Dotfiles Repository

Create a directory for your dotfiles and clone the repository:

```bash
cd ~
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

**Expected output:**
```
Cloning into '/Users/yourusername/.dotfiles'...
remote: Enumerating objects: 123, done.
remote: Counting objects: 100% (123/123), done.
```

## Step 4: Review Available Configurations

List the available configuration modules:

```bash
ls -la
```

You'll see directories like:
- `git/` - Git configuration and aliases
- `zsh/` - Zsh shell configuration
- `vim/` - Vim editor settings
- `homebrew/` - Homebrew packages and casks

## Step 5: Apply Basic Configurations

Start by applying the git configuration:

```bash
stow git
```

This creates symlinks from your home directory to the git configuration files.

**Important security step for Git configuration:**
```bash
# Copy the template to create your local config
cp ~/.gitconfig.local.template ~/.gitconfig.local

# Edit to add your personal GPG key (if you use commit signing)
$EDITOR ~/.gitconfig.local
```

Apply the shell configuration:

```bash
stow zsh
```

**Expected behavior:**
- `~/.gitconfig` → `~/.dotfiles/git/.gitconfig`
- `~/.gitconfig.local.template` → `~/.dotfiles/git/.gitconfig.local.template`
- `~/.config/git/ignore` → `~/.dotfiles/git/.config/git/ignore`
- `~/.zshrc` → `~/.dotfiles/zsh/.zshrc`
- `~/.zshenv` → `~/.dotfiles/zsh/.zshenv`

## Step 6: Install Shell Dependencies

The Zsh configuration uses the Znap plugin manager. Install required dependencies:

```bash
# Clone Znap
git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git ~/znap/zsh-snap

# Install Starship prompt
brew install starship
```

## Step 7: Restart Your Shell

Apply the new configuration by restarting your shell:

```bash
exec zsh
```

You should see your new prompt with the Starship theme.

## Step 8: Verify Your Installation

Check that configurations are properly linked:

```bash
# Check git configuration
git config --global user.name

# Check if aliases are loaded
git st  # Should work as 'git status'

# Check shell configuration
echo $ZDOTDIR  # Should show ~/.config/zsh
```

## Step 9: (Optional) Apply Additional Configurations

Apply other configurations as needed:

```bash
# Vim configuration
stow vim

# Homebrew bundle
stow homebrew
brew bundle --file=~/.config/homebrew/Brewfile
```

## Summary

You've successfully:
- Installed the required tools (Homebrew, GNU Stow)
- Cloned your dotfiles repository
- Applied git and shell configurations
- Verified the installation

Your development environment is now version-controlled and reproducible!

## Next Steps

- Explore [customizing your shell](customizing-shell.md)
- Learn [how to add new configurations](../how-to/add-new-config.md)
- Understand the [architecture](../explanations/architecture.md) of this setup

## Troubleshooting

**Stow conflicts:**
If you see "existing target is not a symlink" errors:
```bash
# Remove the existing file
mv ~/.gitconfig ~/.gitconfig.backup
# Try stow again
stow git
```

**Shell not loading configuration:**
Ensure your shell is set to Zsh:
```bash
chsh -s $(which zsh)
```

**Permission errors:**
Some operations might require sudo:
```bash
sudo stow systemwide  # For system-wide configs
```