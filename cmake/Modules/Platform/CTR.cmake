#.rst:
# Platform/CTR.cmake
# ------------------
# 
# Support for the Nintendo 3DS Operating System.
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
	get_filename_component(CTR_ROOT_CMAKE "${CMAKE_CURRENT_LIST_DIR}/../CTR_ROOT.cmake" ABSOLUTE)
	include(${CTR_ROOT_CMAKE})
endif()

set(CMAKE_EXECUTABLE_SUFFIX ".elf")
set(CMAKE_STATIC_LIBRARY_PREFIX "lib")
set(CMAKE_STATIC_LIBRARY_SUFFIX ".a")
set(CMAKE_SIZEOF_VOID_P "4")
set(CMAKE_STANDARD_LIBRARIES "-lc -lm")
set(CMAKE_LINK_LIBRARY_SUFFIX)
set(CMAKE_SHARED_LIBRARY_PREFIX)
set(CMAKE_SHARED_LIBRARY_SUFFIX)
set(CMAKE_DL_LIBS)
set(CMAKE_FIND_LIBRARY_PREFIXES "lib")
set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")

set(CMAKE_C_OUTPUT_EXTENSION ".o")
set(CMAKE_CXX_OUTPUT_EXTENSION ".o")
set(CMAKE_ASM_OUTPUT_EXTENSION ".o")

set(CTR_CFLAGS "-march=armv6k -mtune=mpcore -mfloat-abi=hard -mword-relocations -fno-strict-aliasing -fomit-frame-pointer -ffast-math")
set(CTR_CXXFLAGS "-march=armv6k -mtune=mpcore -mfloat-abi=hard -mword-relocations -fno-strict-aliasing -fomit-frame-pointer -ffast-math")
set(CTR_LDFLAGS "--specs=3dsx.specs")

set(CMAKE_C_FLAGS ${CTR_CFLAGS} CACHE INTERNAL "C Flags")
set(CMAKE_CXX_FLAGS ${CTR_CXXFLAGS} CACHE INTERNAL "C++ Flags")
set(CMAKE_EXE_LINKER_FLAGS ${CTR_LDFLAGS} CACHE INTERNAL "LD Flags")

set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS FALSE)

set(UNIX TRUE)
set(APPLE FALSE)
set(WIN32 FALSE)
set(CYGWIN FALSE)
