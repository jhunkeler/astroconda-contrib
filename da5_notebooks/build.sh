if [[ -z ${PKG_NAME} ]]; then
    echo "Conda build has changed out from under you. PKG_NAME is undefined..."
    exit 1
fi

pkg_name=$(echo ${PKG_NAME} | tr '-' '_')
dest="${PREFIX}/share/${pkg_name}"
usedir="$(pwd)"

if [[ -d ${usedir}/work ]]; then
    usedir=${usedir}/work
fi

mkdir -p "${dest}"
rsync -a "${usedir}"/notebooks/ "${dest}"/
