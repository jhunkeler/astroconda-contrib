OS=`uname`
top=`pwd`
bld=build_$PKG_NAME
mkdir -p $bld

if [[ $OS == Darwin ]]; then
    export LIBTOOL=/usr/bin/libtool
    if [ -n "$MACOSX_DEPLOYMENT_TARGET" ]; then
        export MACOSX_DEPLOYMENT_TARGET=10.9
    fi
fi

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

#release_url=http://llvm.org/releases/${PKG_VERSION}
release_branch=release_50
release_url=https://github.com/llvm-mirror
packages=(
    clang
    clang-tools-extra
    compiler-rt
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
    #pkg_tarball="${pkg}.src.tar.xz"
    pkg_unpacked="${pkg}.src"
    #$fetch $fetch_args ${release_url}/${pkg_tarball}
    git clone --depth 1 --branch ${release_branch} --single-branch ${release_url}/${p} ${pkg_unpacked}

    #tar xf $pkg_tarball
    #rm -f "${pkg_tarball}"

    case "$p" in
        clang)
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
        compiler-rt)
            mv $pkg_unpacked $top/projects/compiler-rt
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
            -DCMAKE_INSTALL_PREFIX=${PREFIX} \
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
        export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig
        export CFLAGS="-I$PREFIX/include -I/usr/include"
        export CXXFLAGS="$CFLAGS"
        export LDFLAGS="-L$PREFIX/lib -L/usr/lib64"

        cmake \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
            -DDEFAULT_SYSROOT="${PREFIX}" \
            -DGCC_INSTALL_PREFIX="${PREFIX}" \
            -DCMAKE_C_COMPILER="${PREFIX}/bin/gcc" \
            -DCMAKE_CXX_COMPILER="${PREFIX}/bin/g++" \
            -DCMAKE_CXX_LINK_FLAGS="-Wl,-rpath,${PREFIX}/lib -L${PREFIX}/lib" \
            -DCURSES_INCLUDE_PATH="${PREFIX}/include" \
            -DFFI_INCLUDE_DIR=`pkg-config libffi --variable=includedir` \
            -DFFI_LIBRARY_DIR=`pkg-config libffi --variable=libdir` \
            -DBUILD_SHARED_LIBS=yes \
            -DLLVM_BUILD_STATIC_LIBS=no \
            -DLLVM_TARGETS_TO_BUILD="X86" \
            -DLLVM_ENABLE_FFI=yes \
            -DLLVM_ENABLE_LTO=no \
            -DLLVM_ENABLE_LIBCXX=yes \
            -DLLVM_ENABLE_EH=no \
            -DLLVM_ENABLE_RTTI=no \
            -DLLVM_OPTIMIZED_TABLEGEN=yes \
            -DLLDB_DISABLE_PYTHON=1 \
            -DLIBOMPTARGET_SYSTEM_TARGETS="x86_64-pc-linux-gnu" \
            ../
    ;;
esac

make -j$(( CPU_COUNT - 1 ))
make install
popd

