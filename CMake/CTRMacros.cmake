#.rst:
# CTRMacros
# ---------
#
# CMake commands used in OpenCTR projects.

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

cmake_minimum_required(VERSION 3.0.0)

include(CMakeParseArguments)

find_program(3DMOO_EXECUTABLE 3dmoo ${PACKAGE_PREFIX_DIR}/bin)
find_program(CITRA_EXECUTABLE citra ${PACKAGE_PREFIX_DIR}/bin)

function(CTR_ADD_TEST TGT)
    set(BOOLEAN_OPTIONS)
    set(SINGLE_OPTIONS GDB_PORT SDMC_PATH)
    set(MULTI_OPTIONS)

    if(NOT 3DMOO_EXECUTABLE)
        message(SEND_ERROR "3dmoo not found - unable to add tests.")
        return()
    endif()

    if(NOT TARGET ${TGT})
        message(SEND_ERROR "Error: CTR_ADD_TEST target ${TGT} is not a target.")
        return()
    endif()

    cmake_parse_arguments(CTRTEST "${BOOLEAN_OPTIONS}" "${SINGLE_OPTIONS}" "${MULTI_OPTIONS}" ${ARGN})

    if(DEFINED CTRTEST_GDB_PORT)
        set(GDB_PARAM "-gdbport ${CTRTEST_GDB_PORT}")
    endif()

    if(DEFINED CTRTEST_SDMC_PATH)
        set(SDMC_PARAM "-sdmc ${CTRTEST_SDMC_PATH} -sdwrite")
    endif()

    # Create a new test
    add_test(NAME "${TGT}"
        COMMAND ${3DMOO_EXECUTABLE} $<TARGET_FILE:${TGT}> ${SDMC_PARAM} ${GDB_PARAM} 
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
endfunction()
