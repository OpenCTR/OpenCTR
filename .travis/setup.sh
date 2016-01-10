#!/bin/bash
################################################################################
# OpenCTR - A free and open-source SDK for Nintendo 3DS homebrew.
#
# Copyright (C) 2015 The OpenCTR Project.
#
# This file is part of OpenCTR.
#
# OpenCTR is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.
#
# OpenCTR is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License
# along with OpenCTR. If not, see <http://www.gnu.org/licenses/>.
################################################################################

if [ ! "${TRAVIS}" == "true" ]
then
    echo "$0 can only be called inside a Travis-CI environment"
    exit 1
fi

if [ -z "${CMAKE_BUILD_TYPE}" ]
then
    CMAKE_BUILD_TYPE="Release"
fi

case "${TRAVIS_OS_NAME}" in
linux)
    CPACK_GENERATOR="TBZ2"
    ;;
osx)
    CPACK_GENERATOR="TBZ2"

    brew update
    brew outdated cmake || brew upgrade cmake
    brew outdated gmp || brew upgrade gmp
    brew outdated mpfr || brew upgrade mpfr
    brew outdated libmpc || brew upgrade libmpc
    brew outdated isl | brew upgrade isl
    brew install binutils
    brew install ninja
    brew install libelf
    ;;
*)
    echo "Unrecognized OS: ${TRAVIS_OS_NAME}"
    exit 1
    ;;
esac

CMAKE=$(which cmake)
if [ ! -e "${CMAKE}" ]
then
    echo "CMake executable not found"
    exit 1
fi

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

cmake \
  -DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}" \
  -DCPACK_GENERATOR=${CPACK_GENERATOR} \
  -DENABLE_DOC=OFF \
  -DENABLE_TOOLCHAIN=ON \
  -DENABLE_TOOLS=ON \
  -DENABLE_LIBCTR=OFF \
  ${SOURCE_DIR}
