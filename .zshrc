#
# /etc/zshrc is sourced in interactive shells.  It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#

## shell functions
#setenv() { export $1=$2 }  # csh compatibility

autoload -Uz colors
colors

## keybind
bindkey -v             # vi key bindings
# bindkey -e             # emacs key bindings
# bindkey ' ' magic-space  # also do history expansion on space
# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# Separate String
# autoload -Uz select-word-style
# select-word-style default

# WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
# zstyle ':zle:*' word-chars " /=;@:{},|"
# zstyle ':zle:*' word-style unspecified

my-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^W' my-backward-delete-word

########################################
# Complete
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit
compinit
zstyle ':completion:*:default' menu select=1

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

########################################
# Git

function rprompt-git-current-branch {
  local branch_name st branch_status

  if [ ! -e  ".git" ]; then
    # gitで管理されていないディレクトリは何も返さない
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # 全てcommitされてクリーンな状態
    branch_status="%F{green}"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # gitに管理されていないファイルがある状態
    branch_status="%F{red}?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # git addされていないファイルがある状態
    branch_status="%F{red}+"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # git commitされていないファイルがある状態
    branch_status="%F{yellow}!"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # コンフリクトが起こった状態
    echo "%F{red}!(no branch)"
    return
  else
    # 上記以外の状態の場合は青色で表示させる
    branch_status="%F{green}"
  fi
  # ブランチ名を色付きで表示する
  echo "${branch_status}$branch_name "
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst


########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# '#' 以降をコメントとして扱う
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

# # C で標準出力をクリップボードにコピーする
# # mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
# if which pbcopy >/dev/null 2>&1 ; then
#     # Mac
#     alias -g C='| pbcopy'
# elif which xsel >/dev/null 2>&1 ; then
#     # Linux
#     alias -g C='| xsel --input --clipboard'
# elif which putclip >/dev/null 2>&1 ; then
#     # Cygwin
#     alias -g C='| putclip'
# fi

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
zstyle ':vcs_info:git:*' stagedstr " %F{000}+"
zstyle ':vcs_info:git:*' unstagedstr " %F{000}*"
zstyle ':vcs_info:*' formats " %F{000}%b%c%u%f "
zstyle ':vcs_info:*' actionformats ' %b|%a '
precmd () { vcs_info }

# Set prompts
# PROMPT='[%n@%m]%~%# '    # default prompt
# PROMPT='%F{009}%n%f%F{015}@%f%F{003}%m%f %F{044}%~ ${vcs_info_msg_0_}%B%(?,%F{002},%F{009})%(!,#,>)%f%b '
PROMPT='%F{208}%K{238}%n@%m %k%f%K{081}%F{238} %f%F{000}%~ %k%K{208}%F{081}%f${vcs_info_msg_0_}%k%F{208}%f '
RPROMPT='%f%B%(?,,%F{009}✘)%f%b'
# PROMPT="%{${bg[039]%}%}%{${fg[black]}%} %n %{${bg[white]}%}%{${fg[blue]}%} %{${bg[white]}%}%{${fg[black]}%} %~ %{${reset_color}%}%{${fg[white]}%}  %{${reset_color}%}"
# RPROMPT=' %~'     # prompt for right side of screen
# PROMPT='%F{red}%n%F{white}@%F{yellow}%m %F{cyan}%~ `rprompt-git-current-branch`%F{white}%# '    # default prompt
# PROMPT="%{${bg[white]}%}%{${fg[black]}%}%~ %{${reset_color}%}%{${fg[white]}%}  %{${reset_color}%}"
# PROMPT="%{${bg[blue]%}%}%{${fg[black]}%} %n %{${bg[white]}%}%{${fg[blue]}%} %{${bg[white]}%}%{${fg[black]}%} %~ %{${reset_color}%}%{${fg[white]}%}  %{${reset_color}%}"
# PROMPT="%K{green}%F{white} %~ %k%f%F{green}%K{blue}%k%f%F{white}%K{blue} ${vcs_info_msg_0_} %k%f%F{blue}%K{black} %f"
# RPROMPT=' %~'     # prompt for right side of screen
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
