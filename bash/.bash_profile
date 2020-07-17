[[ "$(command -v brew)" ]] && source $(brew --prefix)/etc/bash_completion
# if [ -f $(brew --prefix)/etc/bash_completion ]; then
#     . $(brew --prefix)/etc/bash_completion
# fi

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
