#.rst:
# CTRHost
# -------
#
# Determine the host operating system for OpenCTR. Configure settings according
# to this value.

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

if($ENV{CI} STREQUAL "true")
    set(ENABLE_LOG FALSE)

    if(APPLE)
        list(APPEND EXTRA_ARGS "CC=/usr/local/bin/gcc-5")
        list(APPEND EXTRA_ARGS "CXX=/usr/local/bin/g++-5")
    endif()
else()
    set(ENABLE_LOG TRUE)
endif()

if(NOT DEFINED OPENCTR_HOST)
    return()
endif()

if(NOT OPENCTR_HOST MATCHES "(Windows|OSX|Linux)")
    message(FATAL_ERROR "Unrecognized OPENCTR_HOST: ${OPENCTR_HOST}")
endif()

string(TOUPPER "${OPENCTR_HOST}" OPENCTR_HOST_NAME)
string(COMPARE EQUAL "${OPENCTR_HOST_NAME}" "LINUX" OPENCTR_HOST_LINUX)
string(COMPARE EQUAL "${OPENCTR_HOST_NAME}" "OSX" OPENCTR_HOST_OSX)
string(COMPARE EQUAL "${OPENCTR_HOST_NAME}" "WINDOWS" OPENCTR_HOST_WINDOWS)

if(OPENCTR_HOST_LINUX)
    set(TOOLCHAIN "${CMAKE_CURRENT_LIST_DIR}/Toolchain/Linux.cmake")
    list(APPEND AUTOTOOLS_FLAGS "--host=x86_64-linux-gnu")
elseif(OPENCTR_HOST_OSX)
    set(TOOLCHAIN "${CMAKE_CURRENT_LIST_DIR}/Toolchain/OSX.cmake")
    list(APPEND AUTOTOOLS_FLAGS "--host=x86_64-apple-darwin")
elseif(OPENCTR_HOST_WINDOWS)
    set(TOOLCHAIN "${CMAKE_CURRENT_LIST_DIR}/Toolchain/Windows.cmake")
    list(APPEND AUTOTOOLS_FLAGS "--host=x86_64-w64-mingw32")
endif()

list(APPEND CMAKE_FLAGS "-DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN}")
