#/bin/bash

echo "Start setup process...."
if [[ -f ~/.vimrc ]]; then
    echo "Already setup. File: vimrc"
else
    ln -sf ~/dotfiles/.vimrc ~/.vimrc
fi

if [[ -f ~/.inputrc ]]; then
    echo "Already setup. File: inputrc"
else
    ln -sf ~/dotfiles/.inputrc ~/.inputrc
fi

if [[ -e ~/.bash_config ]]; then
    echo "Already setup. Dir: bash_config"
else
    mkdir ~/.bash_config
fi

echo "Finish install process!"
