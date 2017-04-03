#!/usr/bin/env bash

mkdir -p ~/.vagrant.d
cp Vagrantfile ~/.vagrant.d/.

cp curlrc ~/.curlrc

cp gitconfig ~/.gitconfig

mkdir -p ~/Github
(cd ~/Github && git clone git@github.com:powerline/fonts.git && cd powerline && sudo ./install.sh)
echo "You will need to set the font in your terminal to 'Ubuntu Mono derivative Powerline'"
mkdir -p ~/.oh-my-zsh/custom/themes
cp agnosterjf.zsh-theme ~/.oh-my-zsh/custom/themes/.

cp vimrc ~/.vimrc
mkdir -p ~/.vim/colors
cp zenburn.vim ~/.vim/colors/.

cp zshrc ~/.zshrc

