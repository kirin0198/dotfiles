#/bin/bash

##################################################################33
# Work Flow
##################################################################33
# [Preparation]
# Login to root
# Replace "ListenAddress" for /etc/ssh/sshd_config, and restart sshd
# setenforce 0
#
# if [[ ${PROXY_FLAG} -eq 1 ]]; then
#   export HTTP_PROXY=xxx
#   export HTTPS_PROXY=xxx
#   cat << EOS > /etc/profile and /etc/yum.conf
# export HTTP_PROXY=xxx
# export HTTPS_PROXY=xxx
# EOS
# fi
#
# yum update -y
#
# yum install git
# git clone https://github.com/kirin0198/dotfiles.git

# [Deploy]
# yum install -y epel-release
# yum isntall python36 python36-devel python36-libs python36-pip npm
# if [[ ${PROXY_FLAG} -eq 1 ]]; then
#   pip --proxy http://${PROXY}:${PROXY_PORT}
#   npm -g config set proxy http://${PROXY}:${PORT}
# fi
# pip3 install --upgrade pip
# sudo pip3 install neovim vim-vint pep8 pyflakes yamllint python-language-server
# npm config set python $(which python)
# npm config set python $(which python3)
# npm install --unsafe-perm -g node-inspector
# sudo npm install -g jsonlint bash-language-server
#
# mkdir ~/git && cd $_
# git clone https://github.com/vim/vim.git

# yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker vim
# yum install -y ncurses-devel gtk2-devel atk-devel libX11-devel libXt-devel gcc
# cd ~/git/vim/src
# ./configure --with-features=huge --enable-gui=gtk2 --enable-pythoninterp --with-python-config-dir=$(which python2.7-config) --enable-python3interp --with-python3-config-dir=$(/usr/bin/python3.6-config) --enable-fail-if-missing
# sudo make && sudo make install
# echo "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh" >> .bashrc or .zshrc




DIR_LIST[0]=".cache/dein"
# DIR_LIST[1]=".cache/dein/plugins"
DIR_LIST[1]=".vim/colors"
DIR_LIST[2]=".bash_config"

FILE_LIST[0]=".vimrc"
FILE_LIST[1]=".inputrc"
FILE_LIST[2]=".cache/dein/plugins/plugins.toml"
FILE_LIST[3]=".cache/dein/plugins/plugins_lazy.toml"
FILE_LIST[4]=".bash_config/git-prompt.sh"

echo "Start setup process...."

for TARGET_DIR in ${DIR_LIST[@]}; do
    if [[ -d "$HOME"/"${TARGET_DIR}" ]]; then
        echo "Already setup. Dir: ${TARGET_DIR}"
    else
        mkdir -p "$HOME"/"${TARGET_DIR}"
    fi
done

for TARGET_FILE in ${FILE_LIST[@]}; do
    if [[ -f "$HOME"/"${TARGET_FILE}" ]]; then
        echo "Already setup. ${TARGET_FILE}"
    else
        ln -sf ~/dotfiles/"${TARGET_FILE}" "$HOME"/"${TARGET_FILE}"
    fi
done

echo "Finish install process!"
