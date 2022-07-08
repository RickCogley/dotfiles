VsCode's default settings file goes in: 

~~~~~
$HOME/Library/Application Support/Code/User
~~~~~

However you can open it from anywhere and VSCode will use that. 

Assuming .dotfiles is cloned, Install: 

~~~~~
% cd $HOME
% cd .dotfiles
% stow vscode
~~~~~

Then open `$HOME/.vscode/settings.json`.
