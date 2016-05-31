./bootstrap.sh
./configure --prefix=$PREFIX \
    --enable-shared
make -j${CPU_COUNT}
make install
make check
