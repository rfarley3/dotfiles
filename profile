function ps1_git () {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1]/"
}
GITB="\$(ps1_git)";
function ps1_virtualenv() {
    # Get Virtual Env
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # Strip out the path and just leave the env name
        venv="${VIRTUAL_ENV##*/}"
    else
        # In case you don't have one activated
        venv=''
    fi
    [[ -n "$venv" ]] && echo "($venv)"
}
VENV="\$(ps1_virtualenv)";
function EXT_COLOR () { echo -ne "\e[38;5;$1m"; }
function CLOSE_COLOR () { echo -ne '\e[m'; }
export PS1="\[`EXT_COLOR 132`\]\t\[`CLOSE_COLOR`\]:\[`EXT_COLOR 174`\]\w\[`CLOSE_COLOR`\]\[`EXT_COLOR 189`\]${VENV}\[`CLOSE_COLOR`\]\[`EXT_COLOR 215`\]${GITB}\[`CLOSE_COLOR`\]\n\[`EXT_COLOR 187`\]\u@\h\[`CLOSE_COLOR`\]\$ "
export CLICOLOR=1 # same as alia ls=ls -G
export GREP_OPTIONS='--color=auto'
# printf '\e[0;31mplain\n\e[1;31mbold\n\e[0;91mhighlight\n\e[1;91mbold+highlight\n\e[0m'
# OSX does LSCOLORS as a 22 char string
# (11 2 char codes, in fb: e.g. 1st is foreground, 2nd is background)
# capital letters mean bold of that color
export LSCOLORS=Exfxcxdxbxegedabagacad
# fb foreground, background
# OSX          Linux fg bg
# a     black        ?  40
# b     red          31 41
# c     green        32 42
# d     brown        ?  ?
# e     blue         34 44
# f     magenta      35 45
# g     cyan         36 46
# h     light grey   37 47
# x     default      0 
# Order OSX:Name             OSX:Code  Colors     Linux:Name  Linux:Code
# 1.        directory            Ex    bold blue        di          1;34
# 2.        symbolic link        fx    magenta          ln          35
# 3.        socket               cx    green            so          32
# 4.        pipe                 dx    brown            pi          (blue on light grey) 34;47
# 5.        executable           bx    red              ex          31
# 6.        block special        eg    blue on cyan     bd          34;46
# 7.        char special         ed    blue on brown    cd          34;47 (orange bg)
# 8.        +x with setuid       ab    black on red   
# 9.        +x with setgid       ag    black on cyan
# 10.       dir o+w, sticky      ac    black on green
# 11.       dir o+w, wo sticky   ad    black on brown
#           orphaned symlink                            or          35;41
#           file                                        fi          0
#           nonexistant but linked to                   mi          35;43
# Linux colors
# 1   = bold
# 4   = underlined
# 5   = flashing text
# 7   = reverse field
# 33  = orange
# 43  = orange background
# 90  = dark grey
# 91  = light red
# 92  = light green
# 93  = yellow
# 94  = light blue
# 95  = light purple
# 96  = turquoise
# 100 = dark grey background
# 101 = light red background
# 102 = light green background
# 103 = yellow background
# 104 = light blue background
# 105 = light purple background
# 106 = turquoise background
# can make LS_COLORS for GNU utilities
export TREE_COLORS='di=1;34:ln=35:so=32:pi=34;47:ex=31:bd=34;46:cd=34;47:or=35;41:mi=35;43'

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
    export NO_PROXY=localhost,*.mitre.org,mitre.org,*.local,127.0.0.1,128.29.0.0/8,129.83.0.0/8,10.240.0.0/8,10.84.0.0/8
    export no_proxy=${NO_PROXY}
    # Use: e.g.; java $JAVA_PROXY ...
    export JAVA_PROXY=$(tr -s ' ' <<EOF
      -Dhttp.proxyHost=${host} \
      -Dhttps.proxyHost=${host} \
      -Dhttp.proxyPort=${port} \
      -Dhttps.proxyPort=${port} \
      -Dhttp.nonProxyHosts=127.0.0.1|*.mitre.org|128.29.*|129.83.*|10.240.*|10.84.*
EOF
           )
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
complete -F _proxy proxy
# MITRE_PROXY_NAME="gatekeeper-w.mitre.org"
# MITRE_PROXY_PORT="80"
# MITRE_PROXY=${MITRE_PROXY_NAME}:${MITRE_PROXY_PORT}
# proxy=${MITRE_PROXY}
# export proxy
# http_proxy=http://${proxy}
# export http_proxy
# https_proxy=https://${proxy}
# export https_proxy
# ftp_proxy=ftp://${proxy}
# export ftp_proxy
# socks_proxy=socks://${proxy}
# export socks_proxy
# no_proxy="localhost,127.0.0.1"
# export no_proxy

# bc I mistype; bc lazy
alias cd..='cd ..'
alias gti='git'
alias ls='ls -G'
alias ll='ls -al'
alias vi='vim'
alias unp='unp -U'

alias rot13="tr '[A-Za-z]' '[N-ZA-Mn-za-m]'"
alias rot1="tr '[a-zA-Z]' '[b-zA-Za]'"
alias rotun1="tr '[b-zA-Za]' '[a-zA-Z]'"
# only works for targz (use j for bzips)
alias lstar='tar tzvf'
# this is a less-esque file viewer, but uses vim syntax highlighting, line numbering, and regex searches
# <space>: forward 1 pg; 'b': back 1 page; 'n': search forward; 'N': search backwards. Searches require '/' and regex to be entered
#alias lss=/usr/share/vim/vim73/macros/less.sh
# or copied locally (get the .sh and .vim)
alias lss='~/bin/less.sh'
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


#BREW_PREFIX=$(brew --prefix)
BREW_PREFIX=/opt/homebrew
if [ -f ${BREW_PREFIX}/etc/bash_completion ]; then
	. ${BREW_PREFIX}/etc/bash_completion
fi
# https://github.com/underself/fabric-completion is what I used, but also consider http://danilodellaquila.com/blog/how-to-add-bash-completion-to-fabric
# git completion from git distro
# makec (make color wrapper) completion created
# put each completion.bash into ${BREW_PREFIX}/etc/bash_completion.d/.

# python virtual_envs
export VIRTUAL_ENV_DISABLE_PROMPT=1
export WORKON_HOME="~/.pyvirtualenvs"
source /usr/local/bin/virtualenvwrapper.sh

venv_opts="virtuoso cedar attack sancho mcpi gmu"
function venv {
    if (( $# == 0 )); then
        echo "usage: $FUNCNAME [${venv_opts}]"
        return
    fi
	case "$1" in
		virtuoso|cedar)
            command -v deactivate > /dev/null 2>&1 && deactivate
			cd ~/Documents/CEDAR/virtuoso
			workon cedarcat
			;;
		sancho|attack)
            command -v deactivate > /dev/null 2>&1 && deactivate
			cd ~/Documents/ATT\&CK/sanchopanza
			workon sancho
			;;
		mcpi)
            command -v deactivate > /dev/null 2>&1 && deactivate
			cd ~/Documents/mcpi-challenges/mcpi-challenges
			workon mcpi
			;;
		gmu)
            command -v deactivate > /dev/null 2>&1 && deactivate
			cd ~/Desktop/GMU\ ISA564
			;;
		*)
			echo $"Unknown parameter $1"
	esac
}
function _venv() 
{
    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${venv_opts}" -- ${cur}) )
        return 0
    fi
}
complete -F _venv venv
# ~/bin       homemade scripts, etc, takes priority
# /opt/local  (bin|sbin) macports
# /usr/local  homebrew, and some other installers (usually from dmg, like python) default
# /usr/homebrew/bin homebrew, custom locally
PATH="~/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/opt/usrlocal/bin:/Library/Frameworks/Python.framework/Versions/3.4/bin:$PATH"
export PATH
export ANSIBLE_COW_SELECTION=random

