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

include(ExternalProject)

# OpenCTR CMAKE_TOOLCHAIN_FILE
get_filename_component(OPENCTR_TOOLCHAIN_FILE "${CMAKE_CURRENT_SOURCE_DIR}/../cmake/Modules/OpenCTR-Toolchain.cmake" ABSOLUTE)

# OpenCTR CMAKE_PREFIX_PATH
ExternalProject_Get_Property(tools install_dir)
set(CTR_PREFIX_PATH ${install_dir}/${CMAKE_PREFIX})

# OpenCTR CMAKE_MODULE_PATH
get_filename_component(CTR_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../cmake/Modules" ABSOLUTE)

# libctru
if(ENABLE_LIBCTRU)
	# libctru target
	ExternalProject_Add(libctru
		DEPENDS tools gcc
		PREFIX ${CMAKE_CURRENT_BINARY_DIR}
		INSTALL_DIR install
		GIT_REPOSITORY "https://github.com/OpenCTR/libctru"
		GIT_TAG "master"
		CMAKE_ARGS 
			-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> 
			-DCMAKE_PREFIX_PATH=${CTR_PREFIX_PATH} 
			-DCMAKE_MODULE_PATH=${CTR_MODULE_PATH} 
			-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} 
			-DCMAKE_TOOLCHAIN_FILE=${OPENCTR_TOOLCHAIN_FILE} 
			-DCTR_ROOT=${CTR_ROOT} 
		LOG_DOWNLOAD TRUE
		LOG_CONFIGURE TRUE
		LOG_BUILD TRUE
		LOG_INSTALL TRUE
	)

	# Install libctru
	install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/install/libctru DESTINATION OpenCTR
		COMPONENT libctru
		USE_SOURCE_PERMISSIONS
	)
endif()

# Cleanup
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "src" "tmp" install)
