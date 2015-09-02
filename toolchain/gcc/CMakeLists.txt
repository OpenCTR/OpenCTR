####################################################################
# OpenCTR - A free and open-source SDK for Nintendo 3DS homebrew. 
# 
# Copyright (C) 2015 The OpenCTR Project. 
# 
# This file is part of OpenCTR. 
# 
# OpenCTR is free software: you can redistribute it and/or modify 
# it under the terms of the GNU General Public License version 3 as 
# published by the Free Software Foundation.
# 
# OpenCTR is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License 
# along with OpenCTR. If not, see <http://www.gnu.org/licenses/>.
####################################################################

include(ExternalProject)

# GCC target
ExternalProject_Add(gcc
    DEPENDS binutils
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}
    INSTALL_DIR ${OPENCTR_ROOT}
    URL "${GCC_URL}"
    URL_HASH "SHA256=${GCC_HASH}"
    DOWNLOAD_NO_PROGRESS TRUE
    PATCH_COMMAND ${PATCH_EXECUTABLE} --strip=1 --quiet --input=${GCC_PATCH} --directory=<SOURCE_DIR>
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
        --enable-threads
        --disable-win32-registry
        --with-newlib
        --without-headers
        --enable-lto
        --enable-multilib
        --with-endian=little
        --with-arch=armv6k
    BUILD_COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS}
    INSTALL_COMMAND ${MAKE_EXECUTABLE} install
    LOG_DOWNLOAD TRUE
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_INSTALL TRUE
)

# Newlib target
ExternalProject_Add(newlib
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}
    INSTALL_DIR ${OPENCTR_ROOT}
    EXCLUDE_FROM_ALL TRUE
    URL "${NEWLIB_URL}"
    URL_HASH "SHA256=${NEWLIB_HASH}"
    DOWNLOAD_NO_PROGRESS TRUE
    PATCH_COMMAND ${PATCH_EXECUTABLE} --strip=1 --quiet --input=${NEWLIB_PATCH} --directory=<SOURCE_DIR>
    CONFIGURE_COMMAND <SOURCE_DIR>/configure 
        --prefix=<INSTALL_DIR> 
        --target=arm-none-eabi 
        --disable-newlib-supplied-syscalls 
        --enable-newlib-mb 
        --enable-multilib
        "PATH=<INSTALL_DIR>/bin:$ENV{PATH}"
    BUILD_COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS}
        PATH=<INSTALL_DIR>/bin:$ENV{PATH}
    INSTALL_COMMAND ${MAKE_EXECUTABLE} install
        PATH=<INSTALL_DIR>/bin:$ENV{PATH}
    LOG_DOWNLOAD TRUE
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_INSTALL TRUE
)

# Dependency Injection: Require "make all-gcc" after "configure"
ExternalProject_Add_Step(gcc all-gcc
    COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS} all-gcc
    DEPENDEES configure
    WORKING_DIRECTORY <BINARY_DIR>
    LOG TRUE
)

# Dependency Injection: Require "make install-gcc" after "all-gcc"
ExternalProject_Add_Step(gcc install-gcc
    COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS} install-gcc
    DEPENDEES all-gcc
    WORKING_DIRECTORY <BINARY_DIR>
    LOG TRUE
)

# Dependency Injection: Make GCC 'build' stage depend on Newlib
ExternalProject_Add_Step(gcc newlib
    COMMAND ${CMAKE_MAKE_PROGRAM} newlib
    DEPENDEES install-gcc
    DEPENDERS build
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

# Add GCC to the toolchain targets
add_dependencies(toolchain gcc)

# Cleanup
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "src")
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "tmp")

