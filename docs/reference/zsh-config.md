# Zsh Configuration Reference

## Overview

Zsh shell configuration using Znap plugin manager, Starship prompt, and extensive customizations for a productive terminal environment.

## Synopsis

```
~/.zshenv              # Environment variables (always sourced)
~/.zshrc               # Interactive shell configuration
~/.config/zsh/         # Additional configuration files
├── functions/         # Custom shell functions
└── completion/        # Custom completions
```

## File Loading Order

```mermaid
graph TD
    A[Terminal Start] --> B{Login Shell?}
    B -->|Yes| C[/etc/zshenv]
    B -->|No| C
    C --> D[~/.zshenv]
    D --> E{Login Shell?}
    E -->|Yes| F[/etc/zprofile]
    E -->|No| H
    F --> G[~/.zprofile]
    G --> H{Interactive?}
    H -->|Yes| I[/etc/zshrc]
    H -->|No| L
    I --> J[~/.zshrc]
    J --> K{Login Shell?}
    K -->|Yes| L[/etc/zlogin]
    K -->|No| M[Shell Ready]
    L --> M
```

## Configuration Files

### `~/.zshenv` {#zshenv}

Sourced for all Zsh instances. Keep minimal for performance.

**Current Contents:**
```zsh
# This file is sourced by all instances of Zsh, and thus should be kept as
# small as possible and should only define environment variables.
```

**Purpose:**
- Set PATH modifications
- Export environment variables
- Set ZDOTDIR if using XDG structure

### `~/.zshrc` {#zshrc}

Main configuration for interactive shells.

**Structure:**
1. Znap plugin manager setup
2. Environment variables
3. Plugin loading
4. Starship prompt initialization
5. Aliases and functions
6. Completions setup
7. Key bindings

## Key Components

### Znap Plugin Manager {#znap}

**Installation Path**: `~/znap/zsh-snap`

**Core Commands:**
| Command | Description | Example |
|---------|-------------|---------|
| `znap install` | Install a plugin | `znap install ohmyzsh/ohmyzsh` |
| `znap source` | Source a plugin | `znap source zsh-users/zsh-autosuggestions` |
| `znap eval` | Evaluate and cache command | `znap eval starship 'starship init zsh'` |
| `znap pull` | Update plugins | `znap pull` |

**Loaded Plugins:**
- `ohmyzsh/ohmyzsh` - Framework for configurations
- `zsh-users/zsh-autosuggestions` - Fish-like suggestions
- `zsh-users/zsh-completions` - Additional completions
- `marlonrichert/zsh-autocomplete` - Real-time completions

### Environment Variables {#environment}

**Development Tools:**
| Variable | Purpose | Value |
|----------|---------|-------|
| `EDITOR` | Default text editor | `code --wait` |
| `VISUAL` | Visual editor | `code --wait` |
| `PAGER` | Output pager | `less` |

**Language Environments:**
| Variable | Purpose | Path |
|----------|---------|------|
| `JAVA_HOME` | Java installation | `/opt/homebrew/opt/openjdk` |
| `GOPATH` | Go workspace | `$HOME/go` |
| `DVM_DIR` | Deno version manager | `$HOME/.dvm` |

**Security:**
| Variable | Purpose | Value |
|----------|---------|-------|
| `GPG_TTY` | GPG terminal | `$(tty)` |
| `SSH_AUTH_SOCK` | SSH agent socket | GPG agent socket |

### Path Configuration {#path}

Path additions in order:
```bash
$HOME/bin                    # Personal scripts
$HOME/.local/bin            # User installations
/opt/homebrew/bin           # Homebrew (Apple Silicon)
/usr/local/bin              # Traditional installs
$GOPATH/bin                 # Go binaries
$HOME/.cargo/bin            # Rust binaries
$DVM_DIR/bin                # Deno versions
$HOME/.claude/local         # Claude CLI
$HOME/.dotnet/tools         # .NET tools
```

### Aliases {#aliases}

**File Management:**
| Alias | Command | Description |
|-------|---------|-------------|
| `ll` | `ls -la` | Long listing with hidden files |
| `la` | `ls -A` | List all except . and .. |
| `l` | `ls -CF` | Classify file types |

**Directory Navigation:**
| Alias | Command | Description |
|-------|---------|-------------|
| `..` | `cd ..` | Parent directory |
| `...` | `cd ../..` | Two levels up |
| `....` | `cd ../../..` | Three levels up |

**Git Shortcuts:**
| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Git shorthand |
| `gst` | `git status` | Status shorthand |
| `gco` | `git checkout` | Checkout shorthand |

**Development:**
| Alias | Command | Description |
|-------|---------|-------------|
| `py` | `python3` | Python 3 |
| `pip` | `pip3` | Pip 3 |
| `serve` | `python3 -m http.server` | Simple HTTP server |

### Functions {#functions}

Custom functions are stored in `~/.config/zsh/functions/`:

**Available Functions:**
- `mkcd` - Create directory and cd into it
- `extract` - Universal archive extractor
- `backup` - Create timestamped backups
- `fzf-git-branch` - Fuzzy find git branches

**Example Function:**
```zsh
# mkcd - Make directory and change to it
mkcd() {
    mkdir -p "$1" && cd "$1"
}
```

### Completion System {#completion}

**Initialization:**
```zsh
autoload -Uz compinit && compinit
```

**Settings:**
- Case-insensitive matching
- Partial word completion
- Menu selection with arrow keys
- Colored completion listings

**Custom Completions:**
Located in `~/.config/zsh/completion/`

### Key Bindings {#keybindings}

**Navigation:**
| Key | Action |
|-----|--------|
| `Ctrl+A` | Beginning of line |
| `Ctrl+E` | End of line |
| `Ctrl+W` | Delete word backward |
| `Ctrl+U` | Delete to beginning |

**History:**
| Key | Action |
|-----|--------|
| `Ctrl+R` | Reverse history search |
| `Ctrl+P` | Previous command |
| `Ctrl+N` | Next command |
| `↑`/`↓` | History with prefix search |

### Starship Prompt {#starship}

**Configuration**: `~/.config/starship.toml`

**Features:**
- Git status integration
- Language version display
- Command execution time
- Exit code indicators
- Directory truncation

**Customization Example:**
```toml
[directory]
truncation_length = 3
truncate_to_repo = false

[git_branch]
symbol = "🌱 "
truncation_length = 20
```

## Performance Optimization

### Lazy Loading {#lazy-loading}

Commands evaluated on first use:
```zsh
znap eval rbenv 'rbenv init -'
znap eval pyenv 'pyenv init -'
```

### Compilation {#compilation}

Zsh compiles scripts to `.zwc` files for faster loading:
```zsh
zcompile ~/.zshrc
zcompile ~/.config/zsh/functions/*
```

## Debugging

### Profiling Startup {#profiling}

```zsh
# Add to beginning of .zshrc
zmodload zsh/zprof

# Add to end of .zshrc
zprof
```

### Verbose Loading {#verbose}

```zsh
# Start shell with verbose output
zsh -xv
```

### Check Load Order {#load-order}

```zsh
# Print each file as it's sourced
export ZSH_TRACE=1
```

## Environment Detection

### OS Detection {#os-detection}
```zsh
case "$OSTYPE" in
    darwin*)  # macOS specific
        export HOMEBREW_PREFIX="/opt/homebrew"
        ;;
    linux*)   # Linux specific
        export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
        ;;
esac
```

### Machine-Specific Config {#machine-specific}
```zsh
# Load machine-specific settings
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
```

## See Also

- [Git configuration reference](git-config.md)
- [Environment variables reference](environment-variables.md)
- [How to update shell plugins](../how-to/update-shell-plugins.md)
- [Shell startup sequence explained](../explanations/shell-startup.md)