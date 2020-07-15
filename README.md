# Rick Cogley's dotfiles

I've been trying various methods to manage my dotfiles and get them onto systems, but, it turns out that the easiest thing is to just use Gnu `stow`, with some shell scripts for non-dotfile system setup. There is a good reason to use something like [Homemaker](https://github.com/FooSoft/homemaker), written in Go, because it has no dependencies so you don't need elevated privileges to install it on any given system, and it can handle configuration, not just your dotfile linking. That said, for me it is not such a challenge so far, to install `git` and `stow` on any server I'm managing. If those are not present and I really need my dotfiles on a system, there's always `rsync`. Once they are linked in, just run a couple of scripts to install what you need. 

Here's what I do on a new system assuming `git` and `stow` are installed: 

~~~~~
% cd $HOME
% git clone https://github.com/RickCogley/dotfiles.git .dotfiles
% cd .dotfiles
% stow zsh
% stow vim
% cd
% ls -la #confirm .zshrc, .vimrc etc
~~~~~

The `stow zsh` for instance, just finds the folder `zsh`, and creates symbolic links to its contents in the _parent_ folder, even respecting subfolders. Because your dotfiles repo has been cloned into `$HOME/.dotfiles`, the symbolic links get created in your user folder, so everything just works as expected. Then you just edit and do your git operations on the files in `~/.dotfiles`, and the links will of course just reference those. 

Additionally, I'm now using the excellent «[zsh for humans](https://github.com/romkatv/zsh4humans)» mainly for its ability to copy zsh and other config files (a v3 feature) up to a remote server just by doing `z4h ssh me@theserver.com`. Smart! Especially if you're mostly only ssh-ing to the server anyway. It also has "sane defaults" so, it's easy to get started with for beginners, though I've been using `zsh` for quite some time. 



