srcdir=$(pwd)

# Disable fixincludes
sed -i.orig 's@\./fixinc\.sh@-c true@' gcc/Makefile.in

cd ..
topdir=$(pwd)

mkdir -p $PREFIX/lib
ln -s $PREFIX/lib $PREFIX/lib64

mkdir gcc-build
pushd gcc-build

${srcdir}/configure \
    --prefix=$PREFIX \
    --libdir=$PREFIX/lib \
    --datadir=$PREFIX/share \
    --with-gmp=$PREFIX \
    --with-mpc=$PREFIX \
    --with-mpfr=$PREFIX \
    --with-isl=$PREFIX \
    --with-cloog=$PREFIX \
    --with-tune=generic \
    --disable-multilib \
    --disable-libunwind-exceptions \
    --disable-werror \
    --enable-shared \
    --enable-checking=release \
    --enable-threads=posix \
    --enable-linker-build-id \
    --enable-languages=c,c++,fortran

make -j${CPU_COUNT}
make install-strip
popd

rm -f $PREFIX/lib64
[ -e "$PREFIX/bin/cc" ] || ln -s "gcc" "$PREFIX/bin/cc"

