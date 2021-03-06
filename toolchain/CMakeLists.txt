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

# Set the number of parallel jobs to use.
ProcessorCount(LLVM_PARALLEL_COMPILE_JOBS)
ProcessorCount(LLVM_PARALLEL_LINK_JOBS)

# Identify the number of cores we can use.
ProcessorCount(N)
if(NOT N EQUAL 0)
    set(JOB_FLAGS -j${N})
endif()

# Binutils settings
set(BINUTILS_URL "ftp://ftp.gnu.org/gnu/binutils/binutils-2.25.1.tar.bz2")
set(BINUTILS_HASH "ac493a78de4fee895961d025b7905be4")
set(BINUTILS_PATCH "${CMAKE_CURRENT_SOURCE_DIR}/patches/binutils-2.25.1.patch")

# Newlib settings
set(NEWLIB_URL "ftp://sourceware.org/pub/newlib/newlib-2.3.0.20160104.tar.gz")
set(NEWLIB_HASH "4fa79de240d1d3556ca0e3e83d197636")
set(NEWLIB_PATCH "${CMAKE_CURRENT_SOURCE_DIR}/patches/newlib-2.3.0.patch")

# LLVM settings
set(LLVM_URL "http://llvm.org/releases/3.7.1/llvm-3.7.1.src.tar.xz")
set(LLVM_HASH "bf8b3a2c79e61212c5409041dfdbd319")
set(LLVM_PATCH "${CMAKE_CURRENT_SOURCE_DIR}/patches/llvm-3.7.1.patch")

# Clang settings
set(CLANG_URL "http://llvm.org/releases/3.7.1/cfe-3.7.1.src.tar.xz")
set(CLANG_HASH "0acd026b5529164197563d135a8fd83e")
set(CLANG_PATCH "${CMAKE_CURRENT_SOURCE_DIR}/patches/clang-3.7.1.patch")

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

# Use Ninja when available.
find_program(NINJA_EXECUTABLE ninja)
if(NINJA_EXECUTABLE)
    set(LLVM_GENERATOR "Ninja")
    set(CLANG_GENERATOR "Ninja")
else()
    set(LLVM_GENERATOR "Unix Makefiles")
    set(CLANG_GENERATOR "Unix Makefiles")
endif()

# Binutils target
ExternalProject_Add(binutils
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}
    INSTALL_DIR ${OPENCTR_ROOT}
    URL "${BINUTILS_URL}"
    URL_HASH "MD5=${BINUTILS_HASH}"
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
        "CFLAGS=-w -O2 ${TRAVIS_CFLAGS}"
        "CXXFLAGS=-w -O2 ${TRAVIS_CXXFLAGS}"
        ${AUTOCONF_ARGS}
    BUILD_COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS}
    INSTALL_COMMAND ${MAKE_EXECUTABLE} install
    LOG_DOWNLOAD ${ENABLE_LOG}
    LOG_CONFIGURE ${ENABLE_LOG}
    LOG_BUILD ${ENABLE_LOG}
    LOG_INSTALL ${ENABLE_LOG}
)

# LLVM target
ExternalProject_Add(llvm
    DEPENDS binutils
	PREFIX ${CMAKE_CURRENT_BINARY_DIR}
	INSTALL_DIR ${OPENCTR_ROOT}
	URL "${LLVM_URL}"
	URL_HASH "MD5=${LLVM_HASH}"
    PATCH_COMMAND ${PATCH_EXECUTABLE} --strip=1 --quiet
        --input=${LLVM_PATCH} --directory=<SOURCE_DIR>
	CMAKE_ARGS
		-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
		-DCMAKE_BUILD_TYPE=Release
        -DCMAKE_JOB_POOL_COMPILE=${LLVM_PARALLEL_COMPILE_JOBS}
        -DCMAKE_JOB_POOL_LINK=${LLVM_PARALLEL_LINK_JOBS}
		-DLLVM_DEFAULT_TARGET_TRIPLE=arm-none-eabi
		-DLLVM_TARGETS_TO_BUILD=ARM
        -DLLVM_TARGET_ARCH=ARM
        -DLLVM_INCLUDE_DOCS=OFF
        -DLLVM_INCLUDE_EXAMPLES=OFF
        -DLLVM_INCLUDE_TESTS=OFF
        -DLLVM_INCLUDE_UTILS=OFF
        -DLLVM_BUILD_UTILS=OFF
		-DLLVM_PARALLEL_COMPILE_JOBS=${LLVM_PARALLEL_COMPILE_JOBS}
		-DLLVM_PARALLEL_LINK_JOBS=${LLVM_PARALLEL_LINK_JOBS}
		-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
        -DLLVM_ENABLE_BINDINGS=OFF
        -DBUILD_SHARED_LIBS=OFF
        ${CMAKE_ARGS}
    CMAKE_GENERATOR "${LLVM_GENERATOR}"
	LOG_DOWNLOAD ${ENABLE_LOG}
	LOG_CONFIGURE ${ENABLE_LOG}
	LOG_BUILD ${ENABLE_LOG}
	LOG_INSTALL ${ENABLE_LOG}
)

ExternalProject_Get_Property(llvm binary_dir)		
set(LLVM_CONFIG_EXECUTABLE ${binary_dir}/bin/llvm-config)

# Clang target
ExternalProject_Add(clang
	DEPENDS llvm
	PREFIX ${CMAKE_CURRENT_BINARY_DIR}
	INSTALL_DIR ${OPENCTR_ROOT}
    URL "${CLANG_URL}"
	URL_HASH "MD5=${CLANG_HASH}"
    PATCH_COMMAND ${PATCH_EXECUTABLE} --strip=1 --quiet
        --input=${CLANG_PATCH} --directory=<SOURCE_DIR>
	CMAKE_ARGS
		-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_PREFIX_PATH=<INSTALL_DIR>
		-DCMAKE_PROGRAM_PATH=<INSTALL_DIR>/bin
		-DCLANG_PLUGIN_SUPPORT=ON
		-DCLANG_BUILD_EXAMPLES=OFF
		-DCLANG_ENABLE_STATIC_ANALYZER=OFF
		-DCLANG_ENABLE_ARCMT=OFF
        -DCLANG_ENABLE_DIAGTOOL=OFF
        -DCLANG_ENABLE_CLANGFORMAT=OFF
        -DCLANG_ENABLE_CLANGFUZZER=OFF
        -DCLANG_ENABLE_CINDEXTEST=OFF
		-DLLVM_CONFIG=${LLVM_CONFIG_EXECUTABLE}
		-DLLVM_INCLUDE_TESTS=OFF
		-DLLVM_INCLUDE_DOCS=OFF
		-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
		-DGCC_INSTALL_PREFIX=<INSTALL_DIR>
        ${CMAKE_ARGS}
    CMAKE_GENERATOR "${CLANG_GENERATOR}"
	LOG_DOWNLOAD ${ENABLE_LOG}
	LOG_CONFIGURE ${ENABLE_LOG}
	LOG_BUILD ${ENABLE_LOG}
	LOG_INSTALL ${ENABLE_LOG}
)

# Newlib target
ExternalProject_Add(newlib
    DEPENDS clang
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}
    INSTALL_DIR ${OPENCTR_ROOT}
    URL "${NEWLIB_URL}"
    URL_HASH "MD5=${NEWLIB_HASH}"
    PATCH_COMMAND ${PATCH_EXECUTABLE} --strip=1 --quiet
        --input=${NEWLIB_PATCH} --directory=<SOURCE_DIR>
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
        --prefix=<INSTALL_DIR>
        --target=arm-none-eabi
        --disable-newlib-supplied-syscalls
        --disable-multilib
        --enable-newlib-mb
        --with-build-time-tools=<INSTALL_DIR>/bin
        "PATH=$ENV{PATH}:<INSTALL_DIR>/bin"
        "CC_FOR_TARGET=<INSTALL_DIR>/bin/clang"
        "GCC_FOR_TARGET=<INSTALL_DIR>/bin/clang"
        "CXX_FOR_TARGET=<INSTALL_DIR>/bin/clang++"
        "CFLAGS_FOR_TARGET=-ffreestanding -isystem <INSTALL_DIR>/arm-none-eabi/include"
        ${AUTOCONF_ARGS}
    BUILD_COMMAND ${MAKE_EXECUTABLE}
        PATH=$ENV{PATH}:<INSTALL_DIR>/bin
    INSTALL_COMMAND ${MAKE_EXECUTABLE} install
        PATH=$ENV{PATH}:<INSTALL_DIR>/bin
    LOG_DOWNLOAD ${ENABLE_LOG}
    LOG_CONFIGURE ${ENABLE_LOG}
    LOG_BUILD ${ENABLE_LOG}
    LOG_INSTALL ${ENABLE_LOG}
)

# Cleanup
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "src")
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "tmp")
