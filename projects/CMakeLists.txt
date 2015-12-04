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

include(ExternalProject)

set(DEPENDS "tools")
if(ENABLE_GCC)
    list(APPEND DEPENDS "gcc")
endif()
if(ENABLE_LLVM)
    list(APPEND DEPENDS "clang")
endif()

if(ENABLE_LIBCTRU)
    ExternalProject_Add(libctru
        DEPENDS ${DEPENDS}
        PREFIX ${CMAKE_CURRENT_BINARY_DIR}
        INSTALL_DIR ${OPENCTR_ROOT}/arm-none-eabi
        GIT_REPOSITORY "https://github.com/OpenCTR/libctru"
        GIT_TAG "master"
        CMAKE_ARGS 
            -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> 
            -DCMAKE_PREFIX_PATH=${OPENCTR_ROOT} 
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DOPENCTR_ROOT=${OPENCTR_ROOT}
        LOG_DOWNLOAD ${ENABLE_LOG}
        LOG_CONFIGURE ${ENABLE_LOG}
        LOG_BUILD ${ENABLE_LOG}
        LOG_INSTALL ${ENABLE_LOG}
    )
endif()

if(ENABLE_LIBCTR)
    ExternalProject_Add(libctr
        DEPENDS ${DEPENDS}
        PREFIX ${CMAKE_CURRENT_BINARY_DIR}
        INSTALL_DIR ${OPENCTR_ROOT}/arm-none-eabi
        GIT_REPOSITORY "https://github.com/OpenCTR/libctr"
        GIT_TAG "master"
        CMAKE_ARGS 
            -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> 
            -DCMAKE_PREFIX_PATH=${OPENCTR_ROOT} 
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DOPENCTR_ROOT=${OPENCTR_ROOT}
        LOG_DOWNLOAD ${ENABLE_LOG}
        LOG_CONFIGURE ${ENABLE_LOG}
        LOG_BUILD ${ENABLE_LOG}
        LOG_INSTALL ${ENABLE_LOG}
    )
endif()

# Cleanup
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "src")
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "tmp")
