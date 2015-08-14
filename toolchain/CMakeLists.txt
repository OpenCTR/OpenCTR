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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License 
# along with OpenCTR. If not, see <http://www.gnu.org/licenses/>.
####################################################################

include(ProcessorCount)

if((NOT ENABLE_GCC) AND (NOT ENABLE_LLVM))
	message(SEND_ERROR "ENABLE_GCC and/or ENABLE_LLVM must be enabled.")
endif()

# Identify the number of cores we can use.
ProcessorCount(N)
if(NOT N EQUAL 0)
	set(JOB_FLAGS -j${N})
endif()

# Require GNU Make for building Autotools projects
find_program(MAKE_EXECUTABLE make)
if(NOT MAKE_EXECUTABLE)
	message(SEND_ERROR "GNU Make not found")
endif()

# Require GNU Patch for patching downloaded sources
find_program(PATCH_EXECUTABLE patch)
if(NOT PATCH_EXECUTABLE)
	message(SEND_ERROR "GNU Patch not found")
endif()

# Binutils settings
set(BINUTILS_PATCH "${CMAKE_CURRENT_SOURCE_DIR}/patches/binutils-2.25.patch")
set(BINUTILS_URL "ftp://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.bz2")
set(BINUTILS_HASH "22defc65cfa3ef2a3395faaea75d6331c6e62ea5dfacfed3e2ec17b08c882923")

# GCC settings
set(GCC_URL "ftp://ftp.gnu.org/gnu/gcc/gcc-4.9.2/gcc-4.9.2.tar.bz2")
set(GCC_HASH "2020c98295856aa13fda0f2f3a4794490757fc24bcca918d52cc8b4917b972dd")
set(GCC_PATCH "${CMAKE_CURRENT_SOURCE_DIR}/patches/gcc-4.9.2.patch")

# Newlib settings
set(NEWLIB_URL "ftp://sourceware.org/pub/newlib/newlib-2.2.0.tar.gz")
set(NEWLIB_HASH "f8add263b0737591aff451b12a00c262c2efac4fa87d741fa1c318fc3bb335be")
set(NEWLIB_PATCH "${CMAKE_CURRENT_SOURCE_DIR}/patches/newlib-2.2.0.patch")

# LLVM settings
set(LLVM_URL "http://llvm.org/releases/3.6.0/llvm-3.6.0.src.tar.xz")
set(LLVM_HASH "b39a69e501b49e8f73ff75c9ad72313681ee58d6f430bfad4d81846fe92eb9ce")

# Clang settings
set(CLANG_URL "http://llvm.org/releases/3.6.0/cfe-3.6.0.src.tar.xz")
set(CLANG_HASH "be0e69378119fe26f0f2f74cffe82b7c26da840c9733fe522ed3c1b66b11082d")

# Create a toolchain CMake target
add_custom_target(toolchain ALL)

# Add binutils target
add_subdirectory(binutils)

# Add GCC target
if(ENABLE_GCC)
	add_subdirectory(gcc)
endif()

# Add LLVM target
if(ENABLE_LLVM)
	add_subdirectory(llvm)
endif()
