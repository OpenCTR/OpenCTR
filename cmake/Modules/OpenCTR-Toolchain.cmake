#.rst:
# OpenCTR-Toolchain
# -----------------
# 
# CMake toolchain for enabling OpenCTR support.
# 

######################################################################
# This file is part of OpenCTR.
# 
# OpenCTR is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# OpenCTR is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with OpenCTR.  If not, see <http://www.gnu.org/licenses/>.
######################################################################

if(NOT CTR_ROOT)
	get_filename_component(CTR_ROOT_CMAKE "${CMAKE_CURRENT_LIST_DIR}/CTR_ROOT.cmake" ABSOLUTE)
	include(${CTR_ROOT_CMAKE})
endif()

find_program(ARM_EABI_GCC arm-none-eabi-gcc PATHS ${CTR_ROOT} PATH_SUFFIXES bin)
if(NOT ARM_EABI_GCC)
	message(FATAL_ERROR "OpenCTR-Toolchain: arm-none-eabi-gcc not found")
endif()

find_program(ARM_EABI_GXX arm-none-eabi-g++ PATHS ${CTR_ROOT} PATH_SUFFIXES bin)
if(NOT ARM_EABI_GXX)
	message(FATAL_ERROR "OpenCTR-Toolchain: arm-none-eabi-g++ not found")
endif()

set(CMAKE_SYSTEM_NAME "CTR")
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR "ARM")

include(CMakeForceCompiler)

cmake_force_c_compiler(${ARM_EABI_GCC} GNU)
cmake_force_cxx_compiler(${ARM_EABI_GXX} GNU)

set(CMAKE_FIND_ROOT_PATH "${CTR_ROOT}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
