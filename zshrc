# Path to your oh-my-zsh installation.
DEFAULT_USER="rfarley"
export ZSH=/Users/${DEFAULT_USER}/.oh-my-zsh

ZSH_THEME="agnosterjf"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

plugins=(git brew fabric pip sublime vagrant virtualenvwrapper wd)

# User configuration
export BREW_PREFIX=/opt/homebrew
# if completions do not work, refresh them with:
#  rm -f ~/.zcompdump; compinit
#  chmod go-w '/opt/homebrew/share'
fpath=($BREW_PREFIX/share/zsh-completions $fpath)
export PATH="/Users/$DEFAULT_USER/bin:$BREW_PREFIX/bin:$BREW_PREFIX/sbin:$PATH"
# Use non-brew python
# export PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:$PATH"
# enable brew version of openssl
# export PATH="/opt/homebrew/opt/openssl/bin:$PATH
# For compilers to find this software you may need to set:
#    LDFLAGS:  -L/opt/homebrew/opt/openssl/lib
#    CPPFLAGS: -I/opt/homebrew/opt/openssl/include
# For pkg-config to find this software you may need to set:
#    PKG_CONFIG_PATH: /opt/homebrew/opt/openssl/lib/pkgconfig
export PKG_CONFIG_PATH=$BREW_PREFIX/Cellar/libffi/3.0.13/lib/pkgconfig/
export WORKON_HOME="~/.pyvirtualenvs"
export VIRTUAL_ENV_DISABLE_PROMPT=1
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
alias cd..='cd ..'
alias gti='git'
alias which='which -a'
alias ls='ls -G'
alias ll='ls -al'
alias vi='vim'
alias unp='unp -U'
# only works for targz (use j for bzips)
alias lstar='tar tzvf'
alias rgrep='grep -RIin'
#alias jqless 'jq -C . $1 | less -R'
alias jqless='f() { jq -C $1 $2 | less -R };f'

alias rot13="tr '[A-Za-z]' '[N-ZA-Mn-za-m]'"
alias rot1="tr '[a-zA-Z]' '[b-zA-Za]'"
alias rotun1="tr '[b-zA-Za]' '[a-zA-Z]'"

# This changes the man reader from less to vim
# That way you get all the regex/fwd/backw/highlighted/incremental searching you want
# if your vimrc has the mouse/clipboard set, then you can copy from the manpage
export MANPAGER="/bin/sh -c \"unset PAGER;col -b -x | \
    vim -R -c 'set ft=man nomod nolist nonumber noma ts=8' -c 'map q :q<CR>' \
    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

# get the info that I find most useful for both udp and tcp
alias netstat-all='netstat -f inet -unl -p udp && netstat -f inet -unl -p tcp'
alias netstat-listening='lsof -i -P | grep -i "listen"'
alias tracert='traceroute'
# simple perl script wrapper to use colors on certain words/lines in gcc output
alias makec='make-color.sh'

# http://hints.macworld.com/article.php?story=20091003083125659
# https://github.com/andreafrancia/trash-cli
# alias rm='echo "Ignoring this command. Use trash, not rm."; false'

alias locate='mdfind -name'

# alias vmls='VBoxManage list vms'
# alias vmlsrunning='VBoxManage list runningvms'
# alias vmsuspend='VBoxManage controlvm $1 savestate'
alias vmls='vagrant global-status | tail -r | tail +7 | tail -r'
alias vmlsrunning='vagrant global-status | grep --color=no "^[0-9a-f]\{7\}" | grep --color=no running'
alias vmsuspend='vagrant suspend $1'


# This is a less-esque file viewer, but uses vim syntax highlighting, line numbering, and regex searches
# bc it is vim, if the file is a directory, then you get a directory list
# Without arguments it will read from stdin (like less) so you can pipe things into it
# Cmds:
#     <space>: forward 1 pg; 'b': back 1 page;
#     'n': search forward; 'N': search backwards.
#     Searches require '/' and regex to be entered
function lss()
{
	if test -t 1; then
		# if there is no file/args, then it will read stdin
		if test $# = 0; then
			vim --cmd 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' -
		else
			# if you want ls to list dir instead of vi, add this conditional:
			# if [ -d "$1" ]; then ls $@ else
			vim --cmd 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' "$@"
		fi
	else
		# Output is not a terminal, cat arguments or stdin
		if test $# = 0; then
			cat
		else
			cat "$@"
		fi
	fi
}
# Old methods:
# alias lss=/usr/share/vim/vim73/macros/less.sh
# or copied locally (get the .sh and .vim)
# alias lss='~/bin/less.sh'

# Copyleft 2017 by Ignacio Nunez Hernanz <nacho _a_t_ ownyourbits _d_o_t_ com>
# GPL licensed (see end of file) * Use at your own risk!
#
# Usage:
#   In the middle of the command line:
#     (command being typed)<TAB>(resume typing)
#
#   At the beginning of the command line:
#     <SPACE><TAB>
#     <SPACE><SPACE><TAB>
#
# Notes:
#   This does not affect other completions
#   If you want 'cd ' or './' to be prepended, write in your .zshrc 'export TAB_LIST_FILES_PREFIX'
#   I recommend to complement this with push-line-or edit (bindkey '^q' push-line-or-edit)
function tab_list_files
{
  if [[ $#BUFFER == 0 ]]; then
    BUFFER="ls "
    CURSOR=3
    zle list-choices
    zle backward-kill-word
  elif [[ $BUFFER =~ ^[[:space:]][[:space:]].*$ ]]; then
    BUFFER="./"
    CURSOR=2
    zle list-choices
    [ -z ${TAB_LIST_FILES_PREFIX+x} ] && BUFFER="  " CURSOR=2
  elif [[ $BUFFER =~ ^[[:space:]]*$ ]]; then
    BUFFER="cd "
    CURSOR=3
    zle list-choices
    [ -z ${TAB_LIST_FILES_PREFIX+x} ] && BUFFER=" " CURSOR=1
  else
    BUFFER_=$BUFFER
    CURSOR_=$CURSOR
    zle expand-or-complete || zle expand-or-complete || {
      BUFFER="ls "
      CURSOR=3
      zle list-choices
      BUFFER=$BUFFER_
      CURSOR=$CURSOR_
    }
  fi
}
zle -N tab_list_files
bindkey '^I' tab_list_files

# uncomment the following line to prefix 'cd ' and './'
# when listing dirs and executables respectively
#export TAB_LIST_FILES_PREFIX

# these two lines are usually included by oh-my-zsh, but just in case
autoload -Uz compinit
compinit

source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Comment out if you don't need the proxy settings
source .zshrc-proxy
