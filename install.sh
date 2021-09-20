#!/bin/bash
echo "Change to Home Folder"
cd $HOME
echo "Clone Dotfiles"
git clone https://github.com/RickCogley/dotfiles.git .dotfiles
echo "Change to Dotfiles"
cd .dotfiles
echo "Install via stow"
stow zsh
stow vim
stow git
echo "Change to home then confirm"
cd
ls -la
