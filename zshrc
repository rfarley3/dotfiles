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
fpath=($BREW_PREFIX/share/zsh-completions $fpath)
export PATH="/Users/$DEFAULT_USER/bin:$BREW_PREFIX/bin:$BREW_PREFIX/sbin:/opt/usrlocal/bin:/Library/Frameworks/Python.framework/Versions/3.4/bin:$PATH"
export WORKON_HOME="~/.pyvirtualenvs"
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PKG_CONFIG_PATH=$BREW_PREFIX/Cellar/libffi/3.0.13/lib/pkgconfig/
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
alias ls='ls -G'
alias ll='ls -al'
alias vi='vim'
alias unp='unp -U'
# only works for targz (use j for bzips)
alias lstar='tar tzvf'

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


proxy () { # consistently set proxy environment values
    local host port
    case "$1" in
        (default|gatekeeper-w|-)
            host='gatekeeper-w.mitre.org'
            port='80'
            ;;
        (gatekeeper)
            host='gatekeeper.mitre.org'
            port='80'
            ;;
        (alternate)  # via INFOSEC-list during proxy testing 2015/03/19
            host='proxyw2.mitre.org'
            port='80'
            ;;
        (clear|--)
            unset HTTP_PROXY http_proxy HTTPS_PROXY https_proxy NO_PROXY no_proxy
            unset ALL_PROXY all_proxy FTP_PROXY ftp_proxy RSYNC_PROXY JAVA_PROXY
            return
            ;;
        (*)
            cat <<-EOF
Recognized proxys: default, -, gatekeeper{,-w}, alternate, clear, --

Normal usage:
 proxy -     # sets up defaut proxy environment variables
 proxy clear # unset all proxy environmemt variables, e.g., if on OuterNet
 proxy       # display this help and current *proxy* environment variables.

EOF
            echo "current settings:"
            env | grep -i proxy | sort -f
            return
            ;;
    esac
    # Various combos I've come across; sometimes case matters
    export http_proxy="http://${host}:${port}/"
    export HTTP_PROXY=${http_proxy} 
    export HTTPS_PROXY=${http_proxy} https_proxy=${http_proxy}
    export FTP_PROXY=${http_proxy} ftp_proxy=${http_proxy}
    export SOCKS_PROXY=${http_proxy} socks_proxy=${http_proxy} 
    export ALL_PROXY=${http_proxy} all_proxy=${http_proxy}
    export RSYNC_PROXY="${host}:${port}"
    # NO_PROXY - some docs say just domain names (wget) others (Firefox) include IP ranges
    export NO_PROXY="localhost,*.mitre.org,mitre.org,*.local,127.0.0.1,128.29.0.0/8,129.83.0.0/8,10.240.0.0/8,10.84.0.0/8"
    export no_proxy=${NO_PROXY}
    # Use: e.g.; java $JAVA_PROXY ...
    export JAVA_PROXY=<<EOF
      -Dhttp.proxyHost=${host} \
      -Dhttps.proxyHost=${host} \
      -Dhttp.proxyPort=${port} \
      -Dhttps.proxyPort=${port} \
      -Dhttp.nonProxyHosts=127.0.0.1|*.mitre.org|128.29.*|129.83.*|10.240.*|10.84.*
EOF
}
proxy default
proxyfn_opts="default gatekeeper gatekeeper-w - alternate clear --"
function _proxy() 
{
    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${proxyfn_opts}" -- ${cur}) )
        return 0
    fi
}
# complete -F _proxy proxy

# This is a less-esque file viewer, but uses vim syntax highlighting, line numbering, and regex searches
# bc it is vim, if the file is a directory, then you get a directory list
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
#alias lss=/usr/share/vim/vim73/macros/less.sh
# or copied locally (get the .sh and .vim)
# alias lss='~/bin/less.sh'

source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

