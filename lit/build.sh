#!/bin/bash

$PYTHON setup.py install 

touch $PREFIX/bin/llvm-lit
chmod +x $PREFIX/bin/llvm-lit
echo "#\!/bin/bash
\`which lit\` \$@
" > $PREFIX/bin/llvm-lit

