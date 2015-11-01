#!/bin/sh

set -e

export SOURCE_DIR=${PWD}
export BUILD_DIR=${SOURCE_DIR}/build

CMAKE=$(which cmake)
if [ -z "${CMAKE}" ]
then
    echo "CMake is NOT installed"
    exit 1
fi

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

${CMAKE} .. \
  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
  -DCPACK_GENERATOR=${CPACK_GENERATOR} \
  -DENABLE_DOC=OFF \
  -DENABLE_LIBCTRU=OFF \
  -DENABLE_LIBCTR=ON \
  -DENABLE_LLVM=OFF \
  -DENABLE_GCC=ON

${CMAKE} --build . --config ${CMAKE_BUILD_TYPE} --target OpenCTR

${CMAKE} --build . --config ${CMAKE_BUILD_TYPE} --target package
