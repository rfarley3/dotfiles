#!/usr/bin/env bash

cp zshrc ~/.zshrc

cp vimrc ~/.vimrc

cp gitconfig ~/.gitconfig

# If you need to inject certs for a proxy
mkdir -p ~/.vagrant.d
cp Vagrantfile ~/.vagrant.d/.

# If you need insecure dl bc proxy
cp curlrc ~/.curlrc

mkdir -p ~/Github
(cd ~/Github && git clone git@github.com:powerline/fonts.git && cd powerline && sudo ./install.sh)
echo "You will need to set the font in your terminal to 'Ubuntu Mono derivative Powerline'"
mkdir -p ~/.oh-my-zsh/custom/themes
cp agnosterjf.zsh-theme ~/.oh-my-zsh/custom/themes/.

