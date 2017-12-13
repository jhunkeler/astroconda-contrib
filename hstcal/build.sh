if [[ `uname` == Darwin ]]; then
    export CC=`which gcc`
    export DARWIN_FLAGS='-m64'
    export CFLAGS="$CFLAGS $DARWIN_FLAGS"
    export LDFLAGS="$LDFLAGS $DARWIN_FLAGS"
fi

./waf configure --prefix=$PREFIX
./waf build
./waf install
