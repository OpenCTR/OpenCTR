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

cmake_minimum_required(VERSION 2.8)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE "Debug" CACHE INTERNAL "Debug/Release/RelWithDebInfo/MinSizeRel")
endif()

include(CMakePackageConfigHelpers)

project(OpenCTR NONE)

option(ENABLE_LOG "Enable/Disable using logs to store all status and error messages" ON)
option(ENABLE_DOC "Enable/Disable building Sphinx documentation" OFF)
option(ENABLE_LIBCTRU "Enable/Disable building libctru" ON)

# We are installing several **hundred** files, it is a *much* cleaner 
# experience without install status messages.
set(CMAKE_INSTALL_MESSAGE "NEVER")

# Adjust where CMake packages are installed to.
if(WIN32)
	set(CMAKE_PREFIX "CMake")
else()
	set(CMAKE_PREFIX "share/cmake")
endif()

if(ENABLE_DOC)
	add_subdirectory(doc)
endif()

add_subdirectory(toolchain)
add_subdirectory(tools)
add_subdirectory(projects)

# Configure CTR_ROOT.cmake.in
configure_package_config_file(
	${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/CTR_ROOT.cmake.in
	${CMAKE_CURRENT_BINARY_DIR}/CTR_ROOT.cmake
	INSTALL_DESTINATION ${CMAKE_PREFIX}
)

# Install CTR_ROOT.cmake
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/CTR_ROOT.cmake 
	DESTINATION OpenCTR/${CMAKE_PREFIX}
	COMPONENT cmake
)

# Install CMake Modules
install(DIRECTORY cmake/Modules/
	DESTINATION OpenCTR/${CMAKE_PREFIX}
	COMPONENT cmake
	USE_SOURCE_PERMISSIONS
	REGEX "^\\..*$;^.*\\.in$;^CMake.*\\.cmake$;^Find.*\\.cmake$" EXCLUDE
)

# CPack Settings
set(PROJECT_CONTACT "https://github.com/OpenCTR")
set(PROJECT_DESCRIPTION "Free and Open-Source Software Development Kit for the Nintendo 3DS.")
set(PROJECT_ABOUT ${CMAKE_CURRENT_SOURCE_DIR}/README.rst)
set(PROJECT_README ${CMAKE_CURRENT_SOURCE_DIR}/README.rst)
set(PROJECT_VENDOR "OpenCTR")
set(PROJECT_LICENSE ${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.txt)
set(PROJECT_LICENSE_NAME "GPLv3")
set(PROJECT_HOMEPAGE "https://github.com/OpenCTR")
set(PROJECT_VERSION_MAJOR 1)
set(PROJECT_VERSION_MINOR 0)
set(PROJECT_VERSION_PATCH 0)
set(PROJECT_VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH})

include(CPack)
