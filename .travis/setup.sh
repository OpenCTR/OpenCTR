#!/bin/bash

set -e

if [ ! "${TRAVIS}" == "true" ]
then
    echo "$0 can only be called inside a Travis-CI environment"
    exit 1
fi

case "${OS}" in
linux)
    CPACK_GENERATOR="TBZ2"
    ;;
osx)
    CPACK_GENERATOR="TBZ2"

    brew update
    brew outdated cmake || brew upgrade cmake
    brew outdated autoconf || brew upgrade autoconf
    brew outdated automake || brew upgrade automake
    brew install ninja
    brew install gmp
    brew install mpfr
    brew install libmpc
    brew install libelf
    brew install bison
    brew install flex
    brew install libtool
    brew install binutils
    brew install gawk
    brew install texinfo
    ;;
mingw)
    if [ "${TRAVIS_OS_NAME}" == "osx" ]
    then
        echo "MinGW builds are not supported on OSX"
        exit 1
    fi

    CPACK_GENERATOR="ZIP"
    ;;
*)
    echo "Unrecognized OS: ${OS}"
    exit 1
    ;;
esac

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

cmake \
  -DCMAKE_BUILD_TYPE="Release" \
  -DCPACK_GENERATOR=${CPACK_GENERATOR} \
  -DENABLE_DOC=OFF \
  -DENABLE_LIBCTRU=OFF \
  -DENABLE_LIBCTR=ON \
  -DENABLE_LLVM=OFF \
  -DENABLE_GCC=ON \
  ${SOURCE_DIR}

