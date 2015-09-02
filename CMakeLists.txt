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

cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)
cmake_policy(SET CMP0048 NEW)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/CMake)
set(CMAKE_BUILD_TYPE_INIT "Debug")
set(CMAKE_INSTALL_MESSAGE "NEVER")
set(OPENCTR_ROOT "${CMAKE_CURRENT_BINARY_DIR}/install")

include(CMakePackageConfigHelpers)
include(Setup)

project(OpenCTR LANGUAGES NONE VERSION 0.0.1)

option(ENABLE_DOC "Build Sphinx documentation." OFF)
option(ENABLE_LIBCTRU "Build libctru." ON)
option(ENABLE_LIBCTR "Build libctru." ON)
option(ENABLE_GCC "Build the GCC toolchain." ON)
option(ENABLE_LLVM "Build the LLVM/Clang toolchain." OFF)

# Configure OpenCTR.cmake
configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/CMake/OpenCTR.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/OpenCTR.cmake
    INSTALL_DESTINATION ${CMAKE_ROOT}/Modules
)

# Configure openctr-config.cmake
configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/CMake/openctr-config.cmake.in
    ${OPENCTR_ROOT}/lib/cmake/OpenCTR/openctr-config.cmake
    INSTALL_DESTINATION lib/cmake/OpenCTR
    INSTALL_PREFIX ${OPENCTR_ROOT}
)

# Configure openctr-macros.cmake
configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/CMake/openctr-macros.cmake.in
    ${OPENCTR_ROOT}/lib/cmake/OpenCTR/openctr-macros.cmake
    INSTALL_DESTINATION lib/cmake/OpenCTR
    INSTALL_PREFIX ${OPENCTR_ROOT}
)

# Copy OpenCTR-Toolchain.cmake
file(COPY CMake/OpenCTR-Toolchain.cmake
    DESTINATION ${OPENCTR_ROOT}/lib/cmake/OpenCTR)

# Create openctr-config-version.cmake
write_basic_package_version_file(
    ${OPENCTR_ROOT}/lib/cmake/OpenCTR/openctr-config-version.cmake
    COMPATIBILITY AnyNewerVersion 
    VERSION ${PROJECT_VERSION}
)

if(ENABLE_DOC)
    add_subdirectory(doc)
endif()

add_subdirectory(toolchain)
add_subdirectory(tools)
add_subdirectory(projects)
add_subdirectory(crt0)

# Install OpenCTR
install(DIRECTORY ${OPENCTR_ROOT}/
    DESTINATION OpenCTR
    USE_SOURCE_PERMISSIONS
    PATTERN ".*" EXCLUDE
)

# Install OpenCTR.cmake
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/OpenCTR.cmake
    DESTINATION ${CMAKE_ROOT}/Modules)

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
set(PROJECT_VERSION ${PROJECT_VERSION})

include(CPack)
