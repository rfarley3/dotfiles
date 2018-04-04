#!/usr/bin/env bash

GIT_DIR="GitRepos"

function proxy {
# You'll need to edit /etc/sudoers:
# Defaults	env_keep += "http_proxy HTTP_PROXY https_proxy HTTPS_PROXY ftp_proxy FTP_PROXY socks_proxy SOCKS_PROXY JAVA_OPTS”
# if copy paste is bad, boot into single user (cmd+s), mount / as rw (mount -o update /)
server='http://gatekeeper-w.mitre.org:80'
export http_proxy=$server
export https_proxy=$server
export HTTP_PROXY=$server
export HTTPS_PROXY=$server
}

function preinstall {
cp zshrc ~/.zshrc
cp vimrc ~/.vimrc
cp gitconfig ~/.gitconfig
# If you need to inject certs for a proxy
mkdir -p ~/.vagrant.d
cp Vagrantfile ~/.vagrant.d/.
# If you need insecure dl bc proxy
cp curlrc ~/.curlrc
mkdir -p ~/${GIT_DIR}

proxy()
# You need commandline tools installed before you can use git
# You need your ssh keys installed before you do a git clone
sudo xcode-select --install
}

function inst_zsh {
brew install zsh zsh-completions
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
brew install zsh-syntax-highlighting
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# TODO switch to https download
(cd ~/${GIT_DIR} && git clone git@github.com:powerline/fonts.git && cd fonts && sudo ./install.sh)
echo "You will need to set the font in your terminal to 'Ubuntu Mono derivative Powerline'"
mkdir -p ~/.oh-my-zsh/custom/themes
cp agnosterjf.zsh-theme ~/.oh-my-zsh/custom/themes/.
}

function act_brew {
# These variables should match your .zshrc or .profile
# OS X upgrades are not optimized for lots of files in /usr/local, but ok with /opt
PATH_OLD=$PATH
BREW_PREFIX_OLD=$BREW_PREFIX
PKG_CONFIG_PATH_OLD=$PKG_CONFIG_PATH
export PATH="$BREW_PREFIX/bin:$BREW_PREFIX/sbin:$PATH"
export BREW_PREFIX=/opt/homebrew
export PKG_CONFIG_PATH=$BREW_PREFIX/Cellar/libffi/3.0.13/lib/pkgconfig/
}
function deact_brew {
export PATH=$PATH_OLD
export BREW_PREFIX=$BREW_PREFIX_OLD
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH_OLD
}
function inst_brew {
sudo mkdir -p $BREW_PREFIX
sudo chown -R ${USER}:admin $BREW_PREFIX
chmod -R g+w $BREW_PREFIX
# The default install ignores BREW_PREFIX; force change with sed: resolve variable in bash, so ruby can have a literal
sed_str="s,/usr/local,${BREW_PREFIX},g"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install | sed -E $sed_str)"
brew update
}

function inst_vim {
brew install vim
mkdir -p ~/.vim/bundle
(cd ~/.vim/bundle && git clone git@github.com:vim-scripts/textutil.vim.git textutil)
(cd ~/.vim/bundle && git clone git@github.com:plasticboy/vim-markdown.git vim-markdown)
(cd ~/.vim/bundle && git clone git@github.com:jnurmine/Zenburn.git zenburn)
(cd ~/.vim/bundle && git clone git@github.com:airblade/vim-gitgutter.git gitgutter)
(cd ~/.vim/bundle && git clone git@github.com:tpope/vim-fugitive.git fugitive)
(cd ~/.vim/bundle && git clone git@github.com:scrooloose/nerdtree.git nerdtree)
# https://powerline.readthedocs.io/en/latest/usage/other.html#vim-statusline
pip3 install --user powerline-status
}

function inst_common {
brew install bash-completion dos2unix git tmux trash tree watch wget
# echo 'export PATH="/opt/homebrew/opt/gettext/bin:$PATH"' >> ~/.zshrc
# LDFLAGS:  -L/opt/homebrew/opt/gettext/lib
# CPPFLAGS: -I/opt/homebrew/opt/gettext/include
# vim requires Python.h
brew install python python@2
# you may need to chown -R ${USER}:admin && chmod -R g+w $BREW_PREFIX/...sitepackages
# Brew installs pip, but for system: curl https://bootstrap.pypa.io/get-pip.py | python
brew install p7zip unp
# brew install hexedit libmagic ssdeep yara
# brew install qemu wine
# for vim pdf reading
# brew install xpdf
}

# If you want to install any virtenv, set the workon home beforehand
# export WORKON_HOME="~/.pyvirtualenvs"
# export VIRTUAL_ENV_DISABLE_PROMPT=1
echo "Did you set zshrc default username, proxy, virtualenv home/prompt correctly?"
echo "Did you set gitconfig default remote and username correctly?"
echo "Did you install your ssh keys for github?"
echo "If so, edit this script and remove the call to preinstall above and the exit below this echo"
#exit 1

set -x
set -e

#preinstall()
#act_brew()
#inst_brew()
#inst_zsh()
#deact_brew()
# Load the updated proxy info, PATH, and BREW_PREFIX
#source .zshrc
#inst_common()
#inst_vim()

function inst_certs {
# Not sure if this is necessary
# If pip fails, then restart terminal and try it manually
curl http://pki.mitre.org/MITRE-chain.txt >> MITRE-chain.txt
cat MITRE-chain.txt >> /opt/homebrew/etc/openssl/cert.pem
# After you install VirtualBox and Vagrant, you'll need to add certs for Vagrant/Ruby
curl http://pki.mitre.org/MITRE%20BA%20Root.crt | sudo tee -a /opt/vagrant/embedded/cacert.pem > /dev/null
curl http://pki.mitre.org/MITRE%20BA%20NPE%20CA-1.crt | sudo tee -a /opt/vagrant/embedded/cacert.pem > /dev/null
curl http://pki.mitre.org/MITRE%20BA%20NPE%20CA-3.crt | sudo tee -a /opt/vagrant/embedded/cacert.pem > /dev/null
vagrant plugin install --plugin-source http://rubygems.org vagrant-proxyconf
vagrant plugin install vagrant-ca-certificates
}

inst_certs()
pip install --upgrade pip setuptools
# we need virtualenvwrapper for the .zshrc file
pip install virtualenvwrapper


