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

# LLVM settings
set(LLVM_URL "http://llvm.org/releases/3.6.0/llvm-3.6.0.src.tar.xz")
set(LLVM_HASH "b39a69e501b49e8f73ff75c9ad72313681ee58d6f430bfad4d81846fe92eb9ce")

# Clang settings
set(CLANG_URL "http://llvm.org/releases/3.6.0/cfe-3.6.0.src.tar.xz")
set(CLANG_HASH "be0e69378119fe26f0f2f74cffe82b7c26da840c9733fe522ed3c1b66b11082d")

# LLVM target
ExternalProject_Add(llvm
	PREFIX ${CMAKE_CURRENT_BINARY_DIR}
	INSTALL_DIR ${OPENCTR_ROOT}
	URL "${LLVM_URL}"
	URL_HASH "SHA256=${LLVM_HASH}"
	CMAKE_ARGS 
		-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
		-DCMAKE_BUILD_TYPE=Release
        -DCMAKE_JOB_POOL_COMPILE=${LLVM_PARALLEL_COMPILE_JOBS}
        -DCMAKE_JOB_POOL_LINK=${LLVM_PARALLEL_LINK_JOBS}
		-DBUILD_SHARED_LIBS=OFF
		-DLLVM_DEFAULT_TARGET_TRIPLE=arm-none-eabi
		-DLLVM_TARGETS_TO_BUILD=ARM
        -DLLVM_TARGET_ARCH=ARM
        -DLLVM_BUILD_TOOLS=ON
		-DLLVM_BUILD_RUNTIME=OFF
		-DLLVM_BUILD_EXAMPLES=OFF
		-DLLVM_BUILD_TESTS=OFF
        -DLLVM_BUILD_DOCS=OFF
		-DLLVM_PARALLEL_COMPILE_JOBS=${LLVM_PARALLEL_COMPILE_JOBS}
		-DLLVM_PARALLEL_LINK_JOBS=${LLVM_PARALLEL_LINK_JOBS}
		-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
        ${CMAKE_ARGS}
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
	URL_HASH "SHA256=${CLANG_HASH}"
	CMAKE_ARGS
		-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_PREFIX_PATH=<INSTALL_DIR>
		-DCMAKE_PROGRAM_PATH=<INSTALL_DIR>/bin
        -DCMAKE_JOB_POOL_COMPILE=${LLVM_PARALLEL_COMPILE_JOBS}
        -DCMAKE_JOB_POOL_LINK=${LLVM_PARALLEL_LINK_JOBS}
		-DGCC_INSTALL_PREFIX=<INSTALL_DIR>
		-DLLVM_INCLUDE_TESTS=OFF
		-DLLVM_INCLUDE_DOCS=OFF
		-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
		-DCLANG_PLUGIN_SUPPORT=ON
		-DCLANG_BUILD_EXAMPLES=OFF
		-DCLANG_ENABLE_STATIC_ANALYZER=OFF
		-DCLANG_ENABLE_ARCMT=OFF
		-DLLVM_CONFIG=${LLVM_CONFIG_EXECUTABLE}
        ${CMAKE_ARGS}
	LOG_DOWNLOAD ${ENABLE_LOG}
	LOG_CONFIGURE ${ENABLE_LOG}
	LOG_BUILD ${ENABLE_LOG}
	LOG_INSTALL ${ENABLE_LOG}
)

# Cleanup
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "src")
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "tmp")
