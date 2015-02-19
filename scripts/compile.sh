#!/bin/bash

compile_it{
	cd $arg;
	archlinuxcn-x86_64-build;
	archlinuxcn-i686-build;
	mv *pkg.tar.xz ~/repo&&echo DONE;
	cd -;
}

for arg in "$@"
do
	compile_it $arg;
done
