./configure --prefix=$PREFIX --enable-readline

make -j ${CPU_COUNT}
make install
