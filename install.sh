#/bin/bash

##################################################################33
# Preparation
##################################################################33
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
# Update base repository packageis
# yum update -y
# yum install -y git
# git clone https://github.com/kirin0198/dotfiles.git


while [[ "$#" -gt 0 ]]; do
  case "${1}" in
    '--system' )
      if [[ -z "${2}" ]] || [[ "${2}" =~ ^--+ ]]; then
        echo "Unknown option, ${1}. Show usage with --usage option."
        exit 1
      else
        LINUX_SYSTEM="${2}"
        shift 2
       fi
    ;;
    '--proxy')
      PROXY_FLAG=1
      PROXY="${2}"
      shift 1
    ;;
    '--help'|'--usage')
      usage
      exit 0
    ;;
    *)
      echo "Unknown option, ${1}. Show usage with --usage option."
      exit 1
    ;;
  esac
done

##################################################################33
# Variables
##################################################################33
DOT_DIR="${HOME}/dotfiles"

##################################################################33
# Functions
##################################################################33
has() {
  type "$1" > /dev/null 2>&1
}


##################################################################33
# MAIN
##################################################################33
if [[ -d ${DOT_DIR} ]]; then
  cd "${DOT_DIR}"
else
  /bin/cat << EOS
[ERROR] Not exist directory. Please execute brow command.

    git clone https://github.com/kirin0198/dotfiles.git

EOS
fi

for f in .??*; do
    [ "$f" = ".git" ] && continue
    [ "$f" = ".gitmodules" ] && continue

    ln -snfv "${DOT_DIR}/$f" "${HOME}"
done

# Install for git and clone my dotfiles
# [Deploy]
# Install for need packageis

if [[ "${LINUX_SYSTEM}" == ubuntu ]]; then
  CMD="apt install -y"
elif [[ "${LINUX_SYSTEM}" == rhel ]]; then
  CMD="yum install -y"
fi

${CMD} epel-release
${CMD} python36 python36-devel python36-libs python36-pip npm curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker vim


# if [[ ${PROXY_FLAG} -eq 1 ]]; then
#   pip --proxy http://${PROXY}:${PROXY_PORT}
#   npm -g config set proxy http://${PROXY}:${PORT}
# fi

# pip install
$(which pip3) install --upgrade pip
$(which pip3) install neovim vim-vint pep8 pyflakes yamllint python-language-server


# npm install
npm config set python $(which python)
npm config set python $(which python3)
npm install --unsafe-perm -g node-inspector
npm install -g jsonlint bash-language-server dockerfile-language-server-nodejs


mkdir ~/git && cd $_
git clone https://github.com/vim/vim.git

yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker vim
yum install -y ncurses-devel gtk2-devel atk-devel libX11-devel libXt-devel gcc

cd ~/git/vim/src

./configure --with-features=huge --enable-gui=gtk2 --enable-pythoninterp --with-python-config-dir=$(which python2.7-config) --enable-python3interp --with-python3-config-dir=$(which python3.6-config) --enable-fail-if-missing
sudo make && sudo make install
echo "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh" >> ~/.zshrc
echo "[ -f ~/.fzf.bash ] && source ~/.fzf.bash" >> ~/.bashrc
