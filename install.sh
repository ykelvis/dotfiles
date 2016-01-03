#!/bin/bash

create_folder_if_not(){
    [[ -x $1 ]]||mkdir -pv $1
}

backup_file_if_is(){
    [[ -f $1 ]]&&mv "$1" "$1.bak"
}

USER=$(whoami)
DIR=$(pwd)

git submodule init
git submodule update --remote

ln -s $DIR/awesome /home/$USER/.config/
ln -s $DIR/oh-my-zsh/ /home/$USER/.oh-my-zsh
ln -s $DIR/zshrc /home/$USER/.zshrc
ln -s $DIR/vimperatorrc /home/$USER/.vimperatorrc
ln -s $DIR/tmux.conf /home/$USER/.tmux.conf
ln -s $DIR/conkyrc /home/$USER/.conkyrc
ln -s $DIR/compton.conf /home/$USER/.compton.conf
ln -s $DIR/vimrc /home/$USER/.vimrc
ln -s $DIR/vim /home/$USER/.vim
ln -s $DIR/Xdefaults /home/$USER/.Xdefaults
ln -s $DIR/mpv.conf /home/$USER/.config/mpv/mpv.conf
ln -s $DIR/input.conf /home/$USER/.config/mpv/input.conf
