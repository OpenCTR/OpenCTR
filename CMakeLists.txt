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

cmake_minimum_required(VERSION 3.0.0)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE "Debug" CACHE INTERNAL "Values: Debug, Release, RelWithDebInfo, MinSizeRel")
endif()

project(OpenCTR NONE)

include(CMakeProjectSettings)
include(CMakeProjectVersion)

include(ExternalProject)

option(ENABLE_DOC "Enable/Disable building OpenCTR-Doc" OFF)
option(ENABLE_TOOLS "Enable/Disable building OpenCTR-Tools" ON)
option(ENABLE_TOOLCHAIN "Enable/Disable building OpenCTR-Doc" ON)
option(ENABLE_LIBCTR "Enable/Disable building libctr" ON)

if(ENABLE_DOC)
	ExternalProject_Add(doc 
		PREFIX ${CMAKE_CURRENT_BINARY_DIR}
		INSTALL_DIR install
		GIT_REPOSITORY https://github.com/OpenCTR/OpenCTR-Doc
		GIT_TAG "v1.0.0"
		CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
	)
endif()

if(ENABLE_TOOLCHAIN)
	ExternalProject_Add(toolchain 
		PREFIX ${CMAKE_CURRENT_BINARY_DIR}
		INSTALL_DIR install
		GIT_REPOSITORY https://github.com/OpenCTR/OpenCTR-Toolchain
		GIT_TAG "v1.0.0"
		CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
	)
endif()

set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "src" "tmp" "install")

install(
	DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/install/
	DESTINATION OpenCTR
	USE_SOURCE_PERMISSIONS
	MESSAGE_NEVER
)

