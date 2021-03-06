# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# set mode
# set -o vi

# exports
export TERM=xterm-256color
export EDITOR=vim
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# If exist proxy for you environment,
# need to create ~/.bash_config/.bash_proxys file.
if [ -f ~/.bash_proxys ]; then
    . ~/.bash_proxys
fi

# Definition for git prompt variables and export git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto
GIT_PS1_SHOWCOLORHINTS=true

if [ -f ~/.bash_config/git-prompt.sh ]; then
    . ~/.bash_config/git-prompt.sh
fi


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

RCol="\e[0m"

Red="\e[0;31m"
Gre="\e[0;32m"
BYel='\[\e[1;33m\]'
BBlu='\[\e[1;34m\]'
Pur='\[\e[0;35m\]'

if [ "$color_prompt" = yes ]; then
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    # PS1='\[\e[0;31m\]\u\[\e[0;1m\]@\[\e[0;33m\]\h \[\033[01;36m\]\W\[\033[01;32m\]$(__git_ps1) \[\033[01;35m\]>\[\033[00m\] '
#     PS1='┌─[\[\033[01;36m\]\W\[\e[00m\]][\[\e[38;05;190m\]\h\[\e[0m\]]$(__git_ps1 "[\[\e[38;05;82m\]%s\[\033[00m\]]")
# └─\[\033[38;5;208m\]>\[\033[00m\] '
#     PS1='┌─[\[\e[38;05;227m\]\W\[\e[00m\]][\[\e[38;05;147m\]\h\[\e[0m\]]$(__git_ps1 "[\[\e[38;05;214m\]%s\[\033[00m\]]")
# └─\[\033[38;5;71m\]>\[\033[00m\] ' # colorscheme jellybeans style

    export PS1=' [\[\e[38;05;227m\]\W\[\e[00m\]][\[\e[38;05;147m\]\h\[\e[0m\]]$(__git_ps1 "[\[\e[38;05;214m\]%s\[\033[00m\]]") \[\033[38;5;71m\]>\[\033[00m\] '

function __command_rprompt() {
    local rprompt=$(if [ $? == 0 ]; then echo -e ""; else echo -e "${Red}[`echo $?`]✘ ${RCol}"; fi)
    local num=$(($COLUMNS - ${#rprompt} - 2))
    printf "%${num}s$rprompt\r" ''
}

PROMPT_COMMAND=__command_rprompt

else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_config/.bash_aliases ]; then
    source ~/.bash_config/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).

if [ -f ~/.bash_config/.bash_complete ]; then
    . ~/.bash_config/.bash_complete
fi

#function _update_ps1() {
#      PS1=$(powerline-shell $?)
#}
#
#if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
#  PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
#fi

# enable fzf setting
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Ctrl+w command separator
stty werase undef
bind '"\C-w": unix-filename-rubout'

# Key bind
#{{{
bind '"\C-n": history-search-forward'
bind '"\C-p": history-search-backward'
# 上矢印キー
bind '"\e[A": history-search-backward'
# 下矢印キー
bind '"\e[B": history-search-forward'
# }}}
