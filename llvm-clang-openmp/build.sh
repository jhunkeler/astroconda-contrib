bld=build_$PKG_NAME
mkdir -p $bld

if [ -n "$MACOSX_DEPLOYMENT_TARGET" ]; then
    export MACOSX_DEPLOYMENT_TARGET=10.9
fi

export LIBTOOL=/usr/bin/libtool

pushd $bld
    cmake \
        -DCMAKE_INSTALL_PREFIX=${CONDA_PREFIX} \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        ../
    make -j${CPU_COUNT}
    make install
popd

