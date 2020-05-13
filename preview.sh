#!/usr/bin/env bash
BASE_DIR=$(dirname $0)

cd ${BASE_DIR}
rm -rf "_build/*"
echo "The docs is serveing on http://127.0.0.1:18888"
sphinx-autobuild . _build -p 18888 -s 1
