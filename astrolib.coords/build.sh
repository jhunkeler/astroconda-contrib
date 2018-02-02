
pip install --no-deps --upgrade --force d2to1
test -f README.md && ln -s README.md README.txt
$PYTHON setup.py install