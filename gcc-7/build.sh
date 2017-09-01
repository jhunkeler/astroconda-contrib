topdir=$(pwd)
objdir=${topdir}/build

mkdir -p $PREFIX/lib
ln -s $PREFIX/lib $PREFIX/lib64
ln -s $PREFIX/lib $PREFIX/lib32

mkdir -p ${objdir}
pushd ${objdir}

sed -i.orig -e 's|lib64|lib|g' ${topdir}/gcc/config.gcc

${topdir}/configure --prefix=$PREFIX \
    --libdir=$PREFIX/lib \
    --with-gmp=$PREFIX \
    --with-mpc=$PREFIX \
    --with-mpfr=$PREFIX \
    --with-isl=$PREFIX \
    --with-cloog=$PREFIX \
    --with-tune=generic \
    --with-linker-hash-style=gnu \
    --with-gcc-major-version-only \
    --disable-multilib \
    --disable-bootstrap \
    --disable-libunwind-exceptions \
    --enable-shared \
    --enable-checking=release \
    --enable-threads=posix \
    --enable-languages=c,c++,fortran,go \
    --enable-linker-build-id

make -j${CPU_COUNT}
make install

popd
rm -f $PREFIX/lib64
rm -f $PREFIX/lib32
