################################################################################
# OpenCTR - A free and open-source SDK for Nintendo 3DS homebrew.
#
# Copyright (C) 2015, OpenCTR Contributors.
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

# Binutils target
ExternalProject_Add(binutils
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}
    INSTALL_DIR ${OPENCTR_ROOT}
    URL "${BINUTILS_URL}"
    URL_HASH "SHA256=${BINUTILS_HASH}"
    PATCH_COMMAND ${PATCH_EXECUTABLE} --strip=1 --quiet --input=${BINUTILS_PATCH} --directory=<SOURCE_DIR> 
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
        --prefix=<INSTALL_DIR>
        --target=arm-none-eabi
        --disable-nls
        --disable-shared
        --disable-debug
        --disable-dependency-tracking
        --disable-werror
        --disable-bootstrap
        --enable-checking=release
        --enable-lto
        --enable-plugins
        --enable-gold=yes
        --enable-ld=default
        --enable-poison-system-directories
        --enable-install-libbfd
        --enable-build-with-cxx
        --enable-interworks
        --enable-nlsi=no
    BUILD_COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS}
    INSTALL_COMMAND ${MAKE_EXECUTABLE} install
    LOG_DOWNLOAD TRUE
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_INSTALL TRUE
)

# Cleanup
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "src")
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "tmp")
