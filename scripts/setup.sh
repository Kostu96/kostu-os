#
# Copyright (C) 2023 Konstanty Misiak
#
# SPDX-License-Identifier: MIT
#

PREFIX="$HOME/opt/cross"
TARGET=i686-elf
PATH="$PREFIX/bin:$PATH"

git clone git://sourceware.org/git/binutils-gdb.git $HOME/binutils
cd $HOME/binutils
git checkout binutils-2_38
mkdir -p build-binutils
cd build-binutils
../configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j 4
make install

git clone git://gcc.gnu.org/git/gcc.git $HOME/gcc
cd $HOME/gcc
git checkout releases/gcc-11.4.0
mkdir -p build-gcc
cd build-gcc
../configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c --without-headers
make -j 4 all-gcc
make -j 4 all-target-libgcc
make install-gcc
make install-target-libgcc

export PATH="$HOME/opt/cross/bin:$PATH"
