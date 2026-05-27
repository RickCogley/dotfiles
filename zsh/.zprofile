# .zprofile is sourced by both login and interactive shells

path=(/usr/local/bin $path) #For nova to find npm in LOGIN SHELL

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
