if [[ `uname` == Darwin ]]; then
    export CC=`which gcc`
fi

<<<<<<< c37e76fc44edf8209309ef327df132f72b1400d6
./waf configure --destdir=$PREFIX
./waf build
=======
export CC=$PREFIX/bin/clang
export CFLAGS="-fopenmp=libiomp5 -I`llvm-config --includedir` -I$PREFIX/include $CFLAGS"
export LDFLAGS="-L`llvm-config --libdir` -L$PREFIX/lib $LDFLAGS"

if [ -n "$MACOSX_DEPLOYMENT_TARGET" ]; then
    export MACOSX_DEPLOYMENT_TARGET=10.9
fi

printenv
llc --version

sed -e 's|gomp|omp|' wscript > wscript.tmp
cp -a wscript.tmp wscript

./waf configure -v --prefix=$PREFIX --use-system-cfitsio
./waf build -v
>>>>>>> clang+openmp test
./waf install
