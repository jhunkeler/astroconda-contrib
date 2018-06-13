pip install --no-deps --upgrade sphinx-automodapi

$PYTHON setup.py build build_ext --inplace -- build_sphinx
$PYTHON setup.py install
