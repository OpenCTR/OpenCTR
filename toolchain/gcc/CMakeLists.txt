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

include(ExternalProject)

# GCC target
ExternalProject_Add(gcc
    DEPENDS binutils
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}
    INSTALL_DIR ${OPENCTR_ROOT}
    URL "${GCC_URL}"
    URL_HASH "SHA256=${GCC_HASH}"
    PATCH_COMMAND ${PATCH_EXECUTABLE} --strip=1 --quiet --input=${GCC_PATCH}
        --directory=<SOURCE_DIR>
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
        --prefix=<INSTALL_DIR>
        --target=arm-none-eabi
        --disable-nls
        --disable-shared
        --disable-debug
        --disable-dependency-tracking
        --disable-werror
        --with-bugurl=https://github.com/OpenCTR/OpenCTR/issues
        --enable-checking=release
        --disable-bootstrap
        --enable-interwork
        --enable-languages=c,c++
        --with-endian=little
        --with-arch=armv6k
        --enable-threads
        --disable-win32-registry
        --with-newlib
        --without-headers
        --enable-lto
        --enable-multilib
        --with-system-zlib
        ${EXTRA_ARGS}
    BUILD_COMMAND ${MAKE_EXECUTABLE}
    INSTALL_COMMAND ${MAKE_EXECUTABLE} install
    LOG_DOWNLOAD ${ENABLE_LOG}
    LOG_CONFIGURE ${ENABLE_LOG}
    LOG_BUILD ${ENABLE_LOG}
    LOG_INSTALL ${ENABLE_LOG}
)

# Newlib target
ExternalProject_Add(newlib
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}
    INSTALL_DIR ${OPENCTR_ROOT}
    URL "${NEWLIB_URL}"
    URL_HASH "SHA256=${NEWLIB_HASH}"
    PATCH_COMMAND ${PATCH_EXECUTABLE} --strip=1 --quiet --input=${NEWLIB_PATCH}
        --directory=<SOURCE_DIR>
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
        --prefix=<INSTALL_DIR>
        --target=arm-none-eabi
        --disable-newlib-supplied-syscalls
        --enable-newlib-mb
        --enable-multilib
        "PATH=<INSTALL_DIR>/bin:$ENV{PATH}"
        ${EXTRA_ARGS}
    BUILD_COMMAND ${MAKE_EXECUTABLE}
        PATH=<INSTALL_DIR>/bin:$ENV{PATH}
    INSTALL_COMMAND ${MAKE_EXECUTABLE} install
        PATH=<INSTALL_DIR>/bin:$ENV{PATH}
    LOG_DOWNLOAD ${ENABLE_LOG}
    LOG_CONFIGURE ${ENABLE_LOG}
    LOG_BUILD ${ENABLE_LOG}
    LOG_INSTALL ${ENABLE_LOG}
)

# Do not build newlib by default.
set_property(TARGET newlib PROPERTY EXCLUDE_FROM_ALL TRUE)

# Dependency Injection: Require "make all-gcc" after "configure"
ExternalProject_Add_Step(gcc all-gcc
    COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS} all-gcc
    DEPENDEES configure
    WORKING_DIRECTORY <BINARY_DIR>
    LOG ${ENABLE_LOG}
)

# Dependency Injection: Require "make install-gcc" after "all-gcc"
ExternalProject_Add_Step(gcc install-gcc
    COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS} install-gcc
    DEPENDEES all-gcc
    WORKING_DIRECTORY <BINARY_DIR>
    LOG ${ENABLE_LOG}
)

# Dependency Injection: Make GCC 'build' stage depend on Newlib
ExternalProject_Add_Step(gcc newlib
    COMMAND ${CMAKE_MAKE_PROGRAM} newlib
    DEPENDEES install-gcc
    DEPENDERS build
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

# Cleanup
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "src")
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "tmp")
