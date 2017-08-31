mkdir -p build
pushd build
../configure --prefix=$PREFIX \
    --disable-multilib \
    --disable-bootstrap \
    --enable-languages=c,c++,fortran \
    --with-gmp=$PREFIX \
    --with-mpc=$PREFIX \
    --with-mpfr=$PREFIX \
    --with-isl=$PREFIX \
    --with-cloog=$PREFIX

make -j${CPU_COUNT}
make install
popd
