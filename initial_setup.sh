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

# Option check

DOT_DIR="${HOME}/dotfiles"

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
    '--cmd'|'-c' )
      if [[ -z "${2}" ]] || [[ "${2}" =~ ^-+ ]]; then
        echo "Unknown option, ${1}. Show usage with --usage option."
        exit 1
      else
        CMD=${2:-yum}
        shift 2
       fi
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

# Functions
has() {
  type "$1" > /dev/null 2>&1
}

deploy() {
  if [[ -d ${DOT_DIR} ]]; then
    cd "${DOT_DIR}"
  else
    /bin/cat << EOS
[ERROR] Not exist directory. Please execute brow command.

    git clone https://github.com/kirin0198/dotfiles.git

EOS
  fi

  cd ${DOT_DIR}

  for f in .??*; do
      [ "$f" = ".git" ] && continue
      [ "$f" = ".gitmodules" ] && continue

      ln -snfv "${DOT_DIR}/$f" "${HOME}"
  done
}

package_install() {
  INSTALL="${CMD} install -y $@"
  exec ${INSTALL} > /dev/null
  RC=$?

  if [[ ${RC} -ne 0 ]]; then
    echo "[ERORR] Failed run to yum command."
    exit 1
  fi

}

pip_install()
{
  if has pip3; then
    PIP_CMD="pip3 install $@"
  else
    PIP_CMD="pip install $@"
  fi

  exec ${PIP_CMD} > /dev/null
  RC=$?

  if [[ ${RC} -ne 0 ]]; then
    echo "[ERROR] Failed run to pip command."
    exit 1
  fi

}

npm_install()
{
  if has npm; then
    NPM_CMD="npm -g install $@"
  else
    NPM_CMD="pip install $@"
  fi

  exec ${NPM_CMD} > /dev/null
  RC=$?

  if [[ ${RC} -ne 0 ]]; then
    echo "[ERROR] Failed run to pip command."
    exit 1
  fi

}

vim_initialiyze()
{
  mkdir ${HOME}/git
  cd ${HOME}/git
  git clone https://github.com/vim/vim.git > /dev/null
  cd ${HOME}/git/vim/src

  if ! has python2.7-config; then
    exit 1
  elif has python3.6-config; then
    exit 1
  fi

  ./configure --with-features=huge --enable-gui=gtk2 --enable-pythoninterp --with-python-config-dir=$(which python2.7-config) --enable-python3interp --with-python3-config-dir=$(which python3.6-config) --enable-fail-if-missing > /dev/null

  sudo make > /dev/null
  sudo make install > /dev/null
}


# MAIN
main()
{
  deploy

  package_install epel-release
  package_install python36 python36-devel python36-libs python36-pip npm curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker vim ncurses-devel gtk2-devel atk-devel libX11-devel libXt-devel gcc

  # pip install
  pip_install install neovim vim-vint pep8 pyflakes yamllint python-language-server

  # npm install
  npm config set python $(which python)
  npm install --unsafe-perm -g node-inspector
  npm install -g jsonlint bash-language-server dockerfile-language-server-nodejs

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
  echo "Finished."
}

main
