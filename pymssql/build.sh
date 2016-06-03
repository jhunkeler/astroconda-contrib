#!/bin/bash

test -d /sw && export PATH="`purge_path /sw`"
export CFLAGS="-I$PREFIX/include $CFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"

sed -i '' -e '/setup_requires=/d' setup.py
sed -i '' -e 's|/sw|/DONOTHARDCODEFINK|g' setup.py
sed -i '' -e 's|/opt/local|/DONOTHARDCODEMACPORTS|g' setup.py
sed -i '' -e "s|/usr/local|$PREFIX|g" setup.py

$PYTHON setup.py install

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
