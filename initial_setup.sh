#/bin/bash

set -e

##################################################################
# Preparation
##################################################################
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
# yum install -y git
# git clone https://github.com/kirin0198/dotfiles.git

##################################################################
# Option check
##################################################################
#{{{
function usage()
{
  cat << EOS
Usage:
EOS
}

if [[ "$#" -eq 0 ]]; then
  echo "Needed options."
  exit 1
fi

while [[ "$#" -gt 0 ]]; do
  case "${1}" in
    '--system' )
      if [[ -z "${2}" ]] || [[ "${2}" =~ ^--+ ]]; then
        echo "Unknown option, ${1}. Show usage with --usage option."
        exit 1
      else
        case "${2}" in
          'redhat'|'centos')
            LINUX_SYSTEM="rhel"
          ;;
          'ubuntu'|'debian')
            LINUX_SYSTEM="debian"
          ;;
          *)
            echo "Unknown augument, ${2}. Show usage with --usage option."
          ;;
        esac
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

#}}}

##################################################################33
# Variables
##################################################################33
#{{{

DOT_DIR="${HOME}/dotfiles"
PACKAGES[0]=""
PACKAGES[1]=""
PACKAGES[2]=""
PACKAGES[3]=""
PACKAGES[4]=""
PACKAGES[5]=""
PACKAGES[6]=""
PACKAGES[7]=""
PACKAGES[8]=""
PACKAGES[9]=""
PACKAGES[10]=""
PACKAGES[11]=""
PACKAGES[12]=""

#}}}

##################################################################33
# Functions
##################################################################33
#{{{
has() {
  type "$1" > /dev/null 2>&1
}

function _package_install()
{
  case "${LINUX_SYSTEM}" in
    'debian')
      PKG_INS_CMD="apt install -y"
      ;;
    'rhel')
      PKG_INS_CMD="yum install -y"
      ;;
    *)
      echo "${LINUX_SYSTEM} Didn't match anything"
    ;;
  esac

  PKG_INS_CMD="${PKG_INS_CMD} $#"

  exec ${PKG_INS_CMD}
  RC=$?

  if [[ ${RC} -ne 0 ]]; then
    echo "[ERORR] Failed run to yum command."
    exit 1
  fi

}

function _pip_install()
{
  if has pip3; then
    PIP_CMD="pip3 install $#"
  else
    PIP_CMD="pip install $#"
  fi

  exec ${PIP_CMD}
  RC=$?

  if [[ ${RC} -ne 0 ]]; then
    echo "[ERROR] Failed run to pip command."
    exit 1
  fi

}

#}}}

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


_package_install epel-release
_package_install python36 python36-devel python36-libs python36-pip npm curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker vim


# if [[ ${PROXY_FLAG} -eq 1 ]]; then
#   pip --proxy http://${PROXY}:${PROXY_PORT}
#   npm -g config set proxy http://${PROXY}:${PORT}
# fi

# pip install
$(which pip3) install --upgrade pip
$(which pip3) install neovim vim-vint pep8 pyflakes yamllint python-language-server


# npm install
npm config set python $(which python)
npm install --unsafe-perm -g node-inspector
npm install -g jsonlint bash-language-server dockerfile-language-server-nodejs


mkdir ~/git && cd !$
git clone https://github.com/vim/vim.git

yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker vim
yum install -y ncurses-devel gtk2-devel atk-devel libX11-devel libXt-devel gcc

cd ~/git/vim/src

./configure --with-features=huge --enable-gui=gtk2 --enable-pythoninterp --with-python-config-dir=$(which python2.7-config) --enable-python3interp --with-python3-config-dir=$(which python3.6-config) --enable-fail-if-missing
sudo make && sudo make install
$( echo ${SHELL} )
case "${SHELL}" in
  '/bin/bash')
    echo "[ -f ~/.fzf.bash ] && source ~/.fzf.bash" >> ~/.bashrc
    ;;
  '/usr/bin/zsh')
    echo "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh" >> ~/.zshrc
    ;;
  *)
    echo "No configuration of FZF."
esac
