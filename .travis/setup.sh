#!/bin/bash

if [ ! "${TRAVIS}" == "true" ]
then
    echo "$0 can only be called inside a Travis-CI environment"
    exit 1
fi

brew_install() {
    PKG=$1

    brew info $PKG &> /dev/null
    if [ $? -ne 0 ]
    then
        brew install $PKG
    else
        brew outdated $PKG &> /dev/null
        if [ $? -ne 0 ]
        then
            brew upgrade $PKG
        fi
    fi
}

case "${TRAVIS_OS_NAME}" in
linux)
    CPACK_GENERATOR="TBZ2"
    ;;
osx)
    CPACK_GENERATOR="TBZ2"

    brew update
    brew_install cmake
    brew_install gmp
    brew_install mpfr
    brew_install libmpc
    brew_install isl
    brew_install binutils
    brew_install ninja
    brew_install libelf
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
