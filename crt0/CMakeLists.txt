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

# TODO: Use current-host clang for compiling crt0. local GCC or local clang
# will error when using triple-cross.

set(DEPENDS "tools")
if(ENABLE_GCC)
	list(APPEND DEPENDS "gcc")
    set(ARMCC "${OPENCTR_ROOT}/bin/arm-none-eabi-gcc")
elseif(ENABLE_LLVM)
	list(APPEND DEPENDS "clang")
    set(ARMCC "${OPENCTR_ROOT}/bin/clang")
endif()

# Generate 3dsx_crt0.o
add_custom_command(
	OUTPUT ${OPENCTR_ROOT}/arm-none-eabi/lib/3dsx_crt0.o
	COMMAND ${ARMCC} -march=armv6k -mtune=mpcore 
		-o ${OPENCTR_ROOT}/arm-none-eabi/lib/3dsx_crt0.o
		-c ${CMAKE_CURRENT_SOURCE_DIR}/3dsx_crt0.s
	COMMENT "3dsx_crt0.s"
	MAIN_DEPENDENCY ${CMAKE_CURRENT_SOURCE_DIR}/3dsx_crt0.s
	DEPENDS ${DEPENDS}
)

# Mark 3dsx_crt0.o as generated
set_source_files_properties(${OPENCTR_ROOT}/arm-none-eabi/lib/3dsx_crt0.o 
	PROPERTIES GENERATED 1)

# CRT0 target
add_custom_target(crt0 ALL
    DEPENDS ${OPENCTR_ROOT}/arm-none-eabi/lib/3dsx_crt0.o)

# Copy 3dsx.ld and 3dsx.specs into OPENCTR_ROOT
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/3dsx.ld 
	DESTINATION ${OPENCTR_ROOT}/arm-none-eabi/lib)
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/3dsx.specs 
	DESTINATION ${OPENCTR_ROOT}/arm-none-eabi/lib)
