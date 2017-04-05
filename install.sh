#!/usr/bin/env bash

echo "Did you set the proxy correctly?"
# this includes /etc/sudoers:
# Defaults	env_keep += "http_proxy HTTP_PROXY https_proxy HTTPS_PROXY ftp_proxy FTP_PROXY socks_proxy SOCKS_PROXY JAVA_OPTS”
echo "Did you set the username in zshrc correctly?"
echo "Did you remove the proxy info if you don't need it?"
echo "Did you set the default git remote name correctly?"
echo "If so, edit this script and remove the exit below this echo"
exit 1

set -x
set -e

sudo xcode-select --install

# OS X upgrades are not optimized for lots of files in /usr/local, but ok with /opt
export BREW_PREFIX=/opt/homebrew
sudo mkdir -p $BREW_PREFIX
sudo chown -R ${USER}:admin $BREW_PREFIX
chmod -R g+w $BREW_PREFIX
# The default install ignores BREW_PREFIX; force change with sed: resolve variable in bash, so ruby can have a literal
sed_str="s,/usr/local,${BREW_PREFIX},g"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install | sed -E $sed_str)"
brew update
brew install bash-completion dos2unix git tmux trash tree watch wget

# vim requires Python.h
brew install python
# you may need to chown -R ${USER}:admin && chmod -R g+w $BREW_PREFIX/...sitepackages
pip install --upgrade pip setuptools
# we need virtualenvwrapper for the .zshrc file
pip install virtualenvwrapper
# If you want to install any virtenv, set the workon home beforehand
# export WORKON_HOME="~/.pyvirtualenvs"
# export VIRTUAL_ENV_DISABLE_PROMPT=1

brew install vim

brew install zsh zsh-completions
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
brew install zsh-syntax-highlighting

brew install p7zip unp
# brew install hexedit libmagic ssdeep yara
# brew install qemu wine
# for vim pdf reading
brew install xpdf

mkdir -p ~/.vim/bundle
(cd ~/.vim/bundle && git clone git@github.com:vim-scripts/textutil.vim.git textutil)
(cd ~/.vim/bundle && git clone git@github.com:plasticboy/vim-markdown.git vim-markdown)
(cd ~/.vim/bundle && git clone git@github.com:jnurmine/Zenburn.git zenburn)
(cd ~/.vim/bundle && git clone git@github.com:airblade/vim-gitgutter.git gitgutter)
(cd ~/.vim/bundle && git clone git@github.com:tpope/vim-fugitive.git fugitive)
(cd ~/.vim/bundle && git clone git@github.com:scrooloose/nerdtree.git nerdtree)

# OS X upgrades are not optimized for lots of files in /usr/local, but ok with /opt
# OS X will enumerate each file individually in /usr/local, but does a dir cp in /opt 
# sudo mkdir /opt/usrlocal
# sudo chown -R ${USER}:admin /opt/usrlocal
# chmod -R g+w /opt/usrlocal
# mkdir /opt/usrlocal/bin
# mkdir /opt/usrlocal/src

sudo pip install --upgrade ansible
./copy-files.sh

