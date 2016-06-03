./autogen.sh --prefix=$PREFIX \
    --with-unixodbc=$PREFIX

make -j ${CPU_COUNT}
make install
