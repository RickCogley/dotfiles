# Solution Design: Zsh Configuration Cleanup

## Breadboard

```
[Current z4h Setup] --> [Backup] --> [New Config] --> [Test] --> [Commit]
                                          |
                                          v
                                   [zsh-snap option]
                                   [minimal option]
```

## Option 1: zsh-snap Configuration (Recommended)

### Core Structure
```
zsh/
├── .zshenv          # Minimal env setup
├── .zshrc           # Main config with zsh-snap
├── .zlogin          # Login shell setup
├── .zlogout         # Cleanup on logout
├── .zprofile        # Profile settings
├── functions/       # Organized function files
│   ├── hugo.zsh     # Hugo-related functions
│   ├── deploy.zsh   # Deployment functions
│   ├── utils.zsh    # Utility functions
│   └── aws.zsh      # AWS-related functions
└── .p10k.zsh        # Powerlevel10k config (optional)
```

### Implementation Steps

1. **Backup current config**
   ```bash
   cp -r zsh zsh-backup-$(date +%Y%m%d)
   ```

2. **Install zsh-snap**
   ```bash
   git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git
   source zsh-snap/install.zsh
   ```

3. **Create new .zshrc with zsh-snap**
   - Fast plugin loading
   - Lazy loading for heavy plugins
   - Preserve all custom functions
   - Maintain current PATH setup

4. **Organize functions into categories**
   - Extract hugo functions to `functions/hugo.zsh`
   - Extract deployment functions to `functions/deploy.zsh`
   - Keep core aliases in main .zshrc

## Option 2: Minimal Standard Zsh

### Core Structure
```
zsh/
├── .zshenv          # Minimal env setup
├── .zshrc           # Main config
├── plugins/         # Git submodules for plugins
│   ├── zsh-autosuggestions/
│   ├── zsh-syntax-highlighting/
│   └── powerlevel10k/
└── functions/       # Same as above
```

### Key Differences
- No plugin manager overhead
- Direct control over plugin updates
- Slightly more manual setup
- Rock-solid stability

## Migration Checklist

- [ ] Backup existing configuration
- [ ] Choose option (zsh-snap vs minimal)
- [ ] Create new configuration structure
- [ ] Migrate environment variables
- [ ] Migrate PATH setup
- [ ] Migrate custom functions
- [ ] Migrate aliases
- [ ] Set up plugins/theme
- [ ] Test in new shell session
- [ ] Test all critical functions
- [ ] Update stow links
- [ ] Commit changes

## Testing Plan

1. Source new config in subshell
2. Verify PATH is correct
3. Test key functions:
   - Hugo deployments
   - GPG/SSH agent
   - Python/Ruby environments
   - Custom aliases
4. Check startup time
5. Verify git completion works

## Rollback Plan

If issues arise:
```bash
cd ~/.dotfiles
rm -rf zsh
mv zsh-backup-$(date +%Y%m%d) zsh
stow zsh
```