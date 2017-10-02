#!/bin/bash

platform=$(uname -s)
spec="--prefix=$PREFIX \
--with-features=huge \
--enable-gui=no \
--without-x \
--enable-multibyte \
--enable-cscope"

if [[ $(uname -s) == Darwin ]]; then
    spec="$spec --disable-darwin"
fi

pushd src
./configure $spec
make -j${CPU_COUNT}
make install
popd
