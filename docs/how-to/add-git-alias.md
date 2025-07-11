# How to Add a New Git Alias

This guide shows you how to add custom Git aliases to your dotfiles configuration. Use this approach when you want to create shortcuts for frequently used Git commands.

## Before you begin

Ensure you have:
- The dotfiles repository cloned to `~/.dotfiles`
- Git configuration applied via `stow git`
- A text editor ready

## Solution

### Option 1: Add to Global Git Config

Use this approach for aliases you want available everywhere.

1. Open the git configuration file:
   ```bash
   cd ~/.dotfiles
   $EDITOR git/.gitconfig
   ```

2. Find the `[alias]` section (around line 13)

3. Add your new alias following the existing pattern:
   ```gitconfig
   [alias]
       # Existing aliases...
       
       # Your new alias
       myalias = log --oneline --graph --all
   ```

4. Save the file

### Option 2: Add via Command Line

Use this for quick additions without editing files.

1. Add the alias using git config:
   ```bash
   git config --global alias.myalias "log --oneline --graph --all"
   ```

2. The alias is added to `~/.gitconfig` (which is symlinked to your dotfiles)

3. Commit the change to your dotfiles:
   ```bash
   cd ~/.dotfiles
   git add git/.gitconfig
   git commit -m "feat: add 'myalias' git alias"
   ```

### Option 3: Complex Aliases with Shell Functions

For aliases that need shell features, use a function:

1. Add to the `[alias]` section:
   ```gitconfig
   [alias]
       # Complex alias using shell
       branch-clean = "!f() { \
           git branch --merged | \
           grep -v '\*\|main\|master' | \
           xargs -n 1 git branch -d; \
       }; f"
   ```

2. Note the `!` prefix indicates a shell command

## Verify Your Configuration

Test your new alias:
```bash
# Simple alias
git myalias

# List all aliases
git config --get-regexp alias

# Check specific alias
git config alias.myalias
```

## Examples

### Useful Git Aliases

```gitconfig
# Status shortcuts
st = status --short --branch
s = status

# Commit shortcuts  
ci = commit
cm = commit -m
amend = commit --amend --no-edit

# Branch management
br = branch
co = checkout
cob = checkout -b

# Log variations
lg = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
last = log -1 HEAD

# Workflow helpers
unstage = reset HEAD --
discard = checkout --
undo = reset --soft HEAD~1

# Information
aliases = config --get-regexp '^alias\.'
contribs = shortlog --summary --numbered
```

## Troubleshooting

**Problem**: Alias doesn't work  
**Solution**: Check for typos and ensure there are no spaces around the `=` sign

**Problem**: Shell features not working  
**Solution**: Add `!` prefix for shell commands: `myalias = !echo hello`

**Problem**: Alias conflicts with git command  
**Solution**: Git aliases cannot override built-in commands. Choose a different name.

**Problem**: Changes not persisting  
**Solution**: Ensure you're editing `~/.dotfiles/git/.gitconfig`, not `~/.gitconfig` directly

## Best Practices

1. **Use descriptive names**: `graph` better than `gr`
2. **Document complex aliases**: Add comments explaining what they do
3. **Group related aliases**: Keep similar commands together
4. **Test before committing**: Ensure aliases work as expected
5. **Avoid overriding**: Don't shadow common commands

## Related Tasks

- [Configure GPG signing](configure-gpg-signing.md)
- [Customize git colors](customize-git-colors.md)
- [Set up git hooks](setup-git-hooks.md)