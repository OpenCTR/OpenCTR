#.rst:
# CTRToolchain
# ------------
#
# :variable:`CMAKE_TOOLCHAIN_FILE` for OpenCTR.
#
# Note
# ~~~~
#
# The user does **not** need to specify ``CMAKE_TOOLCHAIN_FILE``, as long as
# ``find_package(CTR)`` was called.
#
# For this to work, the CMakeLists.txt file must contain
# ``project(<NAME> NONE)``, because setting ``CMAKE_TOOLCHAIN_FILE`` after any
# languages have been enabled will have no effect.

################################################################################
# OpenCTR - A free and open-source SDK for Nintendo 3DS homebrew.
#
# Copyright (C) 2015, OpenCTR Contributors.
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

################################################################################

#
# Find required components.
#

if(NOT OPENCTR_ROOT)
    get_filename_component(PWD "${CMAKE_CURRENT_LIST_FILE}" DIRECTORY)
    get_filename_component(OPENCTR_ROOT "${PWD}/../../.." ABSOLUTE)
endif()

find_program(ARM_EABI_GCC arm-none-eabi-gcc ${OPENCTR_ROOT}/bin
    NO_DEFAULT_PATH)
find_program(ARM_EABI_GXX arm-none-eabi-g++ ${OPENCTR_ROOT}/bin
    NO_DEFAULT_PATH)
find_program(ARM_EABI_AR arm-none-eabi-ar ${OPENCTR_ROOT}/bin
    NO_DEFAULT_PATH)
find_program(ARM_EABI_RANLIB arm-none-eabi-ranlib ${OPENCTR_ROOT}/bin
    NO_DEFAULT_PATH)

if(NOT ARM_EABI_GCC)
    message(FATAL_ERROR "Could not locate arm-none-eabi-gcc")
elseif(NOT ARM_EABI_GXX)
    message(FATAL_ERROR "Could not locate arm-none-eabi-g++")
elseif(NOT ARM_EABI_AR)
    message(FATAL_ERROR "Could not locate arm-none-eabi-ar")
elseif(NOT ARM_EABI_RANLIB)
    message(FATAL_ERROR "Could not locate arm-none-eabi-ranlib")
endif()

################################################################################

set(CMAKE_SYSTEM_NAME "Generic")
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR "ARM")

include(CMakeForceCompiler)

cmake_force_c_compiler(${ARM_EABI_GCC} GNU)
cmake_force_cxx_compiler(${ARM_EABI_GXX} GNU)

set(CMAKE_FIND_ROOT_PATH "${OPENCTR_ROOT}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CMAKE_EXECUTABLE_SUFFIX ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_C ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_CXX ".elf")
set(CMAKE_STATIC_LIBRARY_PREFIX "lib")
set(CMAKE_STATIC_LIBRARY_SUFFIX ".a")
set(CMAKE_SIZEOF_VOID_P "4")
set(CMAKE_STANDARD_LIBRARIES "-lc -lm")
set(CMAKE_LINK_LIBRARY_SUFFIX)
set(CMAKE_SHARED_LIBRARY_PREFIX)
set(CMAKE_SHARED_LIBRARY_SUFFIX)
set(CMAKE_DL_LIBS)
set(CMAKE_FIND_LIBRARY_PREFIXES "lib")
set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")

set(CMAKE_C_OUTPUT_EXTENSION ".o")
set(CMAKE_CXX_OUTPUT_EXTENSION ".o")
set(CMAKE_ASM_OUTPUT_EXTENSION ".o")

################################################################################

# 
# ASM Flags
# 

# ARMv6 Architecture.
set(CMAKE_ASM_FLAGS "-march=armv6k ${CMAKE_ASM_FLAGS}")
# ARM11 MPCore CPU.
set(CMAKE_ASM_FLAGS "-mtune=mpcore ${CMAKE_ASM_FLAGS}")
# Hardware Floating Point.
set(CMAKE_ASM_FLAGS "-mfloat-abi=hard ${CMAKE_ASM_FLAGS}")

################################################################################

# 
# General C/C++ Flags
# 

# Use pipes instead of temp files, for faster compiling.
set(CMAKE_C_FLAGS "-pipe ${CMAKE_C_FLAGS}")
# Use 32-Bit ARM-mode.
set(CMAKE_C_FLAGS "-marm ${CMAKE_C_FLAGS}")
# ARMv6 Architecture.
set(CMAKE_C_FLAGS "-march=armv6k ${CMAKE_C_FLAGS}")
# ARM11 MPCore Processor.
set(CMAKE_C_FLAGS "-mtune=mpcore ${CMAKE_C_FLAGS}")
# Hardware Floating Point (with software fallback)
set(CMAKE_C_FLAGS "-mfloat-abi=softfp ${CMAKE_C_FLAGS}")
# VFPv2 Floating Point Unit
set(CMAKE_C_FLAGS "-mfpu=vfp ${CMAKE_C_FLAGS}")
# 32-bit aligned relocations.
set(CMAKE_C_FLAGS "-mword-relocations ${CMAKE_C_FLAGS}")
# Place each function in a separate section
set(CMAKE_C_FLAGS "-ffunction-sections ${CMAKE_C_FLAGS}")
# Place each data item in a separate section
set(CMAKE_C_FLAGS "-fdata-sections ${CMAKE_C_FLAGS}")
# 32-bit enumerations (required by AAPCS).
set(CMAKE_C_FLAGS "-fno-short-enums ${CMAKE_C_FLAGS}")
# 16-bit wide characters (required by AAPCS).
set(CMAKE_C_FLAGS "-fshort-wchar ${CMAKE_C_FLAGS}")
# Signed 8-bit characters (required by AAPCS).
set(CMAKE_C_FLAGS "-fsigned-char ${CMAKE_C_FLAGS}")
# Use the MPCore CP15 register as the TLS pointer.
set(CMAKE_C_FLAGS "-mtp=cp15 ${CMAKE_C_FLAGS}")
# Enable warnings
set(CMAKE_C_FLAGS "-Wall ${CMAKE_CXX_FLAGS}")
# Disable Run-Time Type Information.
set(CMAKE_CXX_FLAGS "-fno-rtti ${CMAKE_CXX_FLAGS}")
# Disable Exception Handling.
set(CMAKE_CXX_FLAGS "-fno-exceptions ${CMAKE_CXX_FLAGS}")

################################################################################

# 
# C/C++ Debug Flags.
# 

# Optimize for best debugging experience.
set(CMAKE_C_FLAGS_DEBUG "-Og ${CMAKE_C_FLAGS_DEBUG}")
# Debug mode.
set(CMAKE_C_FLAGS_DEBUG "-DDEBUG ${CMAKE_C_FLAGS_DEBUG}")
# Output as much debugging information as possible.
set(CMAKE_C_FLAGS_DEBUG "-g ${CMAKE_C_FLAGS_DEBUG}")
# Generate DWARFv4-format debug info.
set(CMAKE_C_FLAGS_DEBUG "-gdwarf-4 ${CMAKE_C_FLAGS_DEBUG}")
# Push changes in the stack to the MPCore
set(CMAKE_C_FLAGS_DEBUG "-fstack-check ${CMAKE_C_FLAGS_DEBUG}")
# Generate hardware traps for integer overflows
set(CMAKE_C_FLAGS_DEBUG "-ftrapv ${CMAKE_C_FLAGS_DEBUG}")
# Provides best GDB integration
set(CMAKE_C_FLAGS_DEBUG "-fvar-tracking-assignments ${CMAKE_C_FLAGS_DEBUG}")

################################################################################

# 
# C/C++ Release Flags.
# 

# Maximum optimization settings
set(CMAKE_C_FLAGS_RELEASE "-O3 ${CMAKE_C_FLAGS_RELEASE}")
# Not-Debug mode
set(CMAKE_C_FLAGS_RELEASE "-DNDEBUG ${CMAKE_C_FLAGS_RELEASE}")
# Heavy pointer analysis
set(CMAKE_C_FLAGS_RELEASE "-fipa-pta ${CMAKE_C_FLAGS_RELEASE}")
# Disgard the frame pointer
set(CMAKE_C_FLAGS_RELEASE "-fomit-frame-pointer ${CMAKE_C_FLAGS_RELEASE}")
# Link-Time Optimization
set(CMAKE_C_FLAGS_RELEASE "-flto ${CMAKE_C_FLAGS_RELEASE}")
# Use the Gold LTO Plugin
set(CMAKE_C_FLAGS_RELEASE "-fuse-linker-plugin ${CMAKE_C_FLAGS_RELEASE}")
# Allow LTO-enabled objects to link with regular objects
set(CMAKE_C_FLAGS_RELEASE "-ffat-lto-objects ${CMAKE_C_FLAGS_RELEASE}")
# Maximum compression of LTO information
set(CMAKE_C_FLAGS_RELEASE "-flto-compression-level=9 ${CMAKE_C_FLAGS_RELEASE}")
# Use BFD as the linker (for LTO)
set(CMAKE_C_FLAGS_RELEASE "-fuse-ld=bfd ${CMAKE_C_FLAGS_RELEASE}")
# Speed up math calculations
set(CMAKE_C_FLAGS_RELEASE "-ffast-math ${CMAKE_C_FLAGS_RELEASE}")
# Color-coded warnings, errors, and status messages
set(CMAKE_C_FLAGS_RELEASE "-fdiagnostics-color=always ${CMAKE_C_FLAGS_RELEASE}")
# Generate stack to unwind execution thread
set(CMAKE_C_FLAGS_RELEASE "-funwind-tables ${CMAKE_C_FLAGS_RELEASE}")

################################################################################

# 
# Copy all CMAKE_C_FLAGS into CMAKE_CXX_FLAGS
# 

set(CMAKE_CXX_FLAGS
    "${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS}")
set(CMAKE_CXX_FLAGS_DEBUG
    "${CMAKE_C_FLAGS_DEBUG} ${CMAKE_CXX_FLAGS_DEBUG}")
set(CMAKE_CXX_FLAGS_RELEASE
    "${CMAKE_C_FLAGS_RELEASE} ${CMAKE_CXX_FLAGS_RELEASE}")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO
    "${CMAKE_C_FLAGS_RELWITHDEBINFO} ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
set(CMAKE_CXX_FLAGS_MINSIZEREL
    "${CMAKE_C_FLAGS_MINSIZEREL} ${CMAKE_CXX_FLAGS_MINSIZEREL}")

################################################################################

# 
# C/C++ Standards
# 

# Use C11 (w/GNU Extensions)
set(CMAKE_C_FLAGS "-std=gnu11 ${CMAKE_C_FLAGS}")
# Use C++11 (w/GNU Extensions)
set(CMAKE_CXX_FLAGS "-std=gnu++11 ${CMAKE_CXX_FLAGS}")

################################################################################

# 
# CMake utils
# 

# CMake ar
set(CMAKE_AR "${ARM_EABI_AR}")
# CMake ranlib
set(CMAKE_RANLIB "${ARM_EABI_RANLIB}")

################################################################################

# 
# OpenCTR Linker script
# 

# Garbage collection of unused code.
# set(CMAKE_EXE_LINKER_FLAGS "-Wl,--gc-sections ${CMAKE_EXE_LINKER_FLAGS}")
# Disable the executable stack.
# set(CMAKE_EXE_LINKER_FLAGS "-Wl,-z,noexecstack ${CMAKE_EXE_LINKER_FLAGS}")
# Report any undefined symbols at link-time.
# set(CMAKE_EXE_LINKER_FLAGS "-Wl,--no-undefined ${CMAKE_EXE_LINKER_FLAGS}")
# Discard unneeded references.
# set(CMAKE_EXE_LINKER_FLAGS "-Wl,--as-needed ${CMAKE_EXE_LINKER_FLAGS}")
# Enable incremental compilation. (GoLD only)
# set(CMAKE_EXE_LINKER_FLAGS "-Wl,--incremental ${CMAKE_EXE_LINKER_FLAGS}")
# Run linker multithreaded. (GoLD only)
# set(CMAKE_EXE_LINKER_FLAGS "-Wl,--threads ${CMAKE_EXE_LINKER_FLAGS}")

# Define common (global) symbols
set(CMAKE_EXE_LINKER_FLAGS "-Wl,-d ${CMAKE_EXE_LINKER_FLAGS}")
# Relocatable output
set(CMAKE_EXE_LINKER_FLAGS "-Wl,--emit-relocs ${CMAKE_EXE_LINKER_FLAGS}")
# Enable BLX
set(CMAKE_EXE_LINKER_FLAGS "-Wl,--use-blx ${CMAKE_EXE_LINKER_FLAGS}")
# 3DSX Linker Script.
set(CMAKE_EXE_LINKER_FLAGS "--specs=3dsx.specs ${CMAKE_EXE_LINKER_FLAGS}")

################################################################################

# Disable shared-library support.
set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS FALSE)

################################################################################

# 
# Target properties
# 

set(UNIX TRUE)
set(APPLE FALSE)
set(WIN32 FALSE)
set(CYGWIN FALSE)

################################################################################

