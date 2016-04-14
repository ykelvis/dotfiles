#!/bin/bash

LOCAL=$HOME

rsync -v -r barch:~/_repo $LOCAL&&
(cd $LOCAL/_repo;for i in *.xz;do gpg --detach-sign $i;done)&&
rsync -v  $LOCAL/_repo/* barch:~/_repo&&
ssh barch "cp ~/_repo/* ~/repo/"&&
ssh barch "mv ~/_repo/* ~/archive/"&&
rm -rf $LOACL/_repo/*
#rsync --delete-after -v -r $LOCAL/_repo barch:~
