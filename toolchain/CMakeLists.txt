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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License 
# along with OpenCTR. If not, see <http://www.gnu.org/licenses/>.
####################################################################

include(ExternalProject)
include(ProcessorCount)

# Identify the number of cores we can use.
ProcessorCount(N)
if(NOT N EQUAL 0)
	set(JOB_FLAGS -j${N})
endif()

# Require GNU Make for building Autotools projects
find_program(MAKE_EXECUTABLE make)
if(NOT MAKE_EXECUTABLE)
	message(SEND_ERROR "GNU Make not found")
endif()

# Require GNU Patch for patching downloaded sources
find_program(PATCH_EXECUTABLE patch)
if(NOT PATCH_EXECUTABLE)
	message(SEND_ERROR "GNU Patch not found")
endif()

# Binutils target
ExternalProject_Add(binutils
	PREFIX ${CMAKE_CURRENT_BINARY_DIR}
	INSTALL_DIR ${OPENCTR_INSTALL_DIR}
	URL "ftp://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.bz2" 
	URL_HASH SHA256=22defc65cfa3ef2a3395faaea75d6331c6e62ea5dfacfed3e2ec17b08c882923
	DOWNLOAD_NO_PROGRESS TRUE 
	PATCH_COMMAND ${PATCH_EXECUTABLE} --strip=1 --quiet --input=${CMAKE_CURRENT_SOURCE_DIR}/patches/binutils-2.25.patch --directory=<SOURCE_DIR> 
	CONFIGURE_COMMAND <SOURCE_DIR>/configure 
		--prefix=<INSTALL_DIR> 
		--target=arm-none-eabi 
		--disable-nls 
		--disable-shared 
		--disable-debug 
		--disable-dependency-tracking 
		--disable-werror 
		--disable-bootstrap 
		--enable-checking=release 
		--enable-lto 
		--enable-plugins 
		--enable-gold=yes
		--enable-ld=default
		--enable-poison-system-directories 
		--enable-install-libbfd 
		--enable-build-with-cxx 
		--enable-interworks 
		--enable-nlsi=no 
		--enable-threads
	BUILD_COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS}
	INSTALL_COMMAND ${MAKE_EXECUTABLE} install
	LOG_DOWNLOAD TRUE
	LOG_CONFIGURE TRUE
	LOG_BUILD TRUE
	LOG_INSTALL TRUE
)

# GCC target
ExternalProject_Add(gcc
	DEPENDS binutils
	PREFIX ${CMAKE_CURRENT_BINARY_DIR}
	INSTALL_DIR ${OPENCTR_INSTALL_DIR}
	URL "ftp://ftp.gnu.org/gnu/gcc/gcc-4.9.2/gcc-4.9.2.tar.bz2"
	URL_HASH SHA256=2020c98295856aa13fda0f2f3a4794490757fc24bcca918d52cc8b4917b972dd
	DOWNLOAD_NO_PROGRESS TRUE
	PATCH_COMMAND ${PATCH_EXECUTABLE} --strip=1 --quiet --input=${CMAKE_CURRENT_SOURCE_DIR}/patches/gcc-4.9.2.patch --directory=<SOURCE_DIR>
	CONFIGURE_COMMAND <SOURCE_DIR>/configure 
		--prefix=<INSTALL_DIR> 
		--target=arm-none-eabi 
		--disable-nls 
		--disable-shared 
		--disable-debug 
		--disable-dependency-tracking 
		--disable-werror 
		--with-bugurl=https://github.com/OpenCTR/OpenCTR/issues
		--enable-checking=release 
		--disable-bootstrap 
		--enable-interwork 
		--enable-languages=c,c++ 
		--enable-threads 
		--disable-win32-registry 
		--with-newlib 
		--without-headers 
		--enable-lto 
		--enable-multilib 
		--with-endian=little 
		--with-arch=armv6k 
	BUILD_COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS}
	INSTALL_COMMAND ${MAKE_EXECUTABLE} install
	LOG_DOWNLOAD TRUE
	LOG_CONFIGURE TRUE
	LOG_BUILD TRUE
	LOG_INSTALL TRUE
)

# Newlib target
ExternalProject_Add(newlib
	DEPENDS binutils
	PREFIX ${CMAKE_CURRENT_BINARY_DIR}
	INSTALL_DIR ${OPENCTR_INSTALL_DIR}
	EXCLUDE_FROM_ALL TRUE
	URL "ftp://sourceware.org/pub/newlib/newlib-2.2.0.tar.gz"
	URL_HASH SHA256=f8add263b0737591aff451b12a00c262c2efac4fa87d741fa1c318fc3bb335be
	DOWNLOAD_NO_PROGRESS TRUE
	PATCH_COMMAND ${PATCH_EXECUTABLE} --strip=1 --quiet --input=${CMAKE_CURRENT_SOURCE_DIR}/patches/newlib-2.2.0.patch --directory=<SOURCE_DIR>
	CONFIGURE_COMMAND <SOURCE_DIR>/configure 
		--prefix=<INSTALL_DIR> 
		--target=arm-none-eabi 
		--disable-newlib-supplied-syscalls 
		--enable-newlib-mb 
		--enable-multilib
	BUILD_COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS}
	INSTALL_COMMAND ${MAKE_EXECUTABLE} install
	LOG_DOWNLOAD TRUE
	LOG_CONFIGURE TRUE
	LOG_BUILD TRUE
	LOG_INSTALL TRUE
)

# Dependency Injection: Require "make all-gcc" after "configure"
ExternalProject_Add_Step(gcc all-gcc
	COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS} all-gcc
	DEPENDEES configure
	WORKING_DIRECTORY <BINARY_DIR>
	LOG TRUE
)

# Dependency Injection: Require "make install-gcc" after "all-gcc"
ExternalProject_Add_Step(gcc install-gcc
	COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS} install-gcc
	DEPENDEES all-gcc
	WORKING_DIRECTORY <BINARY_DIR>
	LOG TRUE
)

# Dependency Injection: Make GCC 'build' stage depend on Newlib
ExternalProject_Add_Step(gcc newlib
	COMMAND ${CMAKE_MAKE_PROGRAM} newlib
	DEPENDEES install-gcc
	DEPENDERS build
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

# Cleanup
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "src")
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "tmp")

