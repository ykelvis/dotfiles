#!/bin/bash

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