sed -i -e 's|pyfits.*|astropy (>=0.3.1)|' setup.cfg
$PYTHON setup.py install
