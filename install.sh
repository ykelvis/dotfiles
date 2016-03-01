#!/bin/bash

USER=$(whoami)
DIR=$(pwd)

git submodule init
git submodule update --remote

link_file(){
    for i in $@;do
        ln -s $DIR/$i $HOME/.$i
    done
}

link_folder(){
    for i in $@;do
        [[ -x $HOME/.$i ]]&&
        echo "$i exists"||
        ln -s $DIR/$i $HOME/.$i
    done
}

link_config(){
    for i in $@;do
        [[ -x $HOME/.config/$i ]]&&
        echo "~/.config/$i exists"||
        ln -s $DIR/$i $HOME/.config/$i
    done
}

link_file zshrc vimperatorrc tmux.conf conkyrc compton.conf vimrc Xdefaults
link_folder oh-my-zsh vim
link_config mpv awesome
