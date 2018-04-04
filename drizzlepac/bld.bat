python setup.py build build_ext --inplace -- build_sphinx
if errorlevel 1 exit 1

python setup.py install
