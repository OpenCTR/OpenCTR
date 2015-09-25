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

# Set the number of parallel jobs to use.
ProcessorCount(LLVM_PARALLEL_COMPILE_JOBS)
ProcessorCount(LLVM_PARALLEL_LINK_JOBS)

# LLVM target
ExternalProject_Add(llvm
	DEPENDS binutils
	PREFIX ${CMAKE_CURRENT_BINARY_DIR}
	INSTALL_DIR ${OPENCTR_ROOT}
	URL "${LLVM_URL}"
	URL_HASH "SHA256=${LLVM_HASH}"
	CMAKE_ARGS 
		-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> 
		-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} 
		-DBUILD_SHARED_LIBS=OFF
		-DLLVM_DEFAULT_TARGET_TRIPLE=arm-none-eabi 
		-DLLVM_TARGETS_TO_BUILD=ARM
		-DLLVM_BUILD_RUNTIME=OFF 
		-DLLVM_BUILD_TOOLS=ON 
		-DLLVM_BUILD_EXAMPLES=OFF 
		-DLLVM_BUILD_TESTS=OFF 
		-DLLVM_TARGET_ARCH=ARM
		-DLLVM_BUILD_DOCS=OFF 
		-DLLVM_PARALLEL_COMPILE_JOBS=${LLVM_PARALLEL_COMPILE_JOBS}
		-DLLVM_PARALLEL_LINK_JOBS=${LLVM_PARALLEL_LINK_JOBS}
		-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
	LOG_DOWNLOAD TRUE
	LOG_CONFIGURE TRUE
	LOG_BUILD TRUE
	LOG_INSTALL TRUE
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
		-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} 
		-DCMAKE_PREFIX_PATH=<INSTALL_DIR> 
		-DCMAKE_PROGRAM_PATH=<INSTALL_DIR>/bin
		-DGCC_INSTALL_PREFIX=<INSTALL_DIR>
		-DLLVM_INCLUDE_TESTS=OFF 
		-DLLVM_INCLUDE_DOCS=OFF 
		-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
		-DCLANG_PLUGIN_SUPPORT=ON 
		-DCLANG_BUILD_EXAMPLES=OFF 
		-DCLANG_ENABLE_STATIC_ANALYZER=OFF
		-DCLANG_ENABLE_ARCMT=OFF
		-DLLVM_CONFIG=${LLVM_CONFIG_EXECUTABLE}
	LOG_DOWNLOAD TRUE
	LOG_CONFIGURE TRUE
	LOG_BUILD TRUE
	LOG_INSTALL TRUE
)

# Cleanup
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "src")
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "tmp")
