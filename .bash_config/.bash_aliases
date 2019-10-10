# ==========================================
# Basic command aliases
# ==========================================
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ==========================================
# Extend command aliases
# ==========================================
# directory move
# alias ..2="../.."
# alias ..3="../../.."

# ==========================================
# Git command aliases
# ==========================================
function git-root() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    cd `pwd`/`git rev-parse --show-cdup`
  fi
}

# ==========================================
# vim aliases
# ==========================================
alias vi="vim"
alias nv="nvim"
alias vimd="vimdiff"

# ==========================================
# kubernetes aliases
# ==========================================
alias kc="kubectl"
