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

find_package(Sphinx QUIET REQUIRED)

option(ENABLE_UPLOAD "Enable 'upload' target to upload documentation" OFF)

set(CONFIG_PATH "${CMAKE_CURRENT_BINARY_DIR}")
set(HTML_PATH "${OPENCTR_ROOT}/share/doc/OpenCTR")
set(RST_PATH "${CMAKE_CURRENT_SOURCE_DIR}/rst")
set(UPLOAD_PATH "${CMAKE_CURRENT_BINARY_DIR}/upload")
set(THEME_PATH "${CMAKE_CURRENT_SOURCE_DIR}/_themes")
set(STATIC_PATH "${CMAKE_CURRENT_SOURCE_DIR}/_static")

# Configure conf.py.in
configure_file(
	${CMAKE_CURRENT_SOURCE_DIR}/conf.py.in
	${CMAKE_CURRENT_BINARY_DIR}/conf.py
	@ONLY
)

# Generate HTML documentation
add_custom_command(OUTPUT ${HTML_PATH} 
	COMMAND ${SPHINX_EXECUTABLE} 
		-q 
		-b html 
		-c ${CONFIG_PATH}
		${RST_PATH} 
		${HTML_PATH}
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	COMMENT "Generating HTML"
)

# Documentation target to generate all documentation formats
add_custom_target(doc ALL DEPENDS ${HTML_PATH})

if(ENABLE_UPLOAD)
	# Git is required for pushing to GitHub Pages.
	find_package(Git QUIET REQUIRED)

	# Create custom 'upload' target
	add_custom_target(upload 
		DEPENDS html
		# Remove the existing upload directory.
		COMMAND ${CMAKE_COMMAND} -E remove_directory ${UPLOAD_PATH}
		# Clone the GitHub Pages repo
		COMMAND ${GIT_EXECUTABLE} clone --quiet https://github.com/OpenCTR/OpenCTR.github.io ${UPLOAD_PATH}
		# Remove all existing files
		COMMAND ${GIT_EXECUTABLE} -C ${UPLOAD_PATH} rm -rf --quiet .
		# Copy the HTML files into the git repository
		COMMAND ${CMAKE_COMMAND} -E copy_directory ${HTML_PATH} ${UPLOAD_PATH}/
		# Create the .nojekyll to allow subdirectories
		COMMAND ${CMAKE_COMMAND} -E touch ${UPLOAD_PATH}/.nojekyll
		# Add the newly copied files into Git
		COMMAND ${GIT_EXECUTABLE} -C ${UPLOAD_PATH} add .
		# Commit the new files
		COMMAND ${GIT_EXECUTABLE} -C ${UPLOAD_PATH} commit --quiet -m "Updated HTML documentation"
		# Push the new files into GitHub
		COMMAND ${GIT_EXECUTABLE} -C ${UPLOAD_PATH} push --quiet origin master
	)

	# Cleanup
	set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "upload")
endif()
