#!/bin/bash

compile_it(){
    (
    s1="";
    s2="";
    cd $arg;
    echo -e "\033[31m$arg building begin\033[0m";
    archlinuxcn-x86_64-build -c -r ~/build||s1=1;
    archlinuxcn-i686-build -c -r ~/build||s2=1;
    [[ ! -z $s1 ]]&&echo -e "\033[31ms1 failed\033[0m";
    [[ ! -z $s2 ]]&&echo -e "\033[31ms2 failed\033[0m";
    mv *pkg.tar.xz ~/repo;
    )
}

for arg in "$@"
do
    compile_it $arg;
done
