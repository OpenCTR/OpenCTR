#.rst:
# CMakeProjectSettings
# --------------------
# 
# Project settings.
# 

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

# OpenCTR-Doc Settings
set(OPENCTR_DOC_REPO "https://github.com/OpenCTR/OpenCTR-Doc")
set(OPENCTR_DOC_TAG "v1.0.1")

# OpenCTR-Toolchain Settings
set(OPENCTR_TOOLCHAIN_REPO "https://github.com/OpenCTR/OpenCTR-Toolchain")
set(OPENCTR_TOOLCHAIN_TAG "v1.0.1")

# OpenCTR-Tools Settings
set(OPENCTR_TOOLS_REPO "https://github.com/OpenCTR/OpenCTR-Tools")
set(OPENCTR_TOOLS_TAG "v1.0.1")

# libctr Settings
set(LIBCTR_REPO "https://github.com/OpenCTR/libctr")
set(LIBCTR_TAG "v0.1.0")

# CPack Settings
set(PROJECT_CONTACT "https://github.com/OpenCTR")
set(PROJECT_DESCRIPTION "Free and Open-Source Software Development Kit for the Nintendo 3DS.")
set(PROJECT_ABOUT ${CMAKE_CURRENT_SOURCE_DIR}/README.rst)
set(PROJECT_README ${CMAKE_CURRENT_SOURCE_DIR}/README.rst)
set(PROJECT_VENDOR "OpenCTR")
set(PROJECT_LICENSE ${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.txt)
set(PROJECT_HOMEPAGE "https://github.com/OpenCTR")
set(PROJECT_LICENSE "GPLv3")

if(WIN32)
	set(CPACK_GENERATOR "ZIP")
else()
	set(CPACK_GENERATOR "TBZ2")
endif()

