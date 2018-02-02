
pip install --no-deps --upgrade --force d2to1
sed -i -e 's|pyfits.*|astropy (>=0.3.1)|' setup.cfg
$PYTHON setup.py install