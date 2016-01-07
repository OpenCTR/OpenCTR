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
include(ProcessorCount)

# Identify the number of cores we can use.
ProcessorCount(N)
if(NOT N EQUAL 0)
    set(JOB_FLAGS -j${N})
endif()

# Binutils settings
set(BINUTILS_URL "ftp://ftp.gnu.org/gnu/binutils/binutils-2.25.1.tar.bz2")
set(BINUTILS_HASH "b5b14added7d78a8d1ca70b5cb75fef57ce2197264f4f5835326b0df22ac9f22")
set(BINUTILS_PATCH "${CMAKE_CURRENT_SOURCE_DIR}/patches/binutils-2.25.1.patch")

# GCC settings
set(GCC_URL "ftp://ftp.gnu.org/gnu/gcc/gcc-5.3.0/gcc-5.3.0.tar.bz2")
set(GCC_HASH "b84f5592e9218b73dbae612b5253035a7b34a9a1f7688d2e1bfaaf7267d5c4db")
set(GCC_PATCH "${CMAKE_CURRENT_SOURCE_DIR}/patches/gcc-5.3.0.patch")

# Newlib settings
set(NEWLIB_URL "ftp://sourceware.org/pub/newlib/newlib-2.2.0.tar.gz")
set(NEWLIB_HASH "f8add263b0737591aff451b12a00c262c2efac4fa87d741fa1c318fc3bb335be")
set(NEWLIB_PATCH "${CMAKE_CURRENT_SOURCE_DIR}/patches/newlib-2.2.0.patch")

# Require GNU Make for building Autotools projects
find_program(MAKE_EXECUTABLE make gmake)
if(NOT MAKE_EXECUTABLE)
	message(SEND_ERROR "GNU Make not found")
endif()

# Require GNU Patch for patching downloaded sources
find_program(PATCH_EXECUTABLE patch gpatch)
if(NOT PATCH_EXECUTABLE)
	message(SEND_ERROR "GNU Patch not found")
endif()

# Binutils target
ExternalProject_Add(binutils
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}
    INSTALL_DIR ${OPENCTR_ROOT}
    URL "${BINUTILS_URL}"
    URL_HASH "SHA256=${BINUTILS_HASH}"
    PATCH_COMMAND ${PATCH_EXECUTABLE} --strip=1 --quiet
        --input=${BINUTILS_PATCH} --directory=<SOURCE_DIR> 
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
        ${AUTOCONF_ARGS}
    BUILD_COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS}
    INSTALL_COMMAND ${MAKE_EXECUTABLE} install
    LOG_DOWNLOAD ${ENABLE_LOG}
    LOG_CONFIGURE ${ENABLE_LOG}
    LOG_BUILD ${ENABLE_LOG}
    LOG_INSTALL ${ENABLE_LOG}
)

# GCC target
ExternalProject_Add(gcc
    DEPENDS binutils
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}
    INSTALL_DIR ${OPENCTR_ROOT}
    URL "${GCC_URL}"
    URL_HASH "SHA256=${GCC_HASH}"
    PATCH_COMMAND ${PATCH_EXECUTABLE} --strip=1 --quiet
        --input=${GCC_PATCH} --directory=<SOURCE_DIR> 
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
        --prefix=<INSTALL_DIR>
        --target=arm-none-eabi
        --disable-nls
        --disable-shared
        --disable-debug
        --disable-dependency-tracking
        --disable-werror
        --disable-bootstrap
        --disable-multilib
        --disable-win32-registry
        --disable-libquadmath
        --disable-libada
        --disable-libssp
        --disable-liboffloadmic
        --disable-libsanitizer
        --disable-libgomp
        --disable-libvtv
        --enable-interwork
        --enable-languages=c,c++
        --enable-threads=single
        --enable-lto
        --without-headers
        --with-bugurl=https://github.com/OpenCTR/OpenCTR/issues
        --with-endian=little
        --with-arch=armv6k
        --with-newlib
        --with-system-zlib
        --with-gnu-as
        --with-gnu-ld
        --with-diagnostics-color=always
        "CFLAGS=\"-w\""
        "CXXFLAGS=\"-w\""
        ${AUTOCONF_ARGS}
    BUILD_COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS}
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
    PATCH_COMMAND ${PATCH_EXECUTABLE} --strip=1 --quiet
        --input=${NEWLIB_PATCH} --directory=<SOURCE_DIR> 
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
        --prefix=<INSTALL_DIR>
        --target=arm-none-eabi
        --disable-newlib-supplied-syscalls
        --enable-newlib-mb
        --enable-multilib
        "PATH=<INSTALL_DIR>/bin:$ENV{PATH}"
        ${AUTOCONF_ARGS}
    BUILD_COMMAND ${MAKE_EXECUTABLE}
        PATH=<INSTALL_DIR>/bin:$ENV{PATH}
    INSTALL_COMMAND ${MAKE_EXECUTABLE} install
        PATH=<INSTALL_DIR>/bin:$ENV{PATH}
    LOG_DOWNLOAD ${ENABLE_LOG}
    LOG_CONFIGURE ${ENABLE_LOG}
    LOG_BUILD ${ENABLE_LOG}
    LOG_INSTALL ${ENABLE_LOG}
)

# Do not build Newlib by default.
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
