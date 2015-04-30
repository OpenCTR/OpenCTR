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

# OpenCTR-Tools
ExternalProject_Add(tools
	DEPENDS gcc
	PREFIX ${CMAKE_CURRENT_BINARY_DIR}
	INSTALL_DIR install
	GIT_REPOSITORY "https://github.com/OpenCTR/OpenCTR-Tools"
	GIT_TAG "master"
	CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} 
	LOG_DOWNLOAD TRUE
	LOG_CONFIGURE TRUE
	LOG_BUILD TRUE
	LOG_INSTALL TRUE
)

# Cleanup
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "src" "tmp" "install")

# Installation
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/install DESTINATION OpenCTR
	COMPONENT tools
	USE_SOURCE_PERMISSIONS
)
