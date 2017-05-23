export LDFLAGS="-L$CONDA_PREFIX/lib"
export CFLAGS="-I$CONDA_PREFIX/include"

./configure --prefix=$PREFIX --enable-shared
make -j${CPU_COUNT}
make install
