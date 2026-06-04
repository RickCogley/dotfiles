# .zshrc - Zsh configuration with znap plugin manager
# https://github.com/marlonrichert/zsh-snap

# Enable Starship prompt if installed
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
else
    # Fallback to simple prompt if starship not installed
    PS1='%n@%m %~ %# '
fi

# Load znap
[[ -r ~/dev/zsh-snap/znap.zsh ]] || git clone --depth 1 https://github.com/marlonrichert/zsh-snap ~/dev/zsh-snap
source ~/dev/zsh-snap/znap.zsh

# Load plugins with znap (auto-installs if needed)
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting
# Skip autocomplete for now as it may conflict
# znap source marlonrichert/zsh-autocomplete

# Archive plugin - only load if already cloned
if [[ -d ~/.cache/zsh-snap/romkatv/archive ]]; then
    znap source romkatv/archive
else
    # Clone it for next time
    znap clone romkatv/archive 2>/dev/null || true
fi

# Perform anything that needs console IO
# via .envrc direnv now




# Export environment variables
export LANG=ja_JP.UTF-8
if [[ -x /usr/local/bin/nova ]]; then
  export VISUAL=/usr/local/bin/nova
else
  export VISUAL=${${commands[vim]:t}:-vi}
fi
export EDITOR=$VISUAL

# GPG as SSH agent
export GPGPRIMARY="E8404D8E8DAB59CD1E5255BD56BCDEBC6448A091"
export GPGSIGNING=$(\
  gpg --list-keys --with-subkey-fingerprints $GPGPRIMARY | \
  sed -n '/\[S\]/,+1p' | \
  awk '/^[[:space:]]+[0-9A-F]{40}/ {print $1}'\
)
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# Browser
if [[ "$OSTYPE" == darwin* ]]; then
    export BROWSER='open'
fi

# Less configuration
export LESS='-F -g -i -M -R -S -w -X -z-4'
if (( $#commands[(i)lesspipe(|.sh)] )); then
    export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# Compiler flags
export LDFLAGS="-L/usr/local/opt/libressl/lib"
export CPPFLAGS="-I/usr/local/opt/libressl/include"
export PKG_CONFIG_PATH="/usr/local/opt/libressl/lib/pkgconfig"

# Pager
export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
if (( $+commands[most] )); then
    export PAGER=most
else
    export PAGER=less
fi
alias less=$PAGER

# Deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export DENO_DIR="$HOME/Library/Caches/deno"
export PATH="$DENO_DIR/bin:$PATH"

# Python with PyEnv
if (( $+commands[pyenv] )); then
  export PYENV_SHELL=zsh
  export PYENV_ROOT=$(pyenv root)
  export PYENV_VERSION=$(pyenv version-name)
  export PYTHONPATH=$PYENV_ROOT/shims
fi

# Go
export GOPATH=~/gocode

# Homebrew
export XML_CATALOG_FILES=/usr/local/etc/xml/catalog
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Zsh configuration
export HELPDIR=/usr/local/share/zsh/help
export REPORTTIME=1
export HISTSIZE="1000000"
export SAVEHIST="1000000"
export HISTFILE=~/.zsh_history

# Other environments
export ONI2_CONFIG_DIR=~/.config/oni2/
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# NVM
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"

# PATH configuration
typeset -gU cdpath fpath mailpath path

# Homebrew on Apple Silicon
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# System paths
path=(/usr/local/sbin $path)
path=(/opt/local/bin $path)
path=(/opt/local/sbin $path)
path=(/opt/X11/bin $path)

# Homebrew overrides
path=(/opt/homebrew/opt/curl/bin $path)
path=(/opt/homebrew/opt/sqlite/bin $path)
path=(/opt/homebrew/opt/libressl/bin $path)
path=(/opt/homebrew/opt/php/bin $path)
path=(/usr/local/MacGPG2/bin $path)
path=(/opt/homebrew/opt/gnu-getopt/bin $path)

# Language-specific paths
path=(~/.composer/vendor/bin $path)
path+=(~/.cargo/bin)
path+=(~/.rbenv/bin)
if (( $+commands[rbenv] )); then
    eval "$(rbenv init - zsh)"
fi
path+=(~/.nimble/bin)
path=(/usr/local/go/bin $path)
path=(/usr/local/opt/go/libexec/bin $path)
path=(~/gocode $path)
path=(~/gocode/bin $path)

# PyEnv
if (( $+commands[pyenv] )); then
    eval "$(pyenv init -)"
fi
path=($PYENV_ROOT/bin $path)

# Direnv
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi

# User paths
path=(~/.local/bin $path)
path=(~/bin $path)

# Add personal functions to fpath
[[ -d ~/bin/zsh/functions ]] && fpath=(~/bin/zsh/functions $fpath)

# Export PATH
export PATH
export FPATH

# Key bindings
bindkey '^H'   backward-kill-word    # Ctrl+H and Ctrl+Backspace: Delete previous word
bindkey '^[^H' backward-kill-word    # Ctrl+Alt+Backspace: Delete previous shell word

# Completion settings
zstyle ':completion:*' sort false
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Autoload functions
autoload -Uz zmv
autoload -Uz ~/bin/zsh/functions/[^_]*(.)
compdef _directories md

# Brew completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  autoload -Uz compinit
  compinit
fi

# Aliases
(( $+commands[tree]  )) && alias tree='tree -aC -I .git --dirsfirst'
(( $+commands[gedit] )) && alias gedit='gedit &>/dev/null'
(( $+commands[rsync] )) && alias rsync='rsync --compress --verbose --iconv=UTF-8-MAC,UTF-8 $@'
(( $+commands[exa]   )) && alias exa='exa --group --all --group-directories-first --time-style=long-iso --color-scale $@'

# ls aliases with exa fallback
(( $+commands[exa] )) && alias l='exa --grid --all --group-directories-first --color-scale' || alias l='ls -CF'
(( $+commands[exa] )) && alias lrs='exa --grid --all --group-directories-first --color-scale --reverse' || alias lrs='ls -F'
(( $+commands[exa] )) && alias ll='exa --long --header --all --classify --group --git --group-directories-first --time-style=long-iso --color-scale' || alias ll='ls -lhA'
(( $+commands[exa] )) && alias llrs='exa --long --header --all --classify --group --git --group-directories-first --time-style=long-iso --color-scale --reverse' || alias llrs='ls -lhA'
(( $+commands[exa] )) && alias llr='exa --long --header --all --classify --group --git --group-directories-first --time-style=long-iso --color-scale --recurse -L ' || alias llr='ls -lhA'
(( $+commands[exa] )) && alias lt='exa --tree' || alias lt='ls -lhA'
(( $+commands[exa] )) && alias ltr='exa --tree -L ' || alias lt='ls -lhA'
(( $+commands[exa] )) && alias le='exa --long --header --all --classify --group --git --group-directories-first --time-style=long-iso --color-scale --extended' || alias le='ls -lhA'

# Standard aliases
alias ls="${aliases[ls]:-ls} -A"
alias cd..="cd .."
alias sl="ls"
alias myip="curl http://ipecho.net/plain; echo"
alias t='tail -f'

# Pipe extensions
alias -g G='| ag'
alias -g NE='2> /dev/null'
alias -g NUL='> /dev/null 2>&1'

# Disk usage
alias dud='du -d 1 -h'
alias duf='du -sh *'

# Find
alias fd='find . -type d -name'
alias ff='find . -type f -name'

# History
alias h='history'
alias hgrep="fc -El 0 | grep"

# Process
alias p='ps -f'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Shell options
setopt glob_dots
setopt print_eight_bit

ulimit -c $(((4 << 30) / 512))  # 4GB

# Source custom functions
for func_file in ~/bin/zsh/functions/*.zsh(N); do
    source "$func_file"
done

# Or inline critical functions here
function lsfunc () {
  print -l ${(ok)functions}
}

# Reload the shell
function relogin {
  exec $SHELL --login
}

# Source function files if they exist
[[ -f ~/.dotfiles/zsh/functions/backup.zsh ]] && source ~/.dotfiles/zsh/functions/backup.zsh

# Include all custom functions inline for now
# (These can be moved to separate files later)

# Google Cloud SDK
if [ -f '/Users/rcogley/Downloads/google-cloud-sdk/path.zsh.inc' ]; then
    . '/Users/rcogley/Downloads/google-cloud-sdk/path.zsh.inc'
fi
if [ -f '/Users/rcogley/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then
    . '/Users/rcogley/Downloads/google-cloud-sdk/completion.zsh.inc'
fi

# Deno version manager
export DVM_DIR="/Users/rcogley/.dvm"
export PATH="$DVM_DIR/bin:$PATH"

# Git aliases
alias changelog-since='f(){ git log ${1:-HEAD}..HEAD --pretty=format:"- %s (%h)" | pbcopy; }; f'
alias release-dates='git tag -l --sort=-version:refname --format="%(refname:short) - %(creatordate:short)" | pbcopy'

# Claude
export PATH="$HOME/.claude/local:$PATH"
export ENABLE_LSP_TOOL=1
alias claude-with-dirs='claude --add-dir $HOME/.claude/ --add-dir $HOME/dev/aichaku --add-dir $HOME/dev/nagare --add-dir $HOME/dev/salty.esolia.pro-dd $HOME/.dotfiles'

# .NET Core SDK tools
export PATH="$PATH:$HOME/.dotnet/tools"

# pnpm
export PNPM_HOME="/Users/rcogley/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

. "$HOME/.local/share/../bin/env"

# Azure subscription switcher. direnv/.envrc exports a canonical
# AZURE_SUBSCRIPTION_ID per project (same override pattern as the
# CLOUDFLARE_* tokens). `azsub` syncs the az CLI's active subscription
# to it; pass an explicit id/name to override.
#   azsub            switch to $AZURE_SUBSCRIPTION_ID (project default)
#   azsub <id|name>  switch to a specific subscription
# Internal: print the active az subscription context in a form that
# always shows the canonical ID alongside the friendly name. `az -o table`
# silently drops columns when its width heuristic decides the table is too
# wide, which hides the ID and produces wrong-sub mistakes. printf'ing the
# fields ourselves is the only reliable way to keep both visible.
_azsub_print_active() {
  local name id tenant
  name="$(az account show --query name -o tsv 2>/dev/null)" || return $?
  id="$(az account show --query id -o tsv)"
  tenant="$(az account show --query tenantId -o tsv)"
  printf '  subscription: %s (%s)\n' "$name" "$id"
  printf '  tenant:       %s\n' "$tenant"
}

azsub() {
  local sub="${1:-$AZURE_SUBSCRIPTION_ID}"
  if [[ -z "$sub" ]]; then
    echo "AZURE_SUBSCRIPTION_ID not set — is direnv loaded for this project?" >&2
    _azsub_print_active
    return 1
  fi
  az account set --subscription "$sub" || return $?
  _azsub_print_active
  # Loudly indicate whether the now-active sub matches direnv's expectation
  # (catches the case where someone passed an explicit override that doesn't
  # match the project, or where direnv isn't loaded in this shell).
  if [[ -n "$AZURE_SUBSCRIPTION_ID" ]]; then
    local active_id
    active_id="$(az account show --query id -o tsv)"
    if [[ "$active_id" == "$AZURE_SUBSCRIPTION_ID" ]]; then
      printf '\033[1;32m✓\033[0m active sub matches $AZURE_SUBSCRIPTION_ID (direnv)\n'
    else
      printf '\033[1;31m✗\033[0m active sub (%s) does NOT match $AZURE_SUBSCRIPTION_ID (%s)\n' \
        "$active_id" "$AZURE_SUBSCRIPTION_ID" >&2
    fi
  fi
}
