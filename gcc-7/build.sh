mkdir -p $PREFIX/lib
ln -s $PREFIX/lib $PREFIX/lib64

#sed -i.orig -e 's|lib64|lib|g' gcc/config.gcc
#sed -i.orig -e 's|\.\./lib64|../lib|' \
#    -e 's|\.\./libx32|../lib|' \
#    gcc/config/i386/t-linux64 \
#    gcc/genmultilib

./configure \
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
    --disable-bootstrap \
    --disable-libunwind-exceptions \
    --enable-shared \
    --enable-checking=release \
    --enable-threads=posix \
    --enable-linker-build-id \
    --enable-languages=c,c++,fortran

make -j${CPU_COUNT}
make install-strip

rm -f $PREFIX/lib64
[ -e "$PREFIX/bin/cc" ] || ln -s "gcc" "$PREFIX/bin/cc"

