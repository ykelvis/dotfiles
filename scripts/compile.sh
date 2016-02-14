#!/bin/bash

compile_it(){
    (
    s1="";
    s2="";
    cd $arg;
    echo "$arg building begin";
    archlinuxcn-x86_64-build -c -r ~/build||s1=1;
    archlinuxcn-i686-build -c -r ~/build||s2=1;
    [[ ! -z $s1 ]]&&echo "s1 failed";
    [[ ! -z $s2 ]]&&echo "s2 failed";
    mv *pkg.tar.xz ~/repo;
    )
}

for arg in "$@"
do
    compile_it $arg;
done
