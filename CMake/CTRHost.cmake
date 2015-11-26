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

if(NOT OPENCTR_HOST)
    if(WIN32)
        set(OPENCTR_HOST "Win32")
    elseif(APPLE)
        set(OPENCTR_HOST "OSX")
    elseif(UNIX)
        set(OPENCTR_HOST "Linux")
    endif()
endif()

if(NOT OPENCTR_HOST MATCHES "(Win32|OSX|Linux)")
    message(FATAL_ERROR "Unrecognized OPENCTR_HOST: ${OPENCTR_HOST}")
endif()

string(TOUPPER "${OPENCTR_HOST}" OPENCTR_HOST_NAME)
string(COMPARE EQUAL "${OPENCTR_HOST_NAME}" "LINUX" OPENCTR_HOST_LINUX)
string(COMPARE EQUAL "${OPENCTR_HOST_NAME}" "OSX" OPENCTR_HOST_OSX)
string(COMPARE EQUAL "${OPENCTR_HOST_NAME}" "WIN32" OPENCTR_HOST_WIN32)

if(OPENCTR_HOST_LINUX)
    set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/Toolchain/Linux.cmake")
elseif(OPENCTR_HOST_OSX)
    set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/Toolchain/OSX.cmake")
elseif(OPENCTR_HOST_WIN32)
    set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/Toolchain/Win32.cmake")
endif()

