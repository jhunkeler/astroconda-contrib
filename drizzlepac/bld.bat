%PYTHON% setup.py build_sphinx
if errorlevel 1 exit 1

%PYTHON% setup.py install
