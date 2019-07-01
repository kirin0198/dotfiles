#
# /etc/zshrc is sourced in interactive shells.  It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#

## shell functions
#setenv() { export $1=$2 }  # csh compatibility

## keybind
bindkey -v             # vi key bindings
# bindkey -e             # emacs key bindings
# bindkey ' ' magic-space  # also do history expansion on space

autoload colors
colors

setopt histignorealldups

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' ignore-parents parent pwd ..

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

########################################
# エイリアス

alias la='ls -a'
alias ll='ls -l'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'


# Provide pathmunge for /etc/profile.d scripts
pathmunge()
{
    if ! echo $PATH | /bin/grep -qE "(^|:)$1($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH=$PATH:$1
        else
            PATH=$1:$PATH
        fi
    fi
}

_src_etc_profile_d()
{
    #  Make the *.sh things happier, and have possible ~/.zshenv options like
    # NOMATCH ignored.
    emulate -L ksh


    # from bashrc, with zsh fixes
    if [[ ! -o login ]]; then # We're not a login shell
        for i in /etc/profile.d/*.sh; do
	    if [ -r "$i" ]; then
	        . $i
	    fi
        done
        unset i
    fi
}
_src_etc_profile_d

unset -f pathmunge _src_etc_profile_d

## Git setting
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr " %F{011}+"
zstyle ':vcs_info:git:*' unstagedstr " %F{027}*"
zstyle ':vcs_info:*' formats " %F{010}%b%c%u%f "
zstyle ':vcs_info:*' actionformats ' %b|%a '
precmd () { vcs_info }

# Set prompts
# PROMPT='[%n@%m]%~%# '    # default prompt
# PROMPT='%F{009}%n%f%F{015}@%f%F{003}%m%f %F{044}%~ ${vcs_info_msg_0_}%B%(?,%F{002},%F{009})%(!,#,>)%f%b '
PROMPT='%F{232}%K{245}%n@%m %k%f%K{240}%F{245} %f%F{254}%~ %k%K{232}%F{240}%f${vcs_info_msg_0_}%k%F{232}%f '
RPROMPT='%f%B%(?,,%F{009}✘)%f%b'
# PROMPT="%{${bg[039]%}%}%{${fg[black]}%} %n %{${bg[white]}%}%{${fg[blue]}%} %{${bg[white]}%}%{${fg[black]}%} %~ %{${reset_color}%}%{${fg[white]}%}  %{${reset_color}%}"
# RPROMPT=' %~'     # prompt for right side of screen
