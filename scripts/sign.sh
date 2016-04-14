#!/bin/bash


rm -rf $HOME/_repo/*&&
rsync -v -r barch:~/_repo $HOME&&
(cd $HOME/_repo;for i in *.xz;do gpg --detach-sign $i;done)&&
rsync -v  $HOME/_repo/* barch:~/_repo&&
ssh barch "cp ~/_repo/* ~/repo/"&&
ssh barch "mv ~/_repo/* ~/archive/"&&
rm -rf $HOME/_repo/*
#rsync --delete-after -v -r $LOCAL/_repo barch:~
