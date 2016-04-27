# dotfiles
Rick Cogley's dotfiles, in the future managed by [Homemaker](https://github.com/FooSoft/homemaker).
Now, managed manually after ``git clone`` to ``~/dev/``: 

```bash
# In ~
~/.vim -> dev/dotfiles/nvim
~/.vimrc -> dev/dotfiles/nvim/init.vim
~/.zlogin -> dev/dotfiles/zsh/zlogin
~/.zlogout -> dev/dotfiles/zsh/zlogout
~/.zpreztorc -> dev/dotfiles/zsh/zpreztorc
~/.zprofile -> dev/dotfiles/zsh/zprofile
~/.zshenv -> dev/dotfiles/zsh/zshenv
~/.zshrc -> dev/dotfiles/zsh/zshrc
~/.config/nvim/init.vim -> dev/dotfiles/nvim/init.vim
~/.tmux.conf -> dev/dotfiles/tmux/tmux.conf 
~/.config/tmux/tmux-status.conf -> dev/dotfiles/tmux/tmux-status.conf
```

## Introduction

Homemaker is a lightweight, make-like utility written in golang by [Alex Yatskov](https://foosoft.net), used to manage your dotfiles, the ubiquitous configuration files present in the home folder of *nix and Mac systems (such as ``.bashrc``). The great thing about golang utilities is that they are a single binary that can simply be copied to and used on the target system, with no dependencies (_c.f._ ruby, perl). You can use homemaker to bootstrap a new system, installing packages, cloning repositories or running commands. 

See [the author's dotfiles](https://github.com/FooSoft/dotfiles) or [these](https://github.com/tdmanv/dotfiles) for examples. 

## Installing
### Get this repo

```
cd ~/dev
git clone git@github.com:rickcogley/dotfiles.git
```

### Install homemaker

If go is installed and its environment variables properly set:

```
cd ~
go get github.com/FooSoft/homemaker
homemaker
```

... or use a pre-compiled binary (a good place on mac is e.g. ``/usr/local/opt``), linking it into your path: 

```
cd /usr/local/opt
wget https://foosoft.net/projects/homemaker/dl/homemaker_darwin_amd64.tar.gz
tar xvf ./homemaker_darwin_amd64.tar.gz
cd /usr/local/bin
ln -s /usr/local/opt/homemaker_darwin_amd64/homemaker
```

Substitute ``homemaker_linux_amd64.tar.gz`` and to different paths as needed. 

### Install dotfiles via homemaker

```
cd ~/dev/dotfiles
homemaker --verbose --task=bash --variant=mac config.toml .
```

Or, other tasks and variants. The ``config.toml`` is key. 
