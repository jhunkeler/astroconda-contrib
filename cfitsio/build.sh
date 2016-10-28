./configure --prefix=$PREFIX --enable-reentrant
make -j${CPU_COUNT}
make shared
make install
