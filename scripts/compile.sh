#!/bin/bash

compile_it(){
    cd $arg;
    echo "$arg building begin"
    extra-x86_64-build&>/dev/null||archlinuxcn-x86_64-build&>/dev/null||echo "$arg build failed";
    extra-i686-build&>/dev/null||archlinuxcn-i686-build&>/dev/null||echo "$arg build failed";
    mv *pkg.tar.xz ~/repo&&echo "$arg DONE"||echo "$arg failed";
    cd -;
}

for arg in "$@"
do
    compile_it $arg;
done
