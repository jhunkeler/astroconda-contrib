%SCRIPTS%\replace.exe "-Wno-unused-function" "" setup.cfg
if errorlevel 1 exit 1
%PYTHON% setup.py install
