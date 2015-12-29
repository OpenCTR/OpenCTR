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

cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)
cmake_policy(SET CMP0048 NEW)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/CMake)
set(CMAKE_BUILD_TYPE_INIT "Debug")
set(CMAKE_INSTALL_MESSAGE "NEVER")
set(OPENCTR_ROOT "${CMAKE_CURRENT_BINARY_DIR}/install")

include(CMakePackageConfigHelpers)

project(OpenCTR LANGUAGES NONE VERSION 0.0.1)

option(ENABLE_DOC "Build Sphinx documentation" OFF)
option(ENABLE_TOOLCHAIN "Build the LLVM/Clang toolchain" ON)
option(ENABLE_TOOLS "Build the OpenCTR tools" ON)
option(ENABLE_LIBCTR "Build libctru" ON)

set(ENABLE_LOG ON)

if($ENV{TRAVIS} STREQUAL "true")
    set(ENABLE_LOG OFF)

    if(APPLE)
        list(APPEND AUTOCONF_ARGS "\"CC=/usr/bin/clang\"")
        list(APPEND AUTOCONF_ARGS "\"CXX=/usr/bin/clang++\"")
        list(APPEND CMAKE_ARGS "-DCMAKE_C_COMPILER=/usr/bin/clang")
        list(APPEND CMAKE_ARGS "-DCMAKE_CXX_COMPILER=/usr/bin/clang++")
    elseif(UNIX)
        list(APPEND AUTOCONF_ARGS "\"CC=/usr/bin/clang-3.6\"")
        list(APPEND AUTOCONF_ARGS "\"CXX=/usr/bin/clang++-3.6\"")
        list(APPEND CMAKE_ARGS "-DCMAKE_C_COMPILER=/usr/bin/clang-3.6")
        list(APPEND CMAKE_ARGS "-DCMAKE_CXX_COMPILER=/usr/bin/clang++-3.6")
    endif()
endif()


# Configure CTRConfig.cmake
configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/CMake/CTRConfig.cmake.in
    ${OPENCTR_ROOT}/lib/cmake/CTR/CTRConfig.cmake
    INSTALL_DESTINATION lib/cmake/CTR
)

# Copy CTRMacros.cmake and CTRToolchain.cmake
file(COPY CMake/CTRMacros.cmake CMake/CTRToolchain.cmake
    DESTINATION ${OPENCTR_ROOT}/lib/cmake/CTR)

# Create CTRConfigVersion.cmake
write_basic_package_version_file(
    ${OPENCTR_ROOT}/lib/cmake/CTR/CTRConfigVersion.cmake
    COMPATIBILITY AnyNewerVersion 
    VERSION ${PROJECT_VERSION}
)

if(ENABLE_DOC)
    add_subdirectory(doc)
endif()

if(ENABLE_TOOLCHAIN)
    add_subdirectory(toolchain)
endif()

if(ENABLE_TOOLS)
    add_subdirectory(tools)
endif()

if(ENABLE_LIBCTR)
    add_subdirectory(projects)
endif()

#add_subdirectory(crt0)

# Install OpenCTR
install(DIRECTORY ${OPENCTR_ROOT}/
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
set(PROJECT_LICENSE ${CMAKE_CURRENT_SOURCE_DIR}/COPYING.txt)
set(PROJECT_LICENSE_NAME "GPLv3")
set(PROJECT_HOMEPAGE "https://github.com/OpenCTR")
set(PROJECT_VERSION ${PROJECT_VERSION})

include(CPack)
