# Security Considerations for Dotfiles

## Overview

Dotfiles often contain sensitive information and security-critical configurations. This document explains the security implications of dotfile management, common vulnerabilities, and best practices for maintaining a secure configuration while benefiting from version control and sharing.

## Background

The convenience of version-controlled dotfiles comes with security risks. Developers often accidentally expose API keys, passwords, and sensitive system information through public repositories. Understanding these risks and implementing proper safeguards is essential for secure dotfile management.

## Security Threat Model

### Attack Vectors

```mermaid
graph TD
    A[Dotfiles Repository] --> B[Public Exposure]
    A --> C[Local Access]
    A --> D[Supply Chain]
    
    B --> E[Credentials Leak]
    B --> F[System Info Disclosure]
    B --> G[Attack Surface Mapping]
    
    C --> H[Symlink Attacks]
    C --> I[Permission Issues]
    C --> J[Malicious Injection]
    
    D --> K[Compromised Plugins]
    D --> L[Backdoored Tools]
    D --> M[Update Hijacking]
    
    style E fill:#ff6b6b
    style F fill:#ff6b6b
    style G fill:#ff6b6b
```

### Risk Assessment

| Risk | Impact | Likelihood | Mitigation Priority |
|------|--------|------------|-------------------|
| **Credential Exposure** | Critical | High | Immediate |
| **SSH Key Leak** | Critical | Medium | Immediate |
| **System Info Disclosure** | Medium | High | High |
| **Path Hijacking** | High | Low | Medium |
| **Symlink Attacks** | Medium | Low | Low |

## Common Security Mistakes

### Mistake 1: Hardcoded Secrets

**Bad Example:**
```bash
# In .zshrc
export GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxx"
export AWS_SECRET_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
```

**Good Example:**
```bash
# In .zshrc
export GITHUB_TOKEN=$(security find-generic-password -s 'github' -w)
export AWS_SECRET_KEY=$(pass aws/secret_key)
```

### Mistake 2: SSH Key Exposure

**Bad Practice:**
```
dotfiles/
├── ssh/
│   ├── id_rsa        # NEVER DO THIS
│   ├── id_rsa.pub    # Public keys are OK
│   └── config        # OK if no sensitive hosts
```

**Good Practice:**
```
dotfiles/
├── ssh/
│   ├── config        # Sanitized config
│   └── .gitignore    # Ignore all keys
        *_rsa
        *_dsa
        *_ecdsa
        *_ed25519
        !*.pub
```

### Mistake 3: History Files

Shell history can contain sensitive commands:

**Dangerous:**
```bash
mysql -u root -pMyPassword123!
curl -H "Authorization: Bearer secret_token" api.example.com
```

**Mitigation:**
```bash
# In .zshrc
setopt HIST_IGNORE_SPACE  # Ignore commands starting with space
HISTIGNORE="*password*:*token*:*secret*"
```

## Security Best Practices

### 1. Secret Management

**Use Secret Stores:**

```bash
# macOS Keychain
security add-generic-password -s 'service-name' -a 'account' -w 'password'
TOKEN=$(security find-generic-password -s 'service-name' -w)

# Pass (Unix password manager)
pass insert github/token
TOKEN=$(pass github/token)

# Environment file (NOT in repo)
source ~/.secrets/env.sh  # This file is gitignored
```

**Symmetric Encryption for Configuration Files:**

For configuration files that contain secrets but need to be available across
machines, use GPG symmetric encryption:

```bash
# Encrypt sensitive configuration files
gpg --symmetric --cipher-algo TWOFISH config/sensitive-file.json

# Decrypt when needed
gpg --output config/sensitive-file.json --decrypt config/sensitive-file.json.gpg

# Add unencrypted versions to .gitignore
echo "config/sensitive-file.json" >> .gitignore
```

**Example workflow for files like API tokens:**
```bash
# Files that might be encrypted
.dotfiles/twty/.config/twty/settings.json.gpg
.dotfiles/git/.gh.json.gpg
.dotfiles/git/.gist-vim.gpg

# After stowing, decrypt for use
cd .dotfiles
gpg --output git/.gh.json --decrypt git/.gh.json.gpg
```

**Prevent accidental commits of decrypted files:**
```bash
# For dummy/template files that should never be committed
git update-index --assume-unchanged path/to/template-file
```

**Secret File Template:**
```bash
# ~/.secrets/env.sh (chmod 600)
export GITHUB_TOKEN="xxx"
export NPM_TOKEN="xxx"
export AWS_ACCESS_KEY_ID="xxx"

# Ensure it's not readable by others
if [[ $(stat -f %Lp ~/.secrets/env.sh) != "600" ]]; then
    echo "WARNING: ~/.secrets/env.sh has insecure permissions!"
fi
```

### 2. Git Security

**.gitignore Essentials:**
```gitignore
# Security-critical files
*.pem
*.key
*.pfx
*.p12
*.crt
*.cer
id_*
!id_*.pub

# Sensitive configs
.env
.env.*
secrets/
.secrets/
*_history
.lesshst
.mysql_history
.psql_history
.python_history

# System-specific
.DS_Store
Thumbs.db
```

**Git Hooks for Security:**
```bash
#!/usr/bin/env bash
# .git/hooks/pre-commit

# Check for potential secrets
if git diff --cached --name-only | xargs grep -E "(password|secret|token|key).*=.*['\"]" 2>/dev/null; then
    echo "ERROR: Potential secrets detected in commit"
    echo "Review the changes and remove sensitive data"
    exit 1
fi
```

### 3. File Permissions

**Secure Permission Setup:**
```bash
# Script to fix permissions
#!/usr/bin/env bash

# SSH directory and files
chmod 700 ~/.ssh                    # Directory: 700
chmod 600 ~/.ssh/id_*               # Private keys: 600
chmod 644 ~/.ssh/id_*.pub            # Public keys: 644
chmod 644 ~/.ssh/known_hosts         # Known hosts: 644
chmod 644 ~/.ssh/authorized_keys     # Remote auth file: 644
chmod 600 ~/.ssh/config              # SSH config: 600

# GPG directory
chmod 700 ~/.gnupg
chmod 600 ~/.gnupg/*

# Secret files
chmod 600 ~/.secrets/*
```

**SSH Permission Requirements:**
- **Directory**: 700 (owner read/write/execute only)
- **Private keys**: 600 (owner read/write only)
- **Public keys**: 644 (owner read/write, group/others read)
- **Remote auth file** (`authorized_keys`): 644
- **SSH config**: 600 (owner read/write only)

These permissions are critical for SSH security. Incorrect permissions will
cause SSH to reject the keys or configuration.

### 4. Symlink Security

**Safe Stow Practices:**
```bash
# Check symlink targets
ls -la ~ | grep '\->' | grep -v "$HOME/.dotfiles"

# Verify no external symlinks
find ~ -type l -exec readlink {} \; | grep -v "^$HOME"
```

### 5. GPG Signing

**Configure Commit Signing:**
```bash
# Generate GPG key
gpg --full-generate-key

# Configure git
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true
git config --global gpg.format openpgp

# Export public key for GitHub/GitLab
gpg --armor --export YOUR_KEY_ID
```

## Secure Configuration Patterns

### Pattern 1: Environment Detection

```bash
# Load secrets only on trusted machines
if [[ -f ~/.trusted_machine ]]; then
    source ~/.secrets/env.sh
fi

# Different configs for different security contexts
case "$(hostname)" in
    *work*)
        source ~/.config/work/secure.sh
        ;;
    *personal*)
        source ~/.config/personal/env.sh
        ;;
esac
```

### Pattern 2: Encrypted Secrets

Using GPG for sensitive configs:

```bash
# Encrypt sensitive file
gpg --encrypt --recipient your@email.com sensitive.conf

# Decrypt on demand
gpg --decrypt sensitive.conf.gpg > /tmp/sensitive.conf
source /tmp/sensitive.conf
rm /tmp/sensitive.conf
```

### Pattern 3: Audit Logging

```bash
# Log all sudo commands
export SUDO_PROMPT="[sudo] password for %u@%h: "

# Log SSH connections
log_ssh() {
    echo "[$(date)] SSH to $@" >> ~/.ssh/connection.log
}
alias ssh='log_ssh $@ && ssh'
```

## Security Checklist

### Before Committing

- [ ] No hardcoded passwords or tokens
- [ ] No private SSH keys
- [ ] No API keys or secrets
- [ ] No internal company hostnames
- [ ] No sensitive IP addresses
- [ ] History files excluded
- [ ] Proper .gitignore in place

### Repository Setup

- [ ] Use private repository if needed
- [ ] Enable branch protection
- [ ] Require code reviews
- [ ] Enable secret scanning (GitHub)
- [ ] Configure security alerts
- [ ] Regular security audits

### Local Security

- [ ] Correct file permissions (600/700)
- [ ] Encrypted disk/home directory
- [ ] Secret management tool configured
- [ ] GPG key for signing
- [ ] Secure backup strategy

## Incident Response

### If Secrets Are Exposed

1. **Immediate Actions:**
   ```bash
   # Rotate the exposed credential immediately
   # Example for GitHub token
   gh auth refresh
   
   # Remove from git history
   git filter-branch --force --index-filter \
     'git rm --cached --ignore-unmatch path/to/secret/file' \
     --prune-empty --tag-name-filter cat -- --all
   ```

2. **Clean Repository:**
   ```bash
   # Force push cleaned history
   git push origin --force --all
   git push origin --force --tags
   
   # Clean up local repo
   rm -rf .git/refs/original/
   git reflog expire --expire=now --all
   git gc --prune=now --aggressive
   ```

3. **Notify:**
   - Affected service providers
   - Team members
   - Security team if applicable

### Prevention Tools

**GitLeaks:**
```bash
# Install
brew install gitleaks

# Scan repository
gitleaks detect --source=. -v

# Pre-commit hook
gitleaks protect --staged -v
```

**Git-secrets:**
```bash
# Install
brew install git-secrets

# Configure
git secrets --install
git secrets --register-aws
git secrets --add 'password\s*=\s*.+'
```

## Advanced Security Topics

### Multi-Factor Authentication

```bash
# Require MFA for sensitive operations
sensitive_operation() {
    read -s -p "Enter 2FA code: " otp
    if ! verify_otp "$otp"; then
        echo "Invalid OTP"
        return 1
    fi
    # Proceed with operation
}
```

### Hardware Security Keys

```bash
# Configure GPG for hardware key
gpg --card-edit
gpg --card-status

# SSH via GPG/hardware key
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
```

### Secure Development Environment

```bash
# Isolated development environment
alias dev='docker run -it --rm \
    -v ~/.dotfiles:/home/dev/.dotfiles:ro \
    -v $(pwd):/workspace \
    --network=isolated \
    dev-environment:latest'
```

## Summary

Security in dotfile management requires:

1. **Awareness** - Understanding what's sensitive
2. **Prevention** - Using proper tools and practices
3. **Detection** - Regular audits and scanning
4. **Response** - Quick action when issues arise

Remember: convenience should never compromise security. A well-designed dotfile system can be both secure and user-friendly with proper planning and tooling.