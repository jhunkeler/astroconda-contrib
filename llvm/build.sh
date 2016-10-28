bld=build_$PKG_NAME
mkdir -p $bld

if [ -n "$MACOSX_DEPLOYMENT_TARGET" ]; then
    export MACOSX_DEPLOYMENT_TARGET=10.9
fi

export LIBTOOL=/usr/bin/libtool

pushd $bld
    cmake \
        -DCMAKE_INSTALL_PREFIX=${CONDA_PREFIX} \
        -DCMAKE_LIBTOOL=${LIBTOOL} \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DLLVM_TARGETS_TO_BUILD="X86" \
        -DLLVM_BUILD_LLVM_DYLIB=yes \
        -DLLVM_LINK_LLVM_DYLIB=yes \
        -DLLVM_ENABLE_FFI=yes \
        -DLLVM_ENABLE_LTO=full \
        -DLLVM_OPTIMIZED_TABLEGEN=yes \
        ../

    make -j${CPU_COUNT}
    make install
popd

# For some reason the linter isn't installed by default
pip install lit

touch $PREFIX/bin/llvm-lit
chmod +x $PREFIX/bin/llvm-lit
echo "#\!/bin/bash
\`which lit\` \$@
" > $PREFIX/bin/llvm-lit

