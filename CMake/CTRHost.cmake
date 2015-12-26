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
        list(APPEND GCC_EXTRA_ARGS "--without-isl")
    elseif(UNIX)
        list(APPEND CMAKE_ARGS "-DCMAKE_C_COMPILER=/usr/bin/clang-3.6")
        list(APPEND CMAKE_ARGS "-DCMAKE_CXX_COMPILER=/usr/bin/clang++-3.6")
    endif()
else()
    set(ENABLE_LOG TRUE)
endif()

