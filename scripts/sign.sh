#!/bin/bash

rm -rf $HOME/_repo/*&&
rsync --delete-after -v -r barch:~/_repo $HOME&&
while [[ ! $reply == "y" ]];do
    echo "rsync done, proceed to pgp sign?(y/n)";
    read reply;
done;
(cd $HOME/_repo;for i in *.xz;do gpg --detach-sign $i;done)&&
rsync -v $HOME/_repo/* barch:~/_repo&&
ssh barch "cp ~/_repo/* ~/repo/"&&
ssh barch "mv ~/_repo/* ~/archive/"&&
#rm -rf $HOME/_repo/*
ssh barch "echo '_repo';ls ~/_repo"
ssh barch "echo 'repo';ls ~/repo"
#rsync --delete-after -v -r $LOCAL/_repo barch:~
