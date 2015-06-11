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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License 
# along with OpenCTR. If not, see <http://www.gnu.org/licenses/>.
####################################################################

cmake_minimum_required(VERSION 3.0.0)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/CMake)

if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE "Debug" CACHE INTERNAL "Build configuration")
endif()

include(CMakePackageConfigHelpers)

project(OpenCTR NONE)

option(ENABLE_DOC "Enable/Disable building Sphinx documentation" OFF)
option(ENABLE_LIBCTRU "Enable/Disable building libctru" ON)
option(ENABLE_GCC "Enable/Disable GCC toolchain" ON)
option(ENABLE_LLVM "Enable/Disable LLVM/Clang toolchain" OFF)

# Disable install messages
set(CMAKE_INSTALL_MESSAGE "NEVER")

# OpenCTR build settings
set(OPENCTR_VERSION 1.0.0)
set(OPENCTR_INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/install")

# Configure openctr-config.cmake
configure_package_config_file(
	${CMAKE_CURRENT_SOURCE_DIR}/CMake/openctr-config.cmake.in
	${OPENCTR_INSTALL_DIR}/lib/cmake/OpenCTR/openctr-config.cmake
	INSTALL_DESTINATION lib/cmake/OpenCTR
	INSTALL_PREFIX ${OPENCTR_INSTALL_DIR}
)

# Configure openctr-macros.cmake
configure_package_config_file(
	${CMAKE_CURRENT_SOURCE_DIR}/CMake/openctr-macros.cmake.in
	${OPENCTR_INSTALL_DIR}/lib/cmake/OpenCTR/openctr-macros.cmake
	INSTALL_DESTINATION lib/cmake/OpenCTR
	INSTALL_PREFIX ${OPENCTR_INSTALL_DIR}
)

# Create openctr-config-version.cmake
write_basic_package_version_file(
	${OPENCTR_INSTALL_DIR}/lib/cmake/OpenCTR/openctr-config-version.cmake
	COMPATIBILITY AnyNewerVersion 
	VERSION ${OPENCTR_VERSION}
)

if(ENABLE_DOC)
	add_subdirectory(doc)
endif()

add_subdirectory(toolchain)
add_subdirectory(tools)
add_subdirectory(projects)
add_subdirectory(crt0)

# Install OpenCTR
install(DIRECTORY ${OPENCTR_INSTALL_DIR}/
	DESTINATION OpenCTR
	USE_SOURCE_PERMISSIONS
	PATTERN ".*" EXCLUDE
)

# Cleanup
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "install")

# CPack Settings
set(PROJECT_CONTACT "https://github.com/OpenCTR")
set(PROJECT_DESCRIPTION "Free SDK for the Nintendo 3DS")
set(PROJECT_VENDOR "OpenCTR")
set(PROJECT_README ${CMAKE_CURRENT_SOURCE_DIR}/README.rst)
set(PROJECT_LICENSE ${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.txt)
set(PROJECT_LICENSE_NAME "GPLv3")
set(PROJECT_HOMEPAGE "https://github.com/OpenCTR")
set(PROJECT_VERSION ${OPENCTR_VERSION})

include(CPack)
