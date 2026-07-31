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

# Deriving the signing subkey fingerprint costs a gpg call plus sed and awk
# (~40ms) on every shell. Cache it, invalidated when the keyring changes.
() {
  local cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/gpgsigning
  local keyring=${GNUPGHOME:-$HOME/.gnupg}/pubring.kbx
  if [[ -s $cache && $cache -nt $keyring ]]; then
    export GPGSIGNING="$(<$cache)"
  else
    export GPGSIGNING=$(
      gpg --list-keys --with-subkey-fingerprints $GPGPRIMARY | \
      sed -n '/\[S\]/,+1p' | \
      awk '/^[[:space:]]+[0-9A-F]{40}/ {print $1}'
    )
    [[ -n $GPGSIGNING ]] && {
      mkdir -p ${cache:h} && print -r -- "$GPGSIGNING" > $cache
    }
  fi
}

# $TTY is set by zsh for interactive shells; fall back to tty(1) so this stays
# correct in contexts where it is not (pinentry needs it to prompt).
export GPG_TTY=${TTY:-$(tty)}
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# `gpgconf --launch` costs ~320ms even when the agent is already running, which
# made it the single largest cost in shell startup. The liveness probe costs
# ~20ms, so only pay for the launch when the agent is actually down.
gpg-connect-agent --no-autostart /bye &>/dev/null || gpgconf --launch gpg-agent

# Browser
if [[ "$OSTYPE" == darwin* ]]; then
    export BROWSER='open'
fi

# Less configuration
export LESS='-F -g -i -M -R -S -w -X -z-4'
if (( $#commands[(i)lesspipe(|.sh)] )); then
    export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

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
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Zsh configuration
export REPORTTIME=1
export HISTSIZE="1000000"
export SAVEHIST="1000000"
export HISTFILE=~/.zsh_history

# Other environments
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

# Add to PATH only when the directory actually exists. Keeps this list
# declarative — a toolchain can be listed before it is installed — without
# accumulating dead entries. Before this guard, 32 of 54 PATH entries pointed
# at nothing, mostly Intel-Homebrew, MacPorts and XQuartz leftovers.
_path_prepend() { local d; for d in $@; do [[ -d $d ]] && path=($d $path); done }
_path_append()  { local d; for d in $@; do [[ -d $d ]] && path+=($d); done }

# System paths
_path_prepend /usr/local/sbin /opt/local/bin /opt/local/sbin /opt/X11/bin

# Homebrew overrides — keg-only formulae that need to outrank system copies
_path_prepend /opt/homebrew/opt/curl/bin \
              /opt/homebrew/opt/sqlite/bin \
              /opt/homebrew/opt/libressl/bin \
              /opt/homebrew/opt/php/bin \
              /usr/local/MacGPG2/bin \
              /opt/homebrew/opt/gnu-getopt/bin

# Language-specific paths
_path_prepend ~/.composer/vendor/bin
_path_append  ~/.cargo/bin ~/.rbenv/bin ~/.nimble/bin
if (( $+commands[rbenv] )); then
    eval "$(rbenv init - zsh)"
fi
_path_prepend /usr/local/go/bin /usr/local/opt/go/libexec/bin ~/gocode ~/gocode/bin

# PyEnv — PYENV_ROOT is only set inside the guard above, so this addition has to
# be guarded too. Unguarded it expanded to a bare "/bin", which landed /bin near
# the front of PATH ahead of /opt/homebrew/bin.
if (( $+commands[pyenv] )); then
    eval "$(pyenv init -)"
    _path_prepend $PYENV_ROOT/bin
fi

# Direnv
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi

# zoxide — frecency-ranked `z <partial>` jumping, on top of normal cd
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
fi

# atuin — SQLite-backed shell history on ctrl-r. Up-arrow is deliberately left
# on zsh's native prefix search: atuin rebinds it by default, which breaks the
# muscle memory of typing a prefix and arrowing through matches.
if (( $+commands[atuin] )); then
    eval "$(atuin init zsh --disable-up-arrow)"
fi

# User paths
_path_prepend ~/.local/bin ~/bin

unfunction _path_prepend _path_append

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

# Brew completions. brew shellenv already exported HOMEBREW_PREFIX above, so use
# it rather than spawning `brew --prefix` to recover a constant.
[[ -n $HOMEBREW_PREFIX ]] && FPATH=$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH

# compinit's security audit of every fpath directory is the expensive part. Run
# it in full once a day; reuse the dump with -C in between.
autoload -Uz compinit
() {
  setopt local_options extended_glob
  local dump=${ZDOTDIR:-$HOME}/.zcompdump
  if [[ -n $dump(#qN.mh+24) ]] || [[ ! -s $dump ]]; then
    compinit -d $dump
  else
    compinit -C -d $dump
  fi
}

# Aliases
(( $+commands[tree]  )) && alias tree='tree -aC -I .git --dirsfirst'
(( $+commands[gedit] )) && alias gedit='gedit &>/dev/null'
(( $+commands[rsync] )) && alias rsync='rsync --compress --verbose --iconv=UTF-8-MAC,UTF-8 $@'
# ls aliases, backed by eza. exa was unmaintained and renamed to eza; these were
# all guarded on `exa`, so every one of them had been silently falling through to
# plain ls.
if (( $+commands[eza] )); then
    _eza_long='eza --long --header --all --classify --group --git --group-directories-first --time-style=long-iso --color-scale=all'
    alias eza="eza --group --all --group-directories-first --time-style=long-iso --color-scale=all"
    alias l='eza --grid --all --group-directories-first --color-scale=all'
    alias lrs='eza --grid --all --group-directories-first --color-scale=all --reverse'
    alias ll="$_eza_long"
    alias llrs="$_eza_long --reverse"
    alias llr="$_eza_long --recurse -L "
    alias le="$_eza_long --extended"
    alias lt='eza --tree'
    alias ltr='eza --tree -L '
    unset _eza_long
else
    alias l='ls -CF'
    alias lrs='ls -F'
    alias ll='ls -lhA'
    alias llrs='ls -lhA'
    alias llr='ls -lhA'
    alias le='ls -lhA'
    alias lt='ls -lhA'
    alias ltr='ls -lhA'
fi

# Standard aliases
alias ls="${aliases[ls]:-ls} -A"
alias cd..="cd .."
alias sl="ls"
alias myip="curl http://ipecho.net/plain; echo"
alias t='tail -f'

# Pipe extensions
# ripgrep, not the silver searcher — ag is no longer installed here
alias -g G='| rg'
alias -g NE='2> /dev/null'
alias -g NUL='> /dev/null 2>&1'

# Disk usage
alias dud='du -d 1 -h'
alias duf='du -sh *'

# Find
# No `fd` alias here: an alias outranks a binary, so defining one would make the
# real fd unreachable under its own name. `fd -t d <pattern>` replaces what the
# old alias did, with smart-case, gitignore awareness and parallel traversal.
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

# No `ulimit -c` here: macOS defaults core dumps to 0 and that is the right
# default. A core file is a verbatim copy of process memory, so it can capture
# decrypted secrets, tokens and key material to disk unencrypted. Raise it
# per-shell (`ulimit -c unlimited`) when actually debugging a crash.

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

# Google Cloud SDK — removed. It was sourced from ~/Downloads, which no longer
# exists and was never a sound home for a toolchain. Reinstall via
# `brew install --cask google-cloud-sdk` and source it from the Caskroom path.

# Deno version manager
export DVM_DIR="/Users/rcogley/.dvm"
export PATH="$DVM_DIR/bin:$PATH"

# Git aliases
alias changelog-since='f(){ git log ${1:-HEAD}..HEAD --pretty=format:"- %s (%h)" | pbcopy; }; f'
alias release-dates='git tag -l --sort=-version:refname --format="%(refname:short) - %(creatordate:short)" | pbcopy'

# Claude
# (~/.claude/local was the old npm-style install location; the native installer
# puts the binary in ~/.local/bin, which is already on PATH)
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
