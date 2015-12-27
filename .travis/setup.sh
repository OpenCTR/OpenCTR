#!/bin/bash

set -e

if [ ! "${TRAVIS}" == "true" ]
then
    echo "$0 can only be called inside a Travis-CI environment"
    exit 1
fi

case "${TRAVIS_OS_NAME}" in
linux)
    CPACK_GENERATOR="TBZ2"
    ;;
osx)
    CPACK_GENERATOR="TBZ2"

    brew update
    brew outdated cmake || brew upgrade cmake
    brew outdated gcc || brew upgrade gcc
    brew outdated gmp || brew upgrade gmp
    brew outdated mpfr || brew upgrade mpfr
    brew outdated libmpc || brew upgrade libmpc
    brew outdated binutils || brew install binutils
    brew outdated ninja || brew install ninja
    brew outdated libelf | brew install libelf
    brew outdated isl | brew install isl
    ;;
*)
    echo "Unrecognized OS: ${TRAVIS_OS_NAME}"
    exit 1
    ;;
esac

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

cmake \
  -DCMAKE_BUILD_TYPE="Release" \
  -DCPACK_GENERATOR=${CPACK_GENERATOR} \
  -DENABLE_DOC=OFF \
  -DENABLE_TOOLCHAIN=ON \
  -DENABLE_TOOLS=ON \
  -DENABLE_LIBCTR=OFF \
  ${SOURCE_DIR}
