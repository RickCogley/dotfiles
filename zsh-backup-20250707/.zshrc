# Documentation: https://github.com/romkatv/zsh4humans/blob/v4/README.md.
# JRC Notes:
# Incorporate https://leahneukirchen.org/dotfiles/.zshrc ?
# `.zshrc' is sourced in interactive shells only, not login shells. It should contain commands to set up aliases, functions, options, key bindings, etc.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
zstyle ':z4h:'                auto-update      ask
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:'                auto-update-days 28
# Bind alt-arrows or ctrl-arrows to change current directory?
# The other key modifier will be bound to cursor movement by words.
zstyle ':z4h:'                cd-key           alt
# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char     accept

# Send extra rc files when using z4h ssh
zstyle    ':z4h:ssh:*' send-extra-files '~/.vimrc' '~/.vim/colors/iceberg.vim' '~/.bashrc' '~/.bash_profile' '~/.fzf.bash'

# Clone additional Git repositories from GitHub. This doesn't do anything
# apart from cloning the repository and keeping it up-to-date. Cloned
# files can be used after `z4h init`.
#
# This is just an example. If you don't plan to use Oh My Zsh, delete this.
# z4h install ohmyzsh/ohmyzsh || return

z4h install romkatv/archive romkatv/zsh-prompt-benchmark

# Perform anything that needs console IO
if [[ -e ~/.homebrew_github_api_token ]]; then
    export HOMEBREW_GITHUB_API_TOKEN="$(cat ~/.homebrew_github_api_token)"
fi
if [[ -e ~/.ssh/tokens/PRODB15331TOKEN2411 ]]; then
    export PRODB15331TOKEN2411="$(cat ~/.ssh/tokens/PRODB15331TOKEN2411)"
fi
if [[ -e ~/.ssh/tokens/API_KEY_01 ]]; then
    export API_KEY_01="$(cat ~/.ssh/tokens/API_KEY_01)"
fi


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable. Everything
# that requires user interaction or can perform network I/O must be done
# above. Everything else is best done below.
z4h init || return

# Export environment variables.
export LANG=ja_JP.UTF-8
if [[ -x /usr/local/bin/nova ]]; then
  export VISUAL=/usr/local/bin/nova
else
  export VISUAL=${${commands[vim]:t}:-vi}
fi
export EDITOR=$VISUAL

# allow for GPG to act as an SSH agent
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
# Set default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'
# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi
# For compilers to find libressl you may need to set:
export LDFLAGS="-L/usr/local/opt/libressl/lib"
export CPPFLAGS="-I/usr/local/opt/libressl/include"
# For pkg-config to find libressl you may need to set:
export PKG_CONFIG_PATH="/usr/local/opt/libressl/lib/pkgconfig"
# export MANPATH="/usr/local/man:$MANPATH"
# export MANPAGER="vim -c 'set ft=man' -"
export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
# export PAGER=vimpager

if (( $+commands[most] )); then
    export PAGER=most
  else
    export PAGER=less
fi
# export MANPAGER=vimmanpager
alias less=$PAGER

# Deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export DENO_DIR="$HOME/Library/Caches/deno"
export PATH="$DENO_DIR/bin:$PATH"

# Python
# Use PyEnv to set Python Environment
if (( $+commands[pyenv] )); then
  export PYENV_SHELL=zsh
  export PYENV_ROOT=$(pyenv root)
  export PYENV_VERSION=$(pyenv version-name)
  export PYTHONPATH=$PYENV_ROOT/shims
fi

# Golang
export GOPATH=~/gocode
# Homebrew suggested
export XML_CATALOG_FILES=/usr/local/etc/xml/catalog
export HOMEBREW_GITHUB_API_TOKEN="$(cat ~/.homebrew_github_api_token)"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
# Zsh
export HELPDIR=/usr/local/share/zsh/help
export REPORTTIME=1
export HISTSIZE="1000000"
export SAVEHIST="1000000"
export HISTFILE=~/.zsh_history
# Onivim2
export ONI2_CONFIG_DIR=~/.config/oni2/
# MS dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# for nvm node version manager
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Extend PATH
# APPEND as path+=(/new/bin/dir)
# PREPEND as path=(/new/bin/dir $path)
typeset -gU cdpath fpath mailpath path # no dupes in path arrays
path=(/usr/local/sbin $path) #std
path=(/opt/local/bin $path) #std
path=(/opt/local/sbin $path) #std
path=(/opt/X11/bin $path) #std
path=(/usr/local/opt/curl/bin $path) # brew over apple curl
path=(/usr/local/opt/sqlite/bin $path) # brew over apple sqlite
path=(/usr/local/opt/libressl/bin $path) # brew over apple libressl
path=(/usr/local/opt/php/bin $path) # brew over apple php
path=(/usr/local/MacGPG2/bin $path) # brew gpg
path=(/usr/local/opt/gnu-getopt/bin $path) # brew gnu-getopt

path=(~/.composer/vendor/bin $path) # php composer
path+=(~/.cargo/bin) #rust
path+=(~/.rbenv/bin) #ruby
if (( $+commands[rbenv] )); then
    eval "$(rbenv init - zsh)"
fi
path+=(~/.nimble/bin) #nim
path=(/usr/local/go/bin $path) #go
path=(/usr/local/opt/go/libexec/bin $path) #go
path=(~/gocode $path) #go
path=(~/gocode/bin $path) #go
# alternative if command -v pyenv 1>/dev/null 2>&1; then
# pyenv sets up shims path, installs autocompletion, rehashes shims, installs sh dispatcher
# PYENV PATHS NEED TO BE NEAR FRONT OF PATH
if (( $+commands[pyenv] )); then
eval "$(pyenv init -)"
fi
path=($PYENV_ROOT/bin $path) # pyenv
# Enable direnv hooks if direnv is installed.
if (( $+commands[direnv] )); then
eval "$(direnv hook zsh)"
fi
path=(~/.local/bin $path)
path=(~/bin $path)

# brew recommended, but not needed as it's installed by z4h already
# fpath=(/usr/local/share/zsh-completions $fpath)

fpath=($Z4H/romkatv/archive $fpath) # add archive plugin to path
[[ -d ~/bin/zsh/functions ]] && fpath=(~/bin/zsh/functions $fpath) #add personal functions to fpath if path exists
# export PATH and FPATH to sub-processes (make it inherited by child processes)
export PATH
export FPATH

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It doesn't do anything useful.
# z4h source $Z4H/ohmyzsh/ohmyzsh/lib/diagnostics.zsh
# z4h source $Z4H/ohmyzsh/ohmyzsh/plugins/emoji-clock/emoji-clock.plugin.zsh
# fpath+=($Z4H/ohmyzsh/ohmyzsh/plugins/supervisor)

# Source additional local files if they exist.
# Enable iTerm2 shell integration (if installed).
# z4h source ~/.iterm2_shell_integration.zsh
# 20201202 N.b.: this breaks p10k needed to run:
# unset ITERM_SHELL_INTEGRATION_INSTALLED && p10k reload

# Define key bindings.
bindkey '^H'   z4h-backward-kill-word   # Ctrl+H and Ctrl+Backspace: Delete previous word.
bindkey '^[^H' z4h-backward-kill-zword  # Ctrl+Alt+Backspace: Delete previous shell word.

# Sort completion candidates when pressing Tab?
zstyle ':completion:*'                           sort               false
# Ignore case
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# Keep cursor position unchanged when Up/Down fetches a command from history?
zstyle ':zle:(up|down)-line-or-beginning-search' leave-cursor       true
# When presented with the list of choices upon hitting Tab, accept selection and
# trigger another completion with this key binding. Great for completing file paths.
zstyle ':fzf-tab:*'                              continuous-trigger tab

# Autoload functions. Zmv is for renaming. Archive etc loaded above.
# Personal ones are under ~/bin/zsh/functions
autoload -Uz -- zmv archive lsarchive unarchive ~/bin/zsh/functions/[^_]*(.)
compdef _directories md

# Brew site functions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  autoload -Uz compinit
  compinit
fi

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -n $z4h_win_home ]] && hash -d w=$z4h_win_home

# Define aliases.
(( $+commands[tree]  )) && alias tree='tree -aC -I .git --dirsfirst'
(( $+commands[gedit] )) && alias gedit='gedit &>/dev/null'
(( $+commands[rsync] )) && alias rsync='rsync --compress --verbose --iconv=UTF-8-MAC,UTF-8 $@'
(( $+commands[exa]   )) && alias exa='exa --group --all --group-directories-first --time-style=long-iso --color-scale $@'
# add $@ to make the options the defaults

# ls Command but with exa with fallback to ls
(( $+commands[exa] )) && alias l='exa --grid --all --group-directories-first --color-scale' || alias l='ls -CF'
(( $+commands[exa] )) && alias lrs='exa --grid --all --group-directories-first --color-scale --reverse' || alias lrs='ls -F'
(( $+commands[exa] )) && alias ll='exa --long --header --all --classify --group --git --group-directories-first --time-style=long-iso --color-scale' || alias ll='ls -lhA'
(( $+commands[exa] )) && alias llrs='exa --long --header --all --classify --group --git --group-directories-first --time-style=long-iso --color-scale --reverse' || alias llrs='ls -lhA'
(( $+commands[exa] )) && alias llr='exa --long --header --all --classify --group --git --group-directories-first --time-style=long-iso --color-scale --recurse -L ' || alias llr='ls -lhA'
(( $+commands[exa] )) && alias lt='exa --tree' || alias lt='ls -lhA'
(( $+commands[exa] )) && alias ltr='exa --tree -L ' || alias lt='ls -lhA'
(( $+commands[exa] )) && alias le='exa --long --header --all --classify --group --git --group-directories-first --time-style=long-iso --color-scale --extended' || alias le='ls -lhA'

# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -A"

# pokayoke
alias cd..="cd .."
alias sl="ls"

# get your ip
alias myip="curl http://ipecho.net/plain; echo"

# Open File and follow
alias t='tail -f'

# Pipe extensions
alias -g G='| ag'
alias -g NE='2> /dev/null'
alias -g NUL='> /dev/null 2>&1'

# Show disk usage
alias dud='du -d 1 -h'
alias duf='du -sh *'

# Find
alias fd='find . -type d -name'
alias ff='find . -type f -name'

# History
alias h='history'
alias hgrep="fc -El 0 | grep"

# Show Processes of current Shell
alias p='ps -f'

# Always ask before proceeding
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots  # glob matches files starting with dot; `ls *` becomes equivalent to `ls *(D)`
setopt print_eight_bit # allow use of japanese files

ulimit -c $(((4 << 30) / 512))  # 4GB

# Define functions.

function lsfunc () {
  print -l ${(ok)functions}
}
# reload the shell
function relogin {
  exec $SHELL --login
}

# functions to manually backup PROdb or dbflex

function tdbackup-esolia {
  cd $HOME/Google\ Drive/\!Backups/PROdb/15331
  /usr/local/bin/mono tdbackup.exe
}

function tdbackup-cookjp {
  cd $HOME/Google\ Drive/\!Backups/PROdb/15361
  /usr/local/bin/mono tdbackup.exe
}

function tdbackup-cookap {
  cd $HOME/Google\ Drive/\!Backups/PROdb/25822
  /usr/local/bin/mono tdbackup.exe
}

function tdbackup-jrc {
  cd $HOME/Google\ Drive/\!Backups/PROdb/26644
  /usr/local/bin/mono tdbackup.exe
}

# function to deploy vector

function vectordeploy {
  cd $HOME/dev/riot/
  chmod -R 755 $HOME/dev/riot/riot/
  /usr/local/bin/rsync -avz -L --checksum --delete --iconv=UTF-8-MAC,UTF-8 --exclude '.well-known' $HOME/dev/riot/riot/ rcogley@cogley.info:/home/rcogley/webapps/es_chat01
}

# function to deploy hugo, had --force and --progress on rsync, maybe Apple's is old?
function hugodeploy-rcc {
  cd $HOME/dev/RCC-Hugo2015
  :>| ~/dev/RCC-Hugo2015/data/postgitinfo.yaml && for f in ~/dev/RCC-Hugo2015/content/post/*.md; do echo "$(cat $f|grep slug|sed 's/slug: //'): $(git log --pretty="%h %s" -1 $f)" >> ~/dev/RCC-Hugo2015/data/postgitinfo.yaml; done
  rm -rf /tmp/rick.cogley.info
  # export RCCCSS_HASH="$(git log -1 --format='%h' $HOME/dev/RCC-Hugo2015/static/bundle/bundle.css)"
  # export TOPICSRCCCSS_HASH="$(git log -1 --format='%h' $HOME/dev/RCC-Hugo2015/static/css/topics.min.css)"
  # export PRISMRCCCSS_HASH="$(git log -1 --format='%h' $HOME/dev/RCC-Hugo2015/static/css/prism.min.css)"
  export PRISMRCCJS_HASH="$(git log -1 --format='%h' $HOME/dev/RCC-Hugo2015/static/js/prism.min.js)"
  export LIGHTRCCCSS_HASH="$(git log -1 --format='%h' $HOME/dev/RCC-Hugo2015/static/css/lightbox.min.css)"
  export LIGHTRCCJS_HASH="$(git log -1 --format='%h' $HOME/dev/RCC-Hugo2015/static/js/lightbox.min.js)"
  chmod -R 775 $HOME/dev/RCC-Hugo2015/static/
  hugo --config="$HOME/dev/RCC-Hugo2015/config.toml" -s $HOME/dev/RCC-Hugo2015/ -d /tmp/rick.cogley.info
  /usr/local/bin/rsync -avz --checksum --delete --iconv=UTF-8-MAC,UTF-8 --exclude '.well-known' /tmp/rick.cogley.info/ rcogley@cogley.info:/home/rcogley/webapps/rick_hugo01
}

function hugodeploy-esoliapro {
  cd $HOME/dev/eSolia.pro
  rm -rf /tmp/esolia.pro
  export STYLECSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia.pro/static/css/style.css)"
  export FEEDEKCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia.pro/static/css/FeedEk-2.0.min.css)"
  export FONTELLOCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia.pro/static/css/fontello.min.css)"
  export GHPMATCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia.pro/static/css/ghpages-materialize.min.css)"
  export MATCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia.pro/static/css/materialize.min.css)"
  export PRISMCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia.pro/static/css/prism.min.css)"
  export TYPOCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia.pro/static/css/typography.min.css)"
  export LATESTSHA="$(git rev-parse master)"
  chmod -R 775 $HOME/dev/eSolia.pro/static/
  hugo --config="$HOME/dev/eSolia.pro/config.toml" -s $HOME/dev/eSolia.pro/ -d /tmp/esolia.pro
  /usr/local/bin/rsync -avz --checksum --delete --iconv=UTF-8-MAC,UTF-8 --exclude '.well-known' /tmp/esolia.pro/ rcogley@cogley.info:/home/rcogley/webapps/es_hugo_esolia_pro_01
  curl -X POST "http://util-02.esolia.com/flowdock/v2/flowdock.php?action=chat&chat_name=Auto-Script&chat_content=%40team%20Copied+files+to+ESOLIA.PRO+site+via+rsync+including+commit+https%3A%2F%2Fgithub.com%2FeSolia%2FeSolia.pro%2Fcommit%2F$LATESTSHA&chat_tags=esolia.pro&flowdock_api=73d6f7%3Df83ad24ab6628fda5ca2b18fff349a5877a928O7o799"
}

function hugodeploy-esoliacom {
  cd $HOME/dev/eSolia
  rm -rf /tmp/esolia.com
  export STYLECSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia/static/css/style.css)"
  export FEEDEKCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia/static/css/FeedEk-2.0.min.css)"
  export FONTELLOCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia/static/css/fontello.min.css)"
  export GHPMATCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia/static/css/ghpages-materialize.min.css)"
  export MATCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia/static/css/materialize.min.css)"
  export PRISMCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia/static/css/prism.min.css)"
  export TYPOCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia/static/css/typography.min.css)"
  export LATESTSHA="$(git rev-parse master)"
  chmod -R 775 $HOME/dev/eSolia/static/
  hugo --config="$HOME/dev/eSolia/config_en.toml" -s $HOME/dev/eSolia/ -d /tmp/esolia.com
  /usr/local/bin/rsync -avz --checksum --delete --iconv=UTF-8-MAC,UTF-8 --exclude '.well-known' /tmp/esolia.com/ rcogley@cogley.info:/home/rcogley/webapps/es_hugo_esolia_com_01
  curl -X POST "http://util-02.esolia.com/flowdock/v2/flowdock.php?action=chat&chat_name=Auto-Script&chat_content=%40team%20Copied+files+to+ESOLIA.COM+site+via+rsync+including+commit+https%3A%2F%2Fgithub.com%2FeSolia%2FeSolia%2Fcommit%2F$LATESTSHA&chat_tags=esolia.com&flowdock_api=73d6f7%3Df83ad24ab6628fda5ca2b18fff349a5877a928O7o799"
}

function hugodeploy-esoliacojp {
  cd $HOME/dev/eSolia
  rm -rf /tmp/esolia.co.jp
  export STYLECSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia/static/css/style.css)"
  export FEEDEKCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia/static/css/FeedEk-2.0.min.css)"
  export FONTELLOCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia/static/css/fontello.min.css)"
  export GHPMATCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia/static/css/ghpages-materialize.min.css)"
  export MATCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia/static/css/materialize.min.css)"
  export PRISMCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia/static/css/prism.min.css)"
  export TYPOCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia/static/css/typography.min.css)"
  export LATESTSHA="$(git rev-parse master)"
  chmod -R 775 $HOME/dev/eSolia/static/
  hugo --config="$HOME/dev/eSolia/config_ja.toml" -s $HOME/dev/eSolia/ -d /tmp/esolia.co.jp
  /usr/local/bin/rsync -avz --checksum --delete --iconv=UTF-8-MAC,UTF-8 --exclude '.well-known' /tmp/esolia.co.jp/ rcogley@cogley.info:/home/rcogley/webapps/es_hugo_esolia_co_jp_01
  curl -X POST "http://util-02.esolia.com/flowdock/v2/flowdock.php?action=chat&chat_name=Auto-Script&chat_content=%40team%20Copied+files+to+ESOLIA.CO.JP+site+via+rsync+including+commit+https%3A%2F%2Fgithub.com%2FeSolia%2FeSolia%2Fcommit%2F$LATESTSHA&chat_tags=esolia.co.jp&flowdock_api=73d6f7%3Df83ad24ab6628fda5ca2b18fff349a5877a928O7o799"
}

function XXhugodeploy-esolia {
  hugogetjson-esolia
  cd $HOME/dev/eSolia_2018/
  rm -rf /tmp/esolia.com
  rm -rf /tmp/esolia.co.jp
  rm -rf /tmp/esolia
  export MAINCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia_2018/static/css/main.min.css)"
  export MAINJS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia_2018/static/js/main.min.js)"
  export LATESTSHA="$(git rev-parse master)"
  chmod -R 775 $HOME/dev/eSolia_2018/static/
  hugo --gc --config="$HOME/dev/eSolia_2018/config.toml" -s $HOME/dev/eSolia_2018/ -d /tmp/esolia
  /usr/local/bin/rsync -avz --checksum --delete --iconv=UTF-8-MAC,UTF-8 --exclude '.well-known' /tmp/esolia/ja/ rcogley@cogley.info:/home/rcogley/webapps/es_hugo_esolia_co_jp_01
  /usr/local/bin/rsync -avz --checksum --delete --iconv=UTF-8-MAC,UTF-8 --exclude '.well-known' /tmp/esolia/en/ rcogley@cogley.info:/home/rcogley/webapps/es_hugo_esolia_com_01
  curl -X POST "http://util-02.esolia.com/flowdock/v2/flowdock.php?action=chat&chat_name=Auto-Script&chat_content=%40team%20Copied+files+to+ESOLIA+site+via+rsync+including+commit+https%3A%2F%2Fgithub.com%2FeSolia%2FeSolia%2Fcommit%2F$LATESTSHA&chat_tags=esoliawebsite&flowdock_api=73d6f7%3Df83ad24ab6628fda5ca2b18fff349a5877a928O7o799"
}

function hugodeploys3-esolia {
  hugogetjson-esolia
  cd $HOME/dev/eSolia_2018/
  rm -rf /tmp/esolia.com
  rm -rf /tmp/esolia.co.jp
  rm -rf /tmp/esolia
  export MAINCSS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia_2018/static/css/main.min.css)"
  export MAINJS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia_2018/static/js/main.min.js)"
  export BUCAJS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia_2018/static/js/bulma-carousel.min.js)"
  export BUSTJS_HASH="$(git log -1 --format='%h' $HOME/dev/eSolia_2018/static/js/bulma-steps.min.js)"
  export LATESTSHA="$(git rev-parse master)"
  chmod -R 775 $HOME/dev/eSolia_2018/static/
  hugo --gc --config="$HOME/dev/eSolia_2018/config.toml" -s $HOME/dev/eSolia_2018/ -d /tmp/esolia
  $HOME/gocode/bin/s3deploy -source=/tmp/esolia/en/ -region=us-east-1 -bucket=esolia.com-cdn $1
  $HOME/gocode/bin/s3deploy -source=/tmp/esolia/ja/ -region=us-east-1 -bucket=esolia.co.jp-cdn $1
  curl -X POST "http://util-02.esolia.com/flowdock/v2/flowdock.php?action=chat&chat_name=Auto-Script&chat_content=%40team%20Copied+files+to+ESOLIA+site+via+rsync+including+commit+https%3A%2F%2Fgithub.com%2FeSolia%2FeSolia%2Fcommit%2F$LATESTSHA&chat_tags=esoliawebsite&flowdock_api=73d6f7%3Df83ad24ab6628fda5ca2b18fff349a5877a928O7o799"
  /usr/local/bin/aws cloudfront create-invalidation --distribution-id E276HZ5CIRLAB3 --paths "/index.html" "/" "/page/*" "/post/*" "/sitemap/*" "/404/*" "/tags/*" "/topics/*"
  /usr/local/bin/aws cloudfront create-invalidation --distribution-id E1PV56T4OOCLME --paths "/index.html" "/" "/page/*" "/post/*" "/sitemap/*" "/404/*" "/tags/*" "/topics/*"
  echo "Done. Use s3deploy -force to force re-upload if needed."
}

function aws-cfclear-esoliacom {
  echo "Invalidating aws cloudfront objects for esolia.com before expiration"
  aws cloudfront create-invalidation --distribution-id E276HZ5CIRLAB3 --paths "/*"
}
function aws-cfclear-esoliacojp {
  echo "Invalidating aws cloudfront objects for esolia.co.jp before expiration"
  aws cloudfront create-invalidation --distribution-id E1PV56T4OOCLME --paths "/*"
}
function aws-cfclear {
  echo "Invalidating aws cloudfront objects for esolia sites for specific path:"
  echo $1
  aws cloudfront create-invalidation --distribution-id E276HZ5CIRLAB3 --paths "/$1/*"
  aws cloudfront create-invalidation --distribution-id E1PV56T4OOCLME --paths "/$1/*"
}


function hugodeploy-RCClive {
  cd $HOME/dev/RCC-live/
  rm -rf /tmp/live.cogley.info
  rm -rf /tmp/tilde.town.rickcogley
  rm -rf /tmp/ctrl-c.club.rickcogley
  chmod -R 775 $HOME/dev/RCC-live/static/
  echo "Generating live.cogley.info"
  hugo --config="$HOME/dev/RCC-live/config.toml" --baseURL="http://live.cogley.info" -s $HOME/dev/RCC-live/ -d /tmp/live.cogley.info
  echo "Syncing live.cogley.info"
  /usr/local/bin/rsync -avz --checksum --delete --iconv=UTF-8-MAC,UTF-8 --exclude '.well-known' /tmp/live.cogley.info/ rcogley@cogley.info:/home/rcogley/webapps/rick_live01
  echo "Generating tilde.town"
  hugo --config="$HOME/dev/RCC-live/config.toml" --baseURL="http://tilde.town/~rickcogley" -s $HOME/dev/RCC-live/ -d /tmp/tilde.town.rickcogley
  echo "Syncing tilde.town"
  /usr/local/bin/rsync -avz --checksum --delete --iconv=UTF-8-MAC,UTF-8 --exclude '.well-known' /tmp/tilde.town.rickcogley/ rickcogley@tilde.town:/home/rickcogley/public_html
  echo "Generating ctrl-c.club"
  hugo --config="$HOME/dev/RCC-live/config.toml" --baseURL="http://ctrl-c.club/~rickcogley" -s $HOME/dev/RCC-live/ -d /tmp/ctrl-c.club.rickcogley
  echo "Syncing ctrl-c.club"
  /usr/local/bin/rsync -avz --checksum --delete --iconv=UTF-8-MAC,UTF-8 --exclude '.well-known' /tmp/ctrl-c.club.rickcogley/ rickcogley@ctrl-c.club:/home/rickcogley/public_html
}

function hugodeploy-jpvad {
  _hugobin="$HOME/gocode/bin/hugo"
  _rsyncbin="/usr/local/bin/rsync"
  _sshlogin="pvad@j-pvad.jp"
  _srvtargetdir="/home/pvad/webapps/jpvad_jp"
  _workingdir="$HOME/dev/abmd-j-pvad"
  # Trailing Slash Required
  _tmpdir="/tmp/j-pvad.jp/"
  cd ${_workingdir}
  rm -rf ${_tmpdir}
  chmod -R 775 ${_workingdir}/static/
  ${_hugobin} --config="${_workingdir}/config.toml" -s ${_workingdir} -d ${_tmpdir}
  ${_rsyncbin} -avz --checksum --delete --iconv=UTF-8-MAC,UTF-8 --exclude '.well-known' ${_tmpdir} ${_sshlogin}:${_srvtargetdir}
}

function hugodeploy-dev-jpvad {
  _hugobin="$HOME/gocode/bin/hugo"
  _rsyncbin="/usr/local/bin/rsync"
  _sshlogin="pvad@j-pvad.jp"
  _srvtargetdir="/home/pvad/webapps/jpvad_jp_dev"
  _workingdir="$HOME/dev/abmd-j-pvad"
  # Trailing Slash Required
  _tmpdir="/tmp/dev.j-pvad.jp/"
  cd ${_workingdir}
  rm -rf ${_tmpdir}
  chmod -R 775 ${_workingdir}/static/
  ${_hugobin} --config="${_workingdir}/config.toml" -s ${_workingdir} -d ${_tmpdir} --baseURL="http://dev.j-pvad.jp"
  ${_rsyncbin} -avz --checksum --delete --iconv=UTF-8-MAC,UTF-8 --exclude '.well-known' ${_tmpdir} ${_sshlogin}:${_srvtargetdir}
}

function hugogetjson-jvad {
  rm -rf $HOME/dev/j-vad/data/seminars.json
  /usr/local/opt/curl/bin/curl --silent -k "https://pro.dbflex.net/secure/api/v2/55317/$(cat $HOME/.ssh/tokens/jvad-01)/Seminar/List%20All%20for%20JSON/select.json" | /usr/local/bin/jq '.' > $HOME/dev/j-vad/data/seminars.json
}

function hugogetjson-logr {
  rm -rf $HOME/dev/logr.cogley.info/data/holidays.json
  /usr/local/opt/curl/bin/curl --silent "https://pro.dbflex.net/secure/api/v2/15331/$(cat $HOME/.ssh/tokens/prodb-01)/Work%20Holiday/API%20Holidays/select.json" | /usr/local/bin/jq '.' > $HOME/dev/logr.cogley.info/data/holidays.json
}

function hugogetjson-esolia {
  rm -rf $HOME/dev/eSolia_2018/data/success.json
  /usr/local/opt/curl/bin/curl --silent -k "https://pro.dbflex.net/secure/api/v2/15331/$(cat $HOME/.ssh/tokens/prodb-01)/Web%20Project/List%20All%20for%20JSON/select.json" | /usr/local/bin/jq '.' > $HOME/dev/eSolia_2018/data/success.json
  rm -rf $HOME/dev/eSolia_2018/data/info.json
  /usr/local/opt/curl/bin/curl --silent -k "https://pro.dbflex.net/secure/api/v2/15331/$(cat $HOME/.ssh/tokens/prodb-01)/Web%20Information/List%20All%20on%20Website/select.json"  | /usr/local/bin/jq '.' > $HOME/dev/eSolia_2018/data/info.json
  rm -rf $HOME/dev/eSolia_2018/data/japancontact.json
  /usr/local/opt/curl/bin/curl --silent -k "https://pro.dbflex.net/secure/api/v2/15331/$(cat $HOME/.ssh/tokens/prodb-01)/Web%20Japan%20Contact%20and%20App/API%20List%20All/select.json" | /usr/local/bin/jq '.' > $HOME/dev/eSolia_2018/data/japancontact.json
  rm -rf $HOME/dev/eSolia_2018/data/japanapp.json
  /usr/local/opt/curl/bin/curl --silent -k "https://pro.dbflex.net/secure/api/v2/15331/$(cat $HOME/.ssh/tokens/prodb-01)/Web%20Japan%20Contact%20and%20App/API%20List%20All%20Apps/select.json" | /usr/local/bin/jq '.' > $HOME/dev/eSolia_2018/data/japanapp.json
  rm -rf $HOME/dev/eSolia_2018/static/eSolia-Japan-Emergency-Contacts.en.csv
  /usr/local/opt/curl/bin/curl --silent -k "https://pro.dbflex.net/secure/api/v2/15331/$(cat $HOME/.ssh/tokens/prodb-01)/Web%20Japan%20Contact%20and%20App/API%20List%20for%20CSV/select.csv" -o $HOME/dev/eSolia_2018/static/eSolia-Japan-Emergency-Contacts.en.csv
  rm -rf $HOME/dev/eSolia_2018/static/eSolia-Japan-Emergency-Contacts.ja.csv
  /usr/local/opt/curl/bin/curl --silent -k "https://pro.dbflex.net/secure/api/v2/15331/$(cat $HOME/.ssh/tokens/prodb-01)/Web%20Japan%20Contact%20and%20App/API%20List%20for%20CSV%E2%80%A1/select.csv" -o $HOME/dev/eSolia_2018/static/eSolia-Japan-Emergency-Contacts.ja.csv
}

function 444hugodeploy-jvad {
  _hugobin="$HOME/gocode/bin/hugo"
  _rsyncbin="/usr/local/bin/rsync"
  _sshlogin="jvad@j-vad.jp"
  _srvtargetdir="/home/jvad/webapps/jvad_jp"
  _workingdir="$HOME/dev/j-vad"
  # Trailing Slash Required
  _tmpdir="/tmp/dev1.j-vad.jp/"
  cd ${_workingdir}
  rm -rf ${_tmpdir}
  chmod -R 775 ${_workingdir}/static/
  ${_hugobin} --debug --config="${_workingdir}/config.toml" -s ${_workingdir} -d ${_tmpdir}
  ${_rsyncbin} -avz --checksum --delete --iconv=UTF-8-MAC,UTF-8 --exclude '.well-known' ${_tmpdir} ${_sshlogin}:${_srvtargetdir}
}

function hugodeploy (){
  echo "====== Deploy $1 site to AWS S3 ======"
  echo " "
  echo "Usage: hugodeploy sitestring /path/from/home"
  hugogetjson-jvad
  _hugobin="$HOME/gocode/bin/hugo"
  _awsbin="/usr/local/bin/aws"
  _workingdir="$HOME$2"
  _current_aws_profile="$AWS_PROFILE"
  cd ${_workingdir}
  export AWS_PROFILE="$1"
  echo "🍺 Confirm aws profile via \"aws configure list\""
  ${_awsbin} configure list
  echo "🍺 Build and deploy site"
  ${_hugobin} && ${_hugobin} deploy --invalidateCDN --target $1 --verbose
  [[ -z "$_current_aws_profile" ]] && unset AWS_PROFILE || export AWS_PROFILE=${_current_aws_profile}
}

function testme (){
  _teststring="$1"
  _testpath="$HOME$2"
  echo $_teststring
  echo $_testpath
}

function hugodeploy-esoliauploader {
  _hugobin="$HOME/gocode/bin/hugo"
  _rsyncbin="/usr/local/bin/rsync"
  _sshlogin="rcogley@cogley.info"
  _srvtargetdir="/home/rcogley/webapps/es_files01"
  _workingdir="$HOME/dev/eSolia-Uploader"
  # Trailing Slash Required
  _tmpdir="/tmp/files.esolia.com/"
  cd ${_workingdir}
  rm -rf ${_tmpdir}
  chmod -R 775 ${_workingdir}/static/
  ${_hugobin} --config="${_workingdir}/config.toml" -s ${_workingdir} -d ${_tmpdir}
  ${_rsyncbin} -avz --checksum --delete --iconv=UTF-8-MAC,UTF-8 --exclude '.well-known' ${_tmpdir} ${_sshlogin}:${_srvtargetdir}
}

# function to run hugo server

function hugoserver-esolia {
  hugogetjson-esolia
  cd $HOME/dev/eSolia_2018
  hugo server --navigateToChanged --buildDrafts --buildFuture --watch --verbose --source="$HOME/dev/eSolia_2018" --config="$HOME/dev/eSolia_2018/config.toml" --port=1366
}

function hugoserver-esoliacom {
  cd $HOME/dev/eSolia
  hugo server --navigateToChanged --buildDrafts --buildFuture --watch --verbose --source="$HOME/dev/eSolia" --config="$HOME/dev/eSolia/config_en.toml" --port=1377
}

function hugoserver-stable-esoliacom {
  cd $HOME/dev/eSolia
  /usr/local/Cellar/hugo/0.14/bin/hugo server --buildDrafts --buildFuture --watch --verbose --source="$HOME/dev/eSolia" --config="$HOME/dev/eSolia/config_en.toml" --port=1377
}

function hugoserver-esoliacojp {
  cd $HOME/dev/eSolia
  hugo server --navigateToChanged --buildDrafts --buildFuture --watch --verbose --source="$HOME/dev/eSolia" --config="$HOME/dev/eSolia/config_ja.toml" --port=1399
}

function hugoserver-stable-esoliacojp {
  cd $HOME/dev/eSolia
  /usr/local/Cellar/hugo/0.14/bin/hugo server --buildDrafts --buildFuture --watch --verbose --source="$HOME/dev/eSolia" --config="$HOME/dev/eSolia/config_ja.toml" --port=1399
}

function hugoserver-esoliapro {
  cd $HOME/dev/eSolia.pro
  hugo server --navigateToChanged --buildDrafts --buildFuture --watch --verbose --source="$HOME/dev/eSolia.pro" --config="$HOME/dev/eSolia.pro/config.toml" --port=1388
}

function hugoserver-rcc {
  cd $HOME/dev/RCC-Hugo2015
  hugo server --navigateToChanged --buildDrafts --buildFuture --watch --verbose --source="$HOME/dev/RCC-Hugo2015" --config="$HOME/dev/RCC-Hugo2015/config.toml" --port=1313
}

function hugoserver-rcclive {
  cd $HOME/dev/RCC-live
  hugo server --navigateToChanged --buildDrafts --buildFuture --watch --verbose --source="$HOME/dev/RCC-live" --config="$HOME/dev/RCC-live/config.toml" --port=1314 --enableGitInfo
}

function hugoserver-jvad {
  hugogetjson-jvad
  cd $HOME/dev/j-vad
  hugo server --navigateToChanged --buildDrafts --buildFuture --watch --verbose --source="$HOME/dev/j-vad" --config="$HOME/dev/j-vad/config.toml" --port=1315 --enableGitInfo
}

function hugoserver-jpvad {
  cd $HOME/dev/abmd-j-pvad
  hugo server --navigateToChanged --buildDrafts --buildFuture --watch --verbose --source="$HOME/dev/abmd-j-pvad" --config="$HOME/dev/abmd-j-pvad/config.toml" --port=1316 --enableGitInfo
}

function hugoserver-esoliauploader {
  cd $HOME/dev/eSolia-Uploader
  hugo server --navigateToChanged --buildDrafts --buildFuture --watch --verbose --source="$HOME/dev/eSolia-Uploader" --config="$HOME/dev/eSolia-Uploader/config.toml" --port=1317 --enableGitInfo
}

# Function for creating posts

function hugogenpost-live {
  if [[ -z $1 ]]; then
  echo "A double-quoted post title is required"
  exit 1
  fi

  _hugobin="$HOME/gocode/bin/hugo"
  _workingdir="$HOME/dev/RCC-Live"
  _contentdir="${_workingdir}/content/post"
  _hytitle=$(echo $1 | tr ' ' '-')
  _hytitlelower=$(echo ${_hytitle} | tr "[:upper:]" "[:lower:]")
  _hytitlelowerquoted=$(echo \"$_hytitlelower\")
  _date=$(date +'%Y-%m-%d')
  _datetime=$(date +'%Y-%m-%d %H:%M:%S')
  _contentfile="${_date}-${_hytitle}.md"

  cd ${_workingdir}
  ${_hugobin} new post/${_hytitle}.md
  mv ${_contentdir}/${_hytitle}.md ${_contentdir}/${_contentfile}
  # sed -i 's/slug = ""/slug = '"${_hytitlelowerquoted}"'/g' ${_contentdir}/${_contentfile}
  # echo ${_hytitlelowerquoted} >> ${_contentdir}/${_contentfile}
  $EDITOR ${_contentdir}/${_contentfile}
}

function hugodeploy-logr {
  hugogetjson-logr
  _hugobin="$HOME/gocode/bin/hugo"
  _gitbin="/usr/local/bin/git"
  _rsyncbin="/usr/bin/rsync"
  _workingdir="$HOME/dev/logr.cogley.info"
  _targetdir="/Volumes/keybase/public/rickcogley/sites/logr_cogley_info/"
  _datetime=$(date +'%Y%m%d-%H%M%S')

  cd ${_workingdir}
  ${_gitbin} add *
  ${_gitbin} commit -m "Logr update post ${_datetime}"
  ${_gitbin} push origin master
  ${_hugobin} --gc --minify
  # ${_rsyncbin} --verbose --compress --archive --recursive --partial --progress --checksum --delete --exclude '.git' ${_workingdir}/public/ ${_targetdir}
  up production
  ping-rcclogr
  sleep 30
  logrtweet 0
}

function hugoretry-logr {
  hugogetjson-logr
  _hugobin="$HOME/gocode/bin/hugo"
  _gitbin="/usr/local/bin/git"
  _rsyncbin="/usr/bin/rsync"
  _workingdir="$HOME/dev/logr.cogley.info"
  _targetdir="/Volumes/keybase/public/rickcogley/sites/logr_cogley_info/"
  _datetime=$(date +'%Y%m%d-%H%M%S')

  cd ${_workingdir}
  ${_gitbin} add *
  ${_gitbin} commit -m "Logr update post ${_datetime}"
  ${_gitbin} push origin master
  ${_hugobin} --gc --minify
  # ${_rsyncbin} --verbose --compress --archive --recursive --partial --progress --checksum --delete --exclude '.git' ${_workingdir}/public/ ${_targetdir}
  up production
}

function logrtweet {
  : ${1?Call with int val for arg one to pull from index dot json}
  _twtybin="$HOME/gocode/bin/twty"
  _jqbin="/usr/local/bin/jq"
  _hugobin="$HOME/gocode/bin/hugo"
  _workingdir="$HOME/dev/logr.cogley.info"
  _targetdir="/tmp/logr.cogley.info"

  rm -rf ${_targetdir}
  cd ${_workingdir}
  ${_hugobin} -d ${_targetdir}

  _tweetdata=$(cat ${_targetdir}/index.json | ${_jqbin} --arg recindex $1 --raw-output '.[$recindex|tonumber] | .content[:200]+"... #logr "+.ref')
  # _twurldata="status=${_tweetdata}"
  # echo ${_twurldata}
  ${_twtybin} ${_tweetdata}
}

function logrtweet-1 {
  : ${1?Call with int val for arg one to pull from index dot json}
  _twurlbin="$HOME/.rbenv/shims/twurl"
  _jqbin="/usr/local/bin/jq"
  _hugobin="$HOME/gocode/bin/hugo"
  _workingdir="$HOME/dev/logr.cogley.info"
  _targetdir="/tmp/logr.cogley.info"

  rm -rf ${_targetdir}
  cd ${_workingdir}
  ${_hugobin} -d ${_targetdir}

  _tweetdata=$(cat ${_targetdir}/index.json | ${_jqbin} --arg recindex $1 --raw-output '.[$recindex|tonumber] | .content[:200]+"... #logr "+.ref')
  # _twurldata="status=${_tweetdata}"
  # echo ${_twurldata}
  ${_twurlbin} -d "status=${_tweetdata}" /1.1/statuses/update.json
}

# Set date in markdown file

function crapsetdate {
  sed -i "/^date/d" $1;
  sed -i "3idate = \"$(date +%Y-%m-%dT%H:%M:%S%:z)\"" $1;
}

function setdate() {
  file=$1
  now=$(date "+%Y-%m-%dT%H:%M:%S%z" | sed -e 's/00$/:00/')
  if [ -f $file ]; then
  mv $file $file-
  # sed -e 's/^date *= *"20.*"$/date = "'$now'"/' -e 's/^draft *= *true//' < $file- > $file
  sed -e 's/^date *= *"20.*"$/date = "'$now'"/' < $file- > $file
  else
  echo "$file not found"
  exit 1
  fi
  exit 0
}

function date3339() {
  echo "Putting RFC3339 on Clipboard for Frontmatter"
  gdate --rfc-3339=seconds | sed 's/ /T/' | head -c -1 | pbcopy >&1
  echo "Date in RFC 3339 format on clipboard. Paste away"
}

# Function for Hugo bundle conversion thanks to @onedrawingperday

function hugo-all-md2bundle {
  for FILE in *.md
  do
  # remove the last dot and subsequent chars to name the folder from the .md
  DIR="${FILE%.*}"
  mkdir -p "$DIR"
  mv "$FILE" "$DIR"
  done
  find ./ -iname '*.md' -execdir mv -i '{}' index.md \;
}

function hugo-md2bundle {
  for FILE in $1
  do
  # remove the last dot and subsequent chars to name the folder from the .md
  DIR="${FILE%.*}"
  mkdir -p "$DIR"
  mv "$FILE" "$DIR"
  done
  find ./ -iname '*.md' -execdir mv -i '{}' index.md \;
}

# Function for pinging after posting

function ping-rcclive {
  echo "Hitting ping-o-matic"
  curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Safari/604.1.38" "https://pingomatic.com/ping/?title=Rick+Cogley+Live&blogurl=http%3A%2F%2Flive.cogley.info&rssurl=http%3A%2F%2Flive.cogley.info%2Findex.xml&chk_weblogscom=on&chk_blogs=on&chk_feedburner=on&chk_newsgator=on&chk_myyahoo=on&chk_pubsubcom=on&chk_blogdigger=on&chk_weblogalot=on&chk_newsisfree=on&chk_topicexchange=on&chk_google=on&chk_tailrank=on&chk_skygrid=on&chk_collecta=on&chk_superfeedr=on"
  echo "Hitting google sitemap submit"
  curl "http://www.google.com/webmasters/tools/ping?sitemap=http%3A%2F%2Flive.cogley.info%2Fsitemap.xml"
  echo "Hitting bing sitemap submit"
  curl "http://www.bing.com/webmaster/ping.aspx?siteMap=http%3A%2F%2Flive.cogley.info%2Fsitemap.xml"
}

function ping-rcclogr {
  echo "Hitting ping-o-matic"
  curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Safari/604.1.38" "https://pingomatic.com/ping/?title=Rick+Cogley+Logr&blogurl=http%3A%2F%2Flogr.cogley.info&rssurl=http%3A%2F%2Flogr.cogley.info%2Findex.xml&chk_weblogscom=on&chk_blogs=on&chk_feedburner=on&chk_newsgator=on&chk_myyahoo=on&chk_pubsubcom=on&chk_blogdigger=on&chk_weblogalot=on&chk_newsisfree=on&chk_topicexchange=on&chk_google=on&chk_tailrank=on&chk_skygrid=on&chk_collecta=on&chk_superfeedr=on"
  echo "Hitting google sitemap submit"
  curl "http://www.google.com/webmasters/tools/ping?sitemap=http%3A%2F%2Flogr.cogley.info%2Fsitemap.xml"
  echo "Hitting bing sitemap submit"
  curl "http://www.bing.com/webmaster/ping.aspx?siteMap=http%3A%2F%2Flogr.cogley.info%2Fsitemap.xml"
}

function ping-rcclistr {
  echo "Hitting ping-o-matic"
  curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Safari/604.1.38" "https://pingomatic.com/ping/?title=Rick+Cogley+Listr&blogurl=http%3A%2F%2Flistr.cogley.info&rssurl=http%3A%2F%2Flistr.cogley.info%2Findex.xml&chk_weblogscom=on&chk_blogs=on&chk_feedburner=on&chk_newsgator=on&chk_myyahoo=on&chk_pubsubcom=on&chk_blogdigger=on&chk_weblogalot=on&chk_newsisfree=on&chk_topicexchange=on&chk_google=on&chk_tailrank=on&chk_skygrid=on&chk_collecta=on&chk_superfeedr=on"
  echo "Hitting google sitemap submit"
  curl "http://www.google.com/webmasters/tools/ping?sitemap=http%3A%2F%2Flistr.cogley.info%2Fsitemap.xml"
  echo "Hitting bing sitemap submit"
  curl "http://www.bing.com/webmaster/ping.aspx?siteMap=http%3A%2F%2Flistr.cogley.info%2Fsitemap.xml"
}

function ping-rccmain {
  echo "Hitting ping-o-matic"
  curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Safari/604.1.38" "https://pingomatic.com/ping/?title=Rick+Cogley+Central&blogurl=https%3A%2F%2Frick.cogley.info&rssurl=https%3A%2F%2Frick.cogley.info%2Findex.xml&chk_weblogscom=on&chk_blogs=on&chk_feedburner=on&chk_newsgator=on&chk_myyahoo=on&chk_pubsubcom=on&chk_blogdigger=on&chk_weblogalot=on&chk_newsisfree=on&chk_topicexchange=on&chk_google=on&chk_tailrank=on&chk_skygrid=on&chk_collecta=on&chk_superfeedr=on"
  echo "Hitting google sitemap submit"
  curl "http://www.google.com/webmasters/tools/ping?sitemap=https%3A%2F%2Frick.cogley.info%2Fsitemap.xml"
  echo "Hitting bing sitemap submit"
  curl "http://www.bing.com/webmaster/ping.aspx?siteMap=https%3A%2F%2Frick.cogley.info%2Fsitemap.xml"
}

function ping-jvad {
  echo "Hitting ping-o-matic"
  curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Safari/604.1.38" "http://pingomatic.com/ping/?title=補助人工心臓治療関連学会協議会（VAD協議会）&blogurl=http%3A%2F%2Fj-vad.jp&rssurl=http%3A%2F%2Fj-vad.jp%2Findex.xml&chk_weblogscom=on&chk_blogs=on&chk_feedburner=on&chk_newsgator=on&chk_myyahoo=on&chk_pubsubcom=on&chk_blogdigger=on&chk_weblogalot=on&chk_newsisfree=on&chk_topicexchange=on&chk_google=on&chk_tailrank=on&chk_skygrid=on&chk_collecta=on&chk_superfeedr=on"
  echo "Hitting google sitemap submit"
  curl "http://www.google.com/webmasters/tools/ping?sitemap=https%3A%2F%2Fj-vad.jp%2Fsitemap.xml"
  echo "Hitting bing sitemap submit"
  curl "http://www.bing.com/webmaster/ping.aspx?siteMap=https%3A%2F%2Fj-vad.jp%2Fsitemap.xml"
}

function ping-jpvad {
  echo "Hitting ping-o-matic"
  curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Safari/604.1.38" "http://pingomatic.com/ping/?title=補助人工心臓治療関連学会協議会 インペラ部会 &blogurl=http%3A%2F%2Fj-pvad.jp&rssurl=http%3A%2F%2Fj-pvad.jp%2Findex.xml&chk_weblogscom=on&chk_blogs=on&chk_feedburner=on&chk_newsgator=on&chk_myyahoo=on&chk_pubsubcom=on&chk_blogdigger=on&chk_weblogalot=on&chk_newsisfree=on&chk_topicexchange=on&chk_google=on&chk_tailrank=on&chk_skygrid=on&chk_collecta=on&chk_superfeedr=on"
  echo "Hitting google sitemap submit"
  curl "http://www.google.com/webmasters/tools/ping?sitemap=https%3A%2F%2Fj-pvad.jp%2Fsitemap.xml"
  echo "Hitting bing sitemap submit"
  curl "http://www.bing.com/webmaster/ping.aspx?siteMap=https%3A%2F%2Fj-pvad.jp%2Fsitemap.xml"
}

function ping-esolia {
  echo "Hitting ping-o-matic"
  curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Safari/604.1.38" "http://pingomatic.com/ping/?title=イソリア+バイリンガル+IT+アウトソーシング&blogurl=https%3A%2F%2Fesolia.co.jp&rssurl=https%3A%2F%2Fesolia.co.jp%2Findex.xml&chk_weblogscom=on&chk_blogs=on&chk_feedburner=on&chk_newsgator=on&chk_myyahoo=on&chk_pubsubcom=on&chk_blogdigger=on&chk_weblogalot=on&chk_newsisfree=on&chk_topicexchange=on&chk_google=on&chk_tailrank=on&chk_skygrid=on&chk_collecta=on&chk_superfeedr=on"
  echo "Hitting google sitemap submit"
  curl "http://www.google.com/webmasters/tools/ping?sitemap=https%3A%2F%2Fesolia.co.jp%2Fsitemap.xml"
  echo "Hitting bing sitemap submit"
  curl "http://www.bing.com/webmaster/ping.aspx?siteMap=https%3A%2F%2Fesolia.co.jp%2Fsitemap.xml"
  echo "Hitting ping-o-matic"
  curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Safari/604.1.38" "http://pingomatic.com/ping/?title=eSolia+Bilingual+IT+Outsourcing&blogurl=https%3A%2F%2Fesolia.com&rssurl=https%3A%2F%2Fesolia.com%2Findex.xml&chk_weblogscom=on&chk_blogs=on&chk_feedburner=on&chk_newsgator=on&chk_myyahoo=on&chk_pubsubcom=on&chk_blogdigger=on&chk_weblogalot=on&chk_newsisfree=on&chk_topicexchange=on&chk_google=on&chk_tailrank=on&chk_skygrid=on&chk_collecta=on&chk_superfeedr=on"
  echo "Hitting google sitemap submit"
  curl "http://www.google.com/webmasters/tools/ping?sitemap=https%3A%2F%2Fesolia.com%2Fsitemap.xml"
  echo "Hitting bing sitemap submit"
  curl "http://www.bing.com/webmaster/ping.aspx?siteMap=https%3A%2F%2Fesolia.com%2Fsitemap.xml"
}


# function to output hugo config

function hugoconfig-esoliacom {
  cd $HOME/dev/eSolia
  hugo config --config="$HOME/dev/eSolia/config_en.toml" > $HOME/dev/eSolia/config_en.txt
}

function hugoconfig-esoliacojp {
  cd $HOME/dev/eSolia
  hugo config --config="$HOME/dev/eSolia/config_ja.toml" > $HOME/dev/eSolia/config_ja.txt
}

function hugoconfig-rcc {
  cd $HOME/dev/RCC-Hugo2015
  hugo config --config="$HOME/dev/RCC-Hugo2015/config.toml" > $HOME/dev/RCC-Hugo2015/config.txt
}

function hugowatchesolias {
  chrome http://localhost:1399
  chrome http://localhost:1377
}

# FileSearch
function f() { find . -iname "*$1*" ${@:2} }
function r() { grep "$1" ${@:2} -R . }

# mkdir and cd (not needed as it is built in as take)
#function mkcd() { mkdir -p "$@" && cd "$_"; }

# put pgp on clipboard

function pgp2clipboard {
  gpg --armor --export E8404D8E8DAB59CD1E5255BD56BCDEBC6448A091 | pbcopy
}

### TaskWarrior ###
# Alias for quick add to inbox

alias in='task add +in'

# Tickle task into inbox

tickle () {
  deadline=$1
  shift
  in +tickle wait:$deadline $@
}

# tw research and dev alias

alias rnd='task add +rnd +next +computer +online'

# tw read and review some URL

webpage_title (){
  wget -qO- "$*" | hxselect -s '\n' -c  'title' 2>/dev/null
}

read_and_review (){
  link="$1"
  title=$(webpage_title $link)
  echo $title
  descr="\"Read and review: $title\""
  id=$(task add +next +rnr "$descr" | sed -n 's/Created task \(.*\)./\1/p')
  task "$id" annotate "$link"
}

alias rnr=read_and_review

# tw context

alias tc="task context"
alias tt="task rc.context=none"
alias twork="task rc.context=work"
alias thome="task rc.context=home"
alias tgoto="task rc.context=goto"

# tw status one-liner (note that export -f does not work with zsh)

tw_get_status_line () {
  echo "TW Done:$(task count end.after:today) Due:$(task count +DUE) Overdue:$(task count +OVERDUE) Next:$(task count +next)"
}

alias tws=tw_get_status_line

tw_task_push_pull () {
  task $1 modify due:due$2 scheduled:scheduled$2 wait:wait$2
}

alias tpp=tw_task_push_pull

# tw find tasks with due before wait
#
tw_find_due_before_wait () {
  task due.before:wait all
}

alias tdb4w=tw_find_due_before_wait

# BROWSER
open_by_browser(){ open -a $1 $2}
alias firefox='open_by_browser firefox'
alias chrome='open_by_browser "Google Chrome"'
alias esolia='chrome http://www.esolia.com'
alias lsregister='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister'

# Upgrade brew HEAD apps
brew_reinstall_head_apps (){
  brew reinstall --HEAD neovim
  brew reinstall --HEAD fzf
  brew reinstall --HEAD tmux
}


brewcaskrelink (){
  brew cask list -1 | while read line; do brew cask uninstall --force $line; brew cask install $line; done
}

# make notes

note (){
  nvim "$HOME/Dropbox/Notes/$1 - $(date +"%Y%m%d").md"
}

# check PROdb backup
#

confirmprodbbackup (){
  echo Confirming local PROdb backup ...
  ls -la ~/Google\ Drive/\!Backups/PROdb/15331-eSolia-DB-$(date +'%Y')/
  echo Confirming webfaction PROdb backup ...
  ssh rcogley@cogley.info ls -la /home/rcogley/webapps/es_dbflexbackup01/15331-eSolia-DB-$(date +'%Y')
}

# flush dns
#
function flushdns (){
  echo "Flushing DNS, enter your user password if prompted:"
  sudo killall -HUP mDNSResponder
  sudo killall mDNSResponderHelper
  sudo dscacheutil -flushcache
  say dns can sod off
}



# update hugo

hugodevinstall (){
  echo "==Do setup=="
  _wherewasi=$(pwd)
  _package="github.com/gohugoio/hugo"
  _builddate=$(date +%FT%T%z)
  export CGO_ENABLED=1
  export GO_EXTLINK_ENABLED=1

  # echo "==Install govendor if it isn't=="
  # if ! hash govendor 2>/dev/null
  # then
  #  go get -u -v github.com/kardianos/govendor
  # fi

  echo "==Install hugo if it isn't=="
  if [[ ! -d "${GOPATH}/src/${_package}" ]] || ( ! hash hugo 2>/dev/null )
  then
  go get -u -v -d ${_package}
  fi

  echo "==Install mage if it isn't=="
  if [[ ! -d "${GOPATH}/src/github.com/magefile/mage" ]] || ( ! hash mage 2>/dev/null )
  then
  go get github.com/magefile/mage
  fi

  echo "==Move current hugo to hugo-prev in case of need to revert=="
  mv ${GOPATH}/bin/hugo ${GOPATH}/bin/hugo-prev

  echo "==Update to hugo master branch=="
  # Mage must be run from the hugo source directory
  cd ${GOPATH}/src/${_package} || exit
  git fetch --all # fetch new branch names if any
  git checkout master
  # Force update the vendor file in case it got changed
  git reset --hard origin/master

  # echo "==Sync dependent packages per the updated vendor file=="
  # govendor sync

  # echo "==Update goorgeous package to master for orgmode=="
  # govendor fetch github.com/chaseadamsio/goorgeous

  # Fetch dependencies
  echo "==Fetch dependencies=="
  mage vendor

  echo "==Build, install and test latest hugo=="
  _commithash=$(git rev-parse --short HEAD 2>/dev/null)
  mage hugo
  HUGO_BUILD_TAGS=extended mage install
  # Test but it needs CGO_ENABLED 1
  # mage hugoRace
  # mage -v check

  # go install -v \
  # -ldflags "-X ${_package}/hugolib.CommitHash=${_commithash} \
  #           -X ${_package}/hugolib.BuildDate=${_builddate}" \
  # ${_package}

  echo "==Prep hugo with version string=="
  cd ${GOPATH}/bin
  _newhugoverstr=$($GOPATH/bin/hugo version | awk -F ' ' '{ print $5 }')
  mv $GOPATH/bin/hugo $GOPATH/bin/hugo-${_newhugoverstr}mage
  ln -sf $GOPATH/bin/hugo-${_newhugoverstr}mage hugo

  cd $HOME
  echo "==Sanity check - compare versions from home folder =="
  echo "Expecting: ${_newhugoverstr}"
  echo "Actual: "
  hugo version
  echo "Previous: "
  hugo-prev version

  cd "${_wherewasi}" || exit
}

hugoprodinstall (){
  echo "==Set vars, get latest release via github api...=="
  _wherewasi=$(pwd)
  # Assumes jq installed
  _latestver=$(curl --silent "https://api.github.com/repos/gohugoio/hugo/tags" | jq -r '.[0].name' | tr -d v)

  echo "==Move current hugo symlink to hugo-prev in case of need to revert...=="
  cd ${GOPATH}/bin/
  mv ${GOPATH}/bin/hugo ${GOPATH}/bin/hugo-prev

  echo "==Download and unzip latest Mac extended release...=="
  mkdir tmp
  cd tmp
  # Need -L on curl because it's redirecting, and that in turn means you need to redirect to a file.
  echo "Downloading hugo v${_latestver}"
  curl -L "https://github.com/gohugoio/hugo/releases/download/v${_latestver}/hugo_extended_${_latestver}_macOS-64bit.tar.gz" > hugo_extended_${_latestver}_macOS-64bit.tar.gz
  tar xvfz hugo_extended_${_latestver}_macOS-64bit.tar.gz

  echo "==Move hugo into position...=="
  cd ${GOPATH}/bin
  mv ${GOPATH}/bin/tmp/hugo ${GOPATH}/bin/
  echo "hugo located in ${GOPATH}/bin/"
  rm -rf tmp/

  echo "==Prep hugo copy with version string, in case reversion needed, and symlink it...=="
  # Fragile because it's based on hugo std-out output
  _newhugoverstr=$($GOPATH/bin/hugo version | awk -F ' ' '{ print $5 }' | tr / -)
  mv ${GOPATH}/bin/hugo $GOPATH/bin/hugo-${_newhugoverstr}
  echo "new hugo moved to $GOPATH/bin/hugo-${_newhugoverstr}"
  ln -sf ${GOPATH}/bin/hugo-${_newhugoverstr} hugo

  cd $HOME
  echo "==Sanity check - compare versions...=="
  echo "Expecting: ${_newhugoverstr}"
  echo "Actual: "
  hugo version
  echo "Previous: "
  hugo-prev version

  cd "${_wherewasi}" || exit
}

makevcard (){
  echo "Creates support vcard to attach to PROdb Client record."
  echo "Usage: makevcard ACME \"Acme Japan\""
  _tmpl=$HOME/dev/eSolia-Snippets/ESOLIA/esolia-support-contacts-vcard-template.txt
  sed "s/CLIENTCODE/${1:l}/g" <${_tmpl} >eSolia-${1}-Support.vcf
  sed -i '' "s/CLIENTNAME/${2}/g" eSolia-${1}-Support.vcf
  cat eSolia-${1}-Support.vcf
}

function fdleave (){
  /usr/local/opt/curl/bin/curl --silent -k -X "POST" "https://api.flowdock.com/flows/esolia/$1/messages?content=%40team%20Migrating%20to%20Slack%20from%2018p%20today.%20Ok%20to%20use%20client%20flows%20from%20this%20evening.&event=message" -u '$(cat $HOME/.ssh/tokens/flowdock-01):dummy'
}

function serve-it (){
  php -S localhost:8080
}

function deploy-sendy-jtrans (){
  echo "First arg is Sendy version"
  _rsyncbin="/usr/local/bin/rsync"
  # Trailing Slash Required
  _workingdir="$HOME/dev/sendy-japanese-translation/$1/locale/ja_JP/LC_MESSAGES/"
  _sshlogin="rcogley@cogley.info"
  _srvtargetdir="/home/rcogley/webapps/es_send_esolia_pro_1/locale/ja_JP/LC_MESSAGES"
  ${_rsyncbin} -avz --checksum --delete --iconv=UTF-8-MAC,UTF-8 ${_workingdir} ${_sshlogin}:${_srvtargetdir}
}

function deploy-sendy-etrans (){
  echo "First arg is Sendy version"
  _rsyncbin="/usr/local/bin/rsync"
  # Trailing Slash Required
  _workingdir="$HOME/dev/sendy-japanese-translation/$1/locale/en_US/LC_MESSAGES/"
  _sshlogin="rcogley@cogley.info"
  _srvtargetdir="/home/rcogley/webapps/es_send_esolia_pro_1/locale/en_US/LC_MESSAGES"
  ${_rsyncbin} -avz --checksum --delete --iconv=UTF-8-MAC,UTF-8 ${_workingdir} ${_sshlogin}:${_srvtargetdir}
}

function aboptim (){
  _arg1filename=${1%.*}
  _arg1extension=${1##*.}
  _fileprefix="abiomed-profed-"
  _newwidth="231"
  _newwidthsuffix="-${_newwidth}px"

  # Clear two exif fields from original
  exiftool -artist= $1
  exiftool -ImageDescription= $1
  # Make a copy
  cp $1 ${_fileprefix}$1
  # Resize down
  magick convert ${_fileprefix}$1 -resize ${_newwidth}x ${_fileprefix}${_arg1filename}${_newwidthsuffix}.${_arg1extension}
  # Run imageoptim
  imageoptim ${_fileprefix}$1
  imageoptim ${_fileprefix}${_arg1filename}${_newwidthsuffix}.${_arg1extension}
  #Set exif
  exiftool -artist="Abiomed Japan" -ImageDescription="Abiomed Japan Professional Education video screenshot processed by eSolia." ${_fileprefix}$1
  exiftool -artist="Abiomed Japan" -ImageDescription="Abiomed Japan Professional Education video newsletter thumbnail processed by eSolia." ${_fileprefix}${_arg1filename}${_newwidthsuffix}.${_arg1extension}
  rm -rf *.jpg_original

  echo $1
  echo ${_arg1filename}
  echo ${_arg1extension}
  echo ${_fileprefix}
  echo ${_newwidthsuffix}

  echo "Doing scp to assets. Enter the password for abmd at webfaction when prompted..."
  scp ${_fileprefix}$1 abmd@abmd.webfactional.com:/home/abmd/webapps/ab_assets/profed
  scp ${_fileprefix}${_arg1filename}${_newwidthsuffix}.${_arg1extension} abmd@abmd.webfactional.com:/home/abmd/webapps/ab_assets/profed
}

function lsabassets (){
  echo "Use the webfaction abmd password and view what the file names look like"
  ssh abmd@abmd.webfactional.com ls "webapps/ab_assets/profed/"
}

function 16-colors (){
  # This program is free software. It comes without any warranty, to
  # the extent permitted by applicable law. You can redistribute it
  # and/or modify it under the terms of the Do What The Fuck You Want
  # To Public License, Version 2, as published by Sam Hocevar. See
  # http://sam.zoy.org/wtfpl/COPYING for more details.
  #Background
  for clbg in {40..47} {100..107} 49 ; do
  #Foreground
  for clfg in {30..37} {90..97} 39 ; do
  #Formatting
  for attr in 0 1 2 4 5 7 ; do
  #Print the result
  echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
  done
  echo #Newline
  done
  done
}

function 256-colors (){
  # This program is free software. It comes without any warranty, to
  # the extent permitted by applicable law. You can redistribute it
  # and/or modify it under the terms of the Do What The Fuck You Want
  # To Public License, Version 2, as published by Sam Hocevar. See
  # http://sam.zoy.org/wtfpl/COPYING for more details.
  for fgbg in 38 48 ; do # Foreground / Background
  for color in {0..255} ; do # Colors
  # Display the color
  printf "\e[${fgbg};5;%sm  %3s  \e[0m" $color $color
  # Display 6 colors per lines
  if [ $((($color + 1) % 6)) == 4 ] ; then
  echo # New line
  fi
  done
  echo # New line
  done
}

function tput-colors (){
  # tput_colors - Demonstrate color combinations.
  for fg_color in {0..7}; do
  set_foreground=$(tput setaf $fg_color)
  for bg_color in {0..7}; do
  set_background=$(tput setab $bg_color)
  echo -n $set_background$set_foreground
  printf ' F:%s B:%s ' $fg_color $bg_color
  done
  echo $(tput sgr0)
  done
}

# print S3 bucket size and count
# usage: bsize <bucket> [profile]
function bsize() (
  bucket=$1 profile=${2-default}

  if [[ -z "$bucket" ]]; then
  echo >&2 "bsize <bucket> [profile]"
  return 1
  fi

  # ensure aws/jq/numfmt are installed
  for bin in aws jq gnumfmt; do
  if ! hash $bin 2> /dev/null; then
  echo >&2 "Please install \"$_\" first!"
  return 1
  fi
  done

  # get bucket region
  region=$(aws --profile $profile s3api get-bucket-location --bucket $bucket 2> /dev/null | jq -r '.LocationConstraint // "us-east-1"')
  if [[ -z "$region" ]]; then
  echo >&2 "Invalid bucket/profile name!"
  return 1
  fi

  # get storage class (assumes
    # all objects in same class)
    sclass=$(aws --profile $profile s3api list-objects --bucket $bucket --max-items=1 2> /dev/null | jq -r '.Contents[].StorageClass // "STANDARD"')
    case $sclass in
    REDUCED_REDUNDANCY) sclass="ReducedRedundancyStorage" ;;
    GLACIER)            sclass="GlacierStorage" ;;
    DEEP_ARCHIVE)       sclass="DeepArchiveStorage" ;;
    *)                  sclass="StandardStorage" ;;
    esac

    # _bsize <metric> <stype>
    _bsize() {
      metric=$1 stype=$2
      utnow=$(date +%s)
      aws --profile $profile cloudwatch get-metric-statistics --namespace AWS/S3 --start-time "$(echo "$utnow - 604800" | bc)" --end-time "$utnow" --period 604800 --statistics Average --region $region --metric-name $metric --dimensions Name=BucketName,Value="$bucket" Name=StorageType,Value="$stype" 2> /dev/null | jq -r '.Datapoints[].Average'
    }

    # _print <number> <units> <format> [suffix]
    _print() {
      number=$1 units=$2 format=$3 suffix=$4
      if [[ -n "$number" ]]; then
      numfmt --to="$units" --suffix="$suffix" --format="$format" $number | sed -En 's/([^0-9]+)$/ \1/p'
      fi
    }
    _print "$(_bsize BucketSizeBytes $sclass)" iec-i "%10.2f" B
    _print "$(_bsize NumberOfObjects AllStorageTypes)" si "%8.2f"
  )

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/rcogley/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/rcogley/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/rcogley/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/rcogley/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
export DVM_DIR="/Users/rcogley/.dvm"
export PATH="$DVM_DIR/bin:$PATH"


# Add to ~/.zshrc or ~/.bashrc
alias changelog-since='f(){ git log ${1:-HEAD}..HEAD --pretty=format:"- %s (%h)" | pbcopy; }; f'
alias release-dates='git tag -l --sort=-version:refname --format="%(refname:short) - %(creatordate:short)" | pbcopy'

export PATH="$HOME/.claude/local:$PATH"
