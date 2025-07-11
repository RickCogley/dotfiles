# How to Configure GPG Signing for Git Commits

This guide shows you how to set up GPG signing for your Git commits. Use this to cryptographically sign your commits, providing verification of authorship.

## Before you begin

Ensure you have:
- GPG installed (`brew install gnupg`)
- A GPG key pair generated
- The dotfiles repository set up

## Solution

### Step 1: Generate a GPG Key (if needed)

Skip this if you already have a GPG key.

1. Generate a new key:
   ```bash
   gpg --full-generate-key
   ```

2. Select the options:
   - Type: `(1) RSA and RSA`
   - Size: `4096`
   - Expiration: `2y` (2 years recommended)
   - Enter your name and email (must match Git config)

3. List your keys:
   ```bash
   gpg --list-secret-keys --keyid-format=long
   ```

   Output example:
   ```
   sec   rsa4096/56BCDEBC6448A091 2024-01-01 [SC]
         E8404D8E8DAB59CD1E5255BD56BCDEBC6448A091
   uid   [ultimate] Your Name <your.email@example.com>
   ```

### Step 2: Configure Git to Use Your Key

This repository uses a secure split configuration pattern to keep your GPG key private:

1. **Understanding the split configuration**:
   - `.gitconfig` - Public configuration (tracked in repo)
   - `.gitconfig.local.template` - Template showing the format (tracked)
   - `.gitconfig.local` - Your private configuration (NOT tracked)

2. **Initial setup after stowing**:
   ```bash
   # After running stow git
   cd ~
   cp .gitconfig.local.template .gitconfig.local
   ```

3. **Edit your local configuration**:
   ```bash
   $EDITOR ~/.gitconfig.local
   ```

   Update with your actual GPG key:
   ```gitconfig
   [user]
       signingKey = E8404D8E8DAB59CD1E5255BD56BCDEBC6448A091
   ```

4. **How it works**:
   The main `.gitconfig` includes this at the top:
   ```gitconfig
   [include]
       path = ~/.gitconfig.local
   ```
   
   This loads your local settings, overriding any values in the main config.

5. **Ensure commit signing is enabled** (already in main `.gitconfig`):
   ```gitconfig
   [commit]
       gpgsign = true
   ```

### Step 3: Configure GPG Agent

1. Create or update GPG agent configuration:
   ```bash
   mkdir -p ~/.gnupg
   cat > ~/.gnupg/gpg-agent.conf << EOF
   default-cache-ttl 600
   max-cache-ttl 7200
   pinentry-program /opt/homebrew/bin/pinentry-mac
   enable-ssh-support
   EOF
   ```

2. Restart the GPG agent:
   ```bash
   gpgconf --kill gpg-agent
   gpg-agent --daemon
   ```

### Step 4: Export GPG_TTY

Add to your shell configuration (already in the dotfiles):

```bash
# Check zsh/.zshrc includes:
export GPG_TTY=$(tty)
```

### Step 5: Test Your Configuration

1. Make a test commit:
   ```bash
   cd ~/test-repo
   echo "test" > test.txt
   git add test.txt
   git commit -m "test: GPG signed commit"
   ```

2. Verify the signature:
   ```bash
   git log --show-signature -1
   ```

   You should see:
   ```
   gpg: Good signature from "Your Name <email>"
   ```

## Platform-Specific Setup

### macOS with Pinentry

1. Install pinentry for password prompts:
   ```bash
   brew install pinentry-mac
   ```

2. Configure to use macOS keychain:
   ```bash
   echo "use-agent" >> ~/.gnupg/gpg.conf
   echo "pinentry-mode loopback" >> ~/.gnupg/gpg.conf
   ```

### SSH Authentication via GPG

To use your GPG key for SSH:

1. Get your key's keygrip:
   ```bash
   gpg --list-keys --with-keygrip
   ```

2. Add to SSH agent:
   ```bash
   echo "[KEYGRIP]" >> ~/.gnupg/sshcontrol
   ```

3. Add to shell config:
   ```bash
   export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
   ```

## Verify Your Configuration

### Check Git Config
```bash
# Verify signing is enabled
git config --get commit.gpgsign

# Verify signing key
git config --get user.signingKey
```

### Test Signing
```bash
# Create a signed commit
git commit -S -m "test: signed commit"

# Verify signatures in log
git log --show-signature
```

## Troubleshooting

**Problem**: "error: gpg failed to sign the data"  
**Solution**: 
- Ensure GPG_TTY is exported: `export GPG_TTY=$(tty)`
- Restart gpg-agent: `gpgconf --kill gpg-agent`
- Check key isn't expired: `gpg --list-keys`

**Problem**: No pinentry dialog appears  
**Solution**:
- Install pinentry-mac: `brew install pinentry-mac`
- Update gpg-agent.conf with correct path
- Restart gpg-agent

**Problem**: "No secret key" error  
**Solution**:
- Verify key ID matches: `gpg --list-secret-keys`
- Check email matches Git config
- Import key if missing: `gpg --import private-key.asc`

**Problem**: Commits show as "Unverified" on GitHub  
**Solution**:
- Export public key: `gpg --armor --export YOUR_KEY_ID`
- Add to GitHub: Settings → SSH and GPG keys → New GPG key

## Security Best Practices

1. **Protect your private key**: Never commit it to repositories
2. **Use strong passphrases**: Protect key access
3. **Set expiration dates**: Rotate keys periodically
4. **Backup securely**: Keep encrypted backups of your keys
5. **Revoke compromised keys**: Have a revocation certificate ready

## Related Tasks

- [Backup GPG keys](backup-gpg-keys.md)
- [Configure commit templates](configure-commit-templates.md)
- [Set up SSH keys](setup-ssh-keys.md)