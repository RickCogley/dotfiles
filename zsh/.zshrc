# Documentation: https://github.com/romkatv/zsh4humans/blob/v3/README.md.
# JRC Notes:
# Incorporate https://leahneukirchen.org/dotfiles/.zshrc ?

# 'ask': ask to update; 'no': disable auto-update.
zstyle ':z4h:'                auto-update      ask
# Auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:'                auto-update-days 28
# Stability vs freshness of plugins: stable, testing or dev.
zstyle ':z4h:*'               channel          stable
# Bind alt-arrows or ctrl-arrows to change current directory?
# The other key modifier will be bound to cursor movement by words.
zstyle ':z4h:'                cd-key           alt
# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char     accept

# Clone additional Git repositories from GitHub. This doesn't do anything
# apart from cloning the repository and keeping it up-to-date. Cloned
# files can be used after `z4h init`.
#
# This is just an example. If you don't plan to use Oh My Zsh, delete this.
# z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable. Everything
# that requires user interaction or can perform network I/O must be done
# above. Everything else is best done below.
z4h init || return

# Export environment variables.
export LANG=ja_JP.UTF-8
export EDITOR=nova
export GPG_TTY=$TTY

# Extend PATH.
typeset -U path
path=(~/bin $path)

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It doesn't do anything useful.
# z4h source $Z4H/ohmyzsh/ohmyzsh/lib/diagnostics.zsh
# z4h source $Z4H/ohmyzsh/ohmyzsh/plugins/emoji-clock/emoji-clock.plugin.zsh
# fpath+=($Z4H/ohmyzsh/ohmyzsh/plugins/supervisor)

# Source additional local files.
if [[ $LC_TERMINAL == iTerm2 ]]; then
  # Enable iTerm2 shell integration (if installed).
  z4h source ~/.iterm2_shell_integration.zsh
fi

# Define key bindings.
bindkey '^H'   z4h-backward-kill-word   # Ctrl+H and Ctrl+Backspace: Delete previous word.
bindkey '^[^H' z4h-backward-kill-zword  # Ctrl+Alt+Backspace: Delete previous shell word.

# Sort completion candidates when pressing Tab?
zstyle ':completion:*'                           sort               false
# Ignore case
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# Should cursor go to the end when Up/Down/Ctrl-Up/Ctrl-Down fetches a command from history?
zstyle ':zle:(up|down)-line-or-beginning-search' leave-cursor       no
# When presented with the list of choices upon hitting Tab, accept selection and
# trigger another completion with this key binding. Great for completing file paths.
zstyle ':fzf-tab:*'                              continuous-trigger tab

# Autoload functions. Zmv is for renaming
autoload -Uz zmv

# Brew site functions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  autoload -Uz compinit
  compinit
fi

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Define aliases.
alias tree='tree -a -I .git'

# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -A"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots  # glob matches files starting with dot; `ls *` becomes equivalent to `ls *(D)`
setopt print_eight_bit # allow use of japanese files

ulimit -c $(((4 << 30) / 512))  # 4GB
