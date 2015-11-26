#!/bin/bash

set -e

if [ ! "${TRAVIS}" == "true" ]
then
    echo "$0 can only be called inside a travis-ci environment"
    exit 1
fi

CMAKE=$(which cmake)
if [ -z "${CMAKE}" ]
then
    echo "CMake is NOT installed"
    exit 1
fi

CMAKE_BUILD_TYPE="Release"

if [ "${OS}" == "linux" ]
then
    CPACK_GENERATOR="TBZ2"
elif [ "${OS}" == "osx" ]
then
    CPACK_GENERATOR="TBZ2"
elif [ "" == "mingw" ]
then
    CPACK_GENERATOR="ZIP"
else
    echo "Unrecognized OS: ${OS}"
    exit 1
fi

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

${CMAKE} \
  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
  -DCPACK_GENERATOR=${CPACK_GENERATOR} \
  -DENABLE_DOC=OFF \
  -DENABLE_LIBCTRU=OFF \
  -DENABLE_LIBCTR=ON \
  -DENABLE_LLVM=OFF \
  -DENABLE_GCC=ON \
  ${SOURCE_DIR}

