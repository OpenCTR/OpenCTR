######################################################################
# This file is part of OpenCTR.
# 
# OpenCTR is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# OpenCTR is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with OpenCTR.  If not, see <http://www.gnu.org/licenses/>.
######################################################################

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

# Exported for global visibility
set(CTR_ROOT "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE INTERNAL "OpenCTR Root")

if(ENABLE_LOG)
	set(BINUTILS_CONFIGURE_LOG "<TMP_DIR>/binutils-configure.log")
	set(GCC_CONFIGURE_LOG "<TMP_DIR>/gcc-configure.log")
	set(NEWLIB_CONFIGURE_LOG "<TMP_DIR>/newlib-configure.log")
	set(GCC_ALL_LOG "<TMP_DIR>/all-gcc.log")
	set(GCC_INSTALL_LOG "<TMP_DIR>/install-gcc.log")
	set(LOG_FLAG 1)
else()
	set(BINUTILS_CONFIGURE_LOG "/dev/stdout")
	set(GCC_CONFIGURE_LOG "/dev/stdout")
	set(NEWLIB_CONFIGURE_LOG "/dev/stdout")
	set(GCC_ALL_LOG "/dev/stdout")
	set(GCC_INSTALL_LOG "/dev/stdout")
	set(VERBOSE_FLAG "VERBOSE=1")
	set(LOG_FLAG 0)
endif()

# Binutils target
ExternalProject_Add(binutils
	PREFIX ${CMAKE_CURRENT_BINARY_DIR}
	INSTALL_DIR install 
	URL "ftp://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.bz2" 
	DOWNLOAD_NO_PROGRESS TRUE 
	PATCH_COMMAND ${PATCH_EXECUTABLE} --strip=1 --quiet --input=${CMAKE_CURRENT_SOURCE_DIR}/patches/binutils-2.25.patch --directory=<SOURCE_DIR> 
	CONFIGURE_COMMAND PATH=<INSTALL_DIR>/bin:$ENV{PATH} <SOURCE_DIR>/configure 
		--prefix=<INSTALL_DIR> 
		--target=arm-none-eabi 
		--disable-nls 
		--disable-shared 
		--disable-debug 
		--disable-dependency-tracking 
		--disable-werror 
		--enable-checking=release 
		--disable-libquadmath 
		--disable-libquadmath-support 
		--disable-libada 
		--disable-libssp 
		--disable-libmudflap 
		--disable-bootstrap 
		--disable-libstdcxx 
		--disable-decimal-float 
		--enable-lto 
		--enable-plugins 
		--enable-ld=default 
		--enable-poison-system-directories 
		--enable-install-libbfd 
		--enable-build-with-cxx 
		--enable-gold=yes 
		--enable-interworks 
		--enable-nlsi=no 
		&> ${BINUTILS_CONFIGURE_LOG}
	BUILD_COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS} ${VERBOSE_FLAG}
	INSTALL_COMMAND ${MAKE_EXECUTABLE} install
	LOG_DOWNLOAD ${LOG_FLAG}
	LOG_BUILD ${LOG_FLAG}
	LOG_INSTALL ${LOG_FLAG}
)

# GCC target
ExternalProject_Add(gcc
	DEPENDS binutils
	PREFIX ${CMAKE_CURRENT_BINARY_DIR}
	INSTALL_DIR install
	URL "ftp://ftp.gnu.org/gnu/gcc/gcc-4.8.2/gcc-4.8.2.tar.bz2"
	DOWNLOAD_NO_PROGRESS TRUE
	PATCH_COMMAND ${PATCH_EXECUTABLE} --strip=1 --quiet --input=${CMAKE_CURRENT_SOURCE_DIR}/patches/gcc-4.8.2.patch --directory=<SOURCE_DIR>
	CONFIGURE_COMMAND PATH=<INSTALL_DIR>/bin:$ENV{PATH} <SOURCE_DIR>/configure 
		--prefix=<INSTALL_DIR> 
		--target=arm-none-eabi 
		--disable-nls 
		--disable-shared 
		--disable-debug 
		--disable-dependency-tracking 
		--disable-werror 
		--with-bugurl=alshaw@ilstu.edu  
		--enable-checking=release 
		--disable-libquadmath 
		--disable-libquadmath-support 
		--disable-libada 
		--disable-libssp 
		--disable-libmudflap 
		--disable-bootstrap 
		--disable-libstdcxx 
		--disable-decimal-float 
		--enable-interwork 
		--enable-languages=c,c++ 
		--disable-libgomp 
		--disable-threads 
		--disable-win32-registry 
		--with-newlib 
		--without-headers 
		--enable-lto 
		--disable-multilib 
		--with-endian=little 
		--with-arch=armv4t 
		--with-arch=armv6 
		--with-arch=armv6k 
		--with-tune=mpcore 
		&> ${GCC_CONFIGURE_LOG}
	BUILD_COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS}
	INSTALL_COMMAND ${MAKE_EXECUTABLE} install
	LOG_DOWNLOAD TRUE
	LOG_BUILD TRUE
	LOG_INSTALL TRUE
)

# Newlib target
ExternalProject_Add(newlib
	DEPENDS binutils
	PREFIX ${CMAKE_CURRENT_BINARY_DIR}
	INSTALL_DIR install
	EXCLUDE_FROM_ALL TRUE
	URL "ftp://sourceware.org/pub/newlib/newlib-2.1.0.tar.gz"
	URL_HASH "SHA256=3e4d5ab9f0508942b6231b8ade4f8e5048cf92c96ed574c2bd6bd3320a599a48"
	DOWNLOAD_NO_PROGRESS TRUE
	PATCH_COMMAND ${PATCH_EXECUTABLE} --strip=1 --quiet --input=${CMAKE_CURRENT_SOURCE_DIR}/patches/newlib-2.1.0.patch --directory=<SOURCE_DIR>
	CONFIGURE_COMMAND PATH=<INSTALL_DIR>/bin:$ENV{PATH} <SOURCE_DIR>/configure 
		--prefix=<INSTALL_DIR>
		--target=arm-none-eabi 
		--disable-nls 
		--disable-shared 
		--disable-debug 
		--disable-dependency-tracking 
		--disable-werror 
		--disable-bootstrap 
		--disable-multilib 
		--disable-newlib-supplied-syscalls 
		--enable-newlib-mb 
		--enable-newlib-io-long-long 
		&> ${NEWLIB_CONFIGURE_LOG}
	BUILD_COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS}
	INSTALL_COMMAND ${MAKE_EXECUTABLE} install
	LOG_DOWNLOAD ${ENABLE_LOG}
	LOG_BUILD ${ENABLE_LOG}
	LOG_INSTALL ${ENABLE_LOG}
)

# Dependency Injection: Require "make all-gcc" after "configure"
ExternalProject_Add_Step(gcc all-gcc
	COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS} all-gcc &> ${GCC_ALL_LOG}
	DEPENDEES configure
	WORKING_DIRECTORY <BINARY_DIR>
)

# Dependency Injection: Require "make install-gcc" after "all-gcc"
ExternalProject_Add_Step(gcc install-gcc
	COMMAND ${MAKE_EXECUTABLE} ${JOB_FLAGS} install-gcc &> ${GCC_INSTALL_LOG}
	DEPENDEES all-gcc
	WORKING_DIRECTORY <BINARY_DIR>
)

# Dependency Injection: Make GCC 'build' stage depend on Newlib
ExternalProject_Add_Step(gcc newlib
	COMMAND ${CMAKE_MAKE_PROGRAM} newlib
	DEPENDEES install-gcc
	DEPENDERS build
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

# Cleanup
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "src" "tmp" "install")

# Installation
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/install/ DESTINATION OpenCTR
	COMPONENT toolchain
	USE_SOURCE_PERMISSIONS
	PATTERN .* EXCLUDE
)
