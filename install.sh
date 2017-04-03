#!/usr/bin/env bash

echo "Did you set the proxy correctly?"
# this includes /etc/sudoers:
# Defaults	env_keep += "http_proxy HTTP_PROXY https_proxy HTTPS_PROXY ftp_proxy FTP_PROXY socks_proxy SOCKS_PROXY JAVA_OPTS”

set -x
set -e

sudo xcode-select --install
sudo pip install --upgrade pip
sudo pip install virtualenv
sudo pip install virtualenvwrapper
# If you want to install any virtenv, set the workon home beforehand
# export WORKON_HOME="~/.pyvirtualenvs"
# export VIRTUAL_ENV_DISABLE_PROMPT=1

# OS X upgrades are not optimized for lots of files in /usr/local, but ok with /opt
sudo mkdir -p /opt/homebrew
sudo chown -R rfarley:admin /opt/homebrew
chmod -R 775 /opt/homebrew
export BREW_PREFIX=/opt/homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew install bash-completion dos2unix git tmux trash tree vim watch wget
brew install p7zip unp
# brew install hexedit libmagic ssdeep yara
# brew install qemu wine

brew install zsh zsh-completions
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
brew install zsh-syntax-highlighting

mkdir -p ~/.vim/bundle
(cd ~/.vim/bundle && git clone git@github.com:vim-scripts/textutil.vim.git)
(cd ~/.vim/bundle && git clone git@github.com:plasticboy/vim-markdown.git)

# OS X upgrades are not optimized for lots of files in /usr/local, but ok with /opt
# OS X will enumerate each file individually in /usr/local, but does a dir cp in /opt 
# sudo mkdir /opt/usrlocal
# sudo chown -R rfarley:admin /opt/usrlocal
# chmod -R 775 /opt/usrlocal
# mkdir /opt/usrlocal/bin
# mkdir /opt/usrlocal/src

sudo pip install --upgrade ansible
./copy-files.sh

