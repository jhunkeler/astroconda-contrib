OS=`uname`
top=`pwd`
bld=build_$PKG_NAME
mkdir -p $bld



if [ -n "$MACOSX_DEPLOYMENT_TARGET" ]; then
    export MACOSX_DEPLOYMENT_TARGET=10.9
fi

export LIBTOOL=/usr/bin/libtool

#get sources
fetch=curl
fetch_args="-LO"
if [ ! -x `which $fetch` ]; then
    fetch=wget
    fetch_args=""
    if [ ! -x `which $fetch` ]; then
        echo "Cannot download without curl or wget"
        exit 1
    fi
fi

release_url=http://llvm.org/releases/${PKG_VERSION}
packages=(
    cfe
    clang-tools-extra
    libcxx
    libcxxabi
    libunwind
    lld
    lldb
    openmp
    polly
)


for p in "${packages[@]}"
do
    pkg="${p}-${PKG_VERSION}"
    pkg_tarball="${pkg}.src.tar.xz"
    pkg_unpacked="${pkg}.src"
    $fetch $fetch_args ${release_url}/${pkg_tarball}

    tar xf $pkg_tarball

    case "$p" in
        cfe)
            mv $pkg_unpacked $top/tools/clang
        ;;
        clang-tools-extra)
            mv $pkg_unpacked $top/tools/clang/tools/extra
        ;;
        polly)
            mv $pkg_unpacked $top/tools/polly
        ;;
        lldb)
            mv $pkg_unpacked $top/tools/lldb
        ;;
        libcxx)
            mv $pkg_unpacked $top/projects/libcxx
        ;;
        libcxxabi)
            mv $pkg_unpacked $top/projects/libcxxabi
        ;;
        libunwind)
            mv $pkg_unpacked $top/projects/libunwind
        ;;
        lld)
            mv $pkg_unpacked $top/projects/lld
        ;;
        openmp)
            mv $pkg_unpacked $top/projects/openmp
    esac
done


pushd $bld

# Will use some day... currently breaks lld/lldb/lldb-server
#-DLLVM_BUILD_LLVM_DYLIB=yes
#-DLLVM_LINK_LLVM_DYLIB=yes

case "$OS" in
    Darwin)
        cmake \
            -DCMAKE_INSTALL_PREFIX=${CONDA_PREFIX} \
            -DCMAKE_LIBTOOL=${LIBTOOL} \
            -DCMAKE_BUILD_TYPE=Release \
            -DLLVM_TARGETS_TO_BUILD="X86" \
            -DLLVM_ENABLE_FFI=yes \
            -DLLVM_ENABLE_LTO=full \
            -DLLVM_ENABLE_LIBCXX=yes \
            -DLLVM_ENABLE_EH=yes \
            -DLLVM_ENABLE_RTTI=yes \
            -DLLVM_OPTIMIZED_TABLEGEN=yes \
            -DLLDB_DISABLE_PYTHON=1 \
            ../
    ;;
    Linux)
        export PKG_CONFIG_PATH=$CONDA_PREFIX/lib/pkgconfig
        export CFLAGS="-I$CONDA_PREFIX/include -I/usr/include"
        export CXXFLAGS="$CFLAGS"
        export LDFLAGS="-L$CONDA_PREFIX/lib -L/usr/lib64"

        cmake \
            -DCMAKE_INSTALL_PREFIX=${CONDA_PREFIX} \
            -DCMAKE_LIBTOOL=${LIBTOOL} \
            -DCMAKE_BUILD_TYPE=Release \
            -DLLVM_TARGETS_TO_BUILD="X86" \
            -DLLVM_ENABLE_FFI=yes \
            -DFFI_INCLUDE_DIR=`pkg-config libffi --variable=includedir` \
            -DFFI_LIBRARY_DIR=`pkg-config libffi --variable=libdir` \
            -DCMAKE_CXX_LINK_FLAGS="-Wl,-rpath,${CONDA_PREFIX}/lib -L${CONDA_PREFIX}/lib" \
            -DLLVM_ENABLE_LTO=full \
            -DLLVM_ENABLE_LIBCXX=yes \
            -DLLVM_ENABLE_EH=yes \
            -DLLVM_ENABLE_RTTI=yes \
            -DLLVM_OPTIMIZED_TABLEGEN=yes \
            -DLLDB_DISABLE_PYTHON=1 \
            ../
    ;;
esac

    make -j${CPU_COUNT}
    make install
popd

