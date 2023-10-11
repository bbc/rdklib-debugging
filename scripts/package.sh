#!/bin/bash
set -e

export PATH="${HOME}/.poetry/bin:${PATH}"
export VENV_PATH=$(poetry env info -p)

SRC_DIR=${CODEBUILD_SRC_DIR:-.}
BUILD_DIR=${SRC_DIR}/build

echo "SRC_DIR = ${SRC_DIR}"
echo "BUILD_DIR = ${BUILD_DIR}"

poetry install --without dev --sync
mkdir -p ${BUILD_DIR}
cp -R ${VENV_PATH}/lib/python3.*/site-packages/* ${BUILD_DIR}
cp -R ${SRC_DIR}/rdklib_debugging ${BUILD_DIR}

cd ${BUILD_DIR}
zip -r ../package.zip .
cd ..
