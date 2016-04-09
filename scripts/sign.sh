#!/bin/bash

LOCAL=$HOME/repo/

mv $LOCAL/_repo/* $LOCAL/_repo_done;
rsync -v -r barch:~/_repo $LOCAL&&
(cd $LOCAL/_repo;for i in *.xz;do gpg --detach-sign $i;done)&&
rsync -v  $LOCAL/_repo/* barch:~/repo&&
mv $LOCAL/_repo/* $LOCAL/_repo_done/;
rsync --delete-after -v -r $LOCAL/_repo barch:~
