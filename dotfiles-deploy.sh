#/bin/bash

DIR_LIST[0]=".cache/dein"
DIR_LIST[1]=".cache/dein/plugins"
DIR_LIST[2]=".vim/colors"
DIR_LIST[3]=".bash_config"

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
