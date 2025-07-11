# How to Backup and Restore Dotfiles Settings

This guide shows you how to backup your dotfiles and restore them on a new machine. Use this when migrating to a new computer or creating backups of your configuration.

## Before you begin

Ensure you have:
- Git installed on both machines
- Access to a Git remote (GitHub, GitLab, etc.)
- GNU Stow installed (for restoration)

## Backup Solution

### Option 1: Full Repository Backup

Use this for complete configuration backup including history.

1. Ensure all changes are committed:
   ```bash
   cd ~/.dotfiles
   git status
   git add -A
   git commit -m "backup: configuration snapshot $(date +%Y-%m-%d)"
   ```

2. Push to remote repository:
   ```bash
   git push origin main
   ```

3. Create a backup tag:
   ```bash
   git tag -a "backup-$(date +%Y-%m-%d)" -m "Configuration backup"
   git push origin --tags
   ```

### Option 2: Selective Backup

Use this when you only want specific configurations.

1. Create a backup branch:
   ```bash
   git checkout -b backup/machine-name-$(date +%Y%m%d)
   ```

2. Remove unwanted configurations:
   ```bash
   # Example: exclude work-specific configs
   rm -rf work/
   git add -A
   git commit -m "backup: filtered configuration"
   ```

3. Push the backup branch:
   ```bash
   git push origin backup/machine-name-$(date +%Y%m%d)
   ```

### Option 3: Archive Backup

Use this for offline backups without Git history.

1. Create an archive:
   ```bash
   cd ~
   tar -czf dotfiles-backup-$(date +%Y%m%d).tar.gz \
       --exclude='.git' \
       --exclude='*.zwc' \
       --exclude='.DS_Store' \
       .dotfiles/
   ```

2. Include important non-dotfile configs:
   ```bash
   tar -czf complete-backup-$(date +%Y%m%d).tar.gz \
       .dotfiles/ \
       .ssh/config \
       .gnupg/pubring.kbx \
       .gnupg/trustdb.gpg
   ```

## Restore Solution

### Step 1: Clone Repository

1. Install prerequisites:
   ```bash
   # On macOS
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   brew install git stow
   ```

2. Clone your dotfiles:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

3. Checkout specific backup (if needed):
   ```bash
   # List available backups
   git tag -l "backup-*"
   git branch -r | grep backup/
   
   # Restore specific backup
   git checkout backup-2024-01-15
   ```

### Step 2: Restore Configurations

1. Check for conflicts:
   ```bash
   # Dry run to see what would happen
   stow -n -v git zsh vim
   ```

2. Backup existing configs:
   ```bash
   # Create backup directory
   mkdir ~/config-backup-$(date +%Y%m%d)
   
   # Move existing files
   [[ -f ~/.gitconfig ]] && mv ~/.gitconfig ~/config-backup-*/
   [[ -f ~/.zshrc ]] && mv ~/.zshrc ~/config-backup-*/
   ```

3. Apply configurations:
   ```bash
   # Apply all configs
   stow git zsh vim homebrew
   
   # Or selectively
   stow git  # Just git configs
   stow zsh  # Just shell configs
   ```

### Step 3: Restore Dependencies

1. Install Homebrew packages:
   ```bash
   brew bundle --file=~/.config/homebrew/Brewfile
   ```

2. Install shell plugins:
   ```bash
   # Znap (if using zsh config)
   git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git ~/znap/zsh-snap
   
   # Restart shell
   exec zsh
   ```

3. Restore GPG keys (if backed up):
   ```bash
   gpg --import ~/config-backup-*/gpg-private-keys.asc
   gpg --import-ownertrust ~/config-backup-*/gpg-ownertrust.txt
   ```

## Verify Your Restoration

Check that configurations are properly restored:

```bash
# Verify symlinks
ls -la ~ | grep "\->"

# Test git aliases
git st  # Should work if aliases restored

# Check shell configuration
echo $SHELL
echo $ZDOTDIR

# Verify Git identity
git config user.name
git config user.email
```

## Automated Backup Script

Create `~/.dotfiles/scripts/backup.sh`:

```bash
#!/usr/bin/env bash

set -euo pipefail

BACKUP_DATE=$(date +%Y-%m-%d)
DOTFILES_DIR="$HOME/.dotfiles"

# Function to backup dotfiles
backup_dotfiles() {
    cd "$DOTFILES_DIR"
    
    # Check for uncommitted changes
    if [[ -n $(git status -s) ]]; then
        echo "📦 Committing current changes..."
        git add -A
        git commit -m "backup: auto-backup $BACKUP_DATE"
    fi
    
    # Push to remote
    echo "📤 Pushing to remote..."
    git push origin main
    
    # Create backup tag
    echo "🏷️  Creating backup tag..."
    git tag -a "backup-$BACKUP_DATE" -m "Automated backup"
    git push origin --tags
    
    echo "✅ Backup complete!"
}

# Run backup
backup_dotfiles
```

Make it executable:
```bash
chmod +x ~/.dotfiles/scripts/backup.sh
```

Add to crontab for daily backups:
```bash
# Edit crontab
crontab -e

# Add daily backup at 10 PM
0 22 * * * ~/.dotfiles/scripts/backup.sh >> ~/.dotfiles/backup.log 2>&1
```

## Troubleshooting

**Problem**: Stow conflicts during restore  
**Solution**: 
- Use `--adopt` to adopt existing files: `stow --adopt git`
- Or backup and remove existing files first

**Problem**: Missing dependencies after restore  
**Solution**:
- Run `brew bundle` to install from Brewfile
- Check for system-specific dependencies

**Problem**: Git push fails with authentication error  
**Solution**:
- Set up SSH keys: `ssh-keygen -t ed25519`
- Add to GitHub/GitLab
- Use SSH URL: `git remote set-url origin git@github.com:user/dotfiles.git`

**Problem**: Restored shell doesn't work properly  
**Solution**:
- Install shell first: `brew install zsh`
- Set as default: `chsh -s $(which zsh)`
- Restart terminal

## Best Practices

1. **Regular backups**: Automate with cron or launchd
2. **Test restores**: Periodically test on a VM
3. **Document dependencies**: Keep a list of required tools
4. **Exclude secrets**: Never backup private keys in the repo
5. **Version control**: Tag important configurations

## Related Tasks

- [Manage multiple machines](manage-multiple-machines.md)
- [Create installation script](create-install-script.md)
- [Setup automated sync](setup-automated-sync.md)