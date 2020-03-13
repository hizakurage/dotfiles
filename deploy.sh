#!/bin/bash

cd $(dirname $0)

function deploy() {
    local file=$(readlink -f $1)
    local dest_dir=~/
    if [ -n "$2" ]; then
        dest_dir=$2
    fi

    if [ ! -d ${dest_dir} ]; then
        mkdir ${dest_dir}
    fi

    echo Deploying $1 as ${dest_dir%/}/$(basename ${file})
    $(cd ${dest_dir}; ln -sf ${file})
}


################################################################################
# emacs
deploy .emacs.d/init.el ~/.emacs.d

# git
deploy .gitconfig
deploy .gitignore_global

# tmux
deploy .tmux.conf

# zsh
deploy .zshrc
deploy .zlogin

# python
deploy .flake8
deploy ipython_config.py ~/.ipython/profile_default/
