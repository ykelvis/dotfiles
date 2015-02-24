#!/bin/bash

first_two(){
	echo $arg|cut -c1-2;
}

get_tarball(){
	two=`first_two $arg`;
	wget https://aur.archlinux.org/packages/$two/$arg/$arg.tar.gz;
	tar xvf $arg.tar.gz;
	rm -rf $arg.tar.gz;
}

git_message(){
	git add .;
	git commit -m "upgpkg: $arg";
}

for arg in "$@"
do
	get_tarball $arg;
	git_message $arg;
done