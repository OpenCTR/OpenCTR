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

find_package(Sphinx QUIET REQUIRED)

option(ENABLE_UPLOAD "Enable 'upload' target to upload documentation" OFF)

set(DOC_DIR "${CMAKE_CURRENT_BINARY_DIR}/doc")
set(DOCTREE_DIR "${CMAKE_CURRENT_BINARY_DIR}/doc")
set(HTML_DIR "${CMAKE_CURRENT_BINARY_DIR}/doc/html")
set(RST_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
set(UPLOAD_DIR "${CMAKE_CURRENT_BINARY_DIR}/upload")

add_custom_target(html
	COMMAND ${SPHINX_EXECUTABLE} -q -b html -d ${DOCTREE_DIR} ${RST_DIR} ${HTML_DIR}
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	COMMENT "Generating HTML"
)

add_custom_target(doc ALL 
	DEPENDS html 
)

if(ENABLE_UPLOAD)
	# Git is required for pushing to GitHub Pages.
	find_package(Git QUIET REQUIRED)

	# Create custom 'upload' target
	add_custom_target(upload 
		DEPENDS html
		# Remove the existing upload directory.
		COMMAND ${CMAKE_COMMAND} -E remove_directory ${UPLOAD_DIR}
		# Clone the GitHub Pages repo
		COMMAND ${GIT_EXECUTABLE} clone --quiet https://github.com/OpenCTR/OpenCTR.github.io ${UPLOAD_DIR}
		# Remove all existing files
		COMMAND ${GIT_EXECUTABLE} -C ${UPLOAD_DIR} rm -rf --quiet .
		# Copy the HTML files into the git repository
		COMMAND ${CMAKE_COMMAND} -E copy_directory ${HTML_DIR} ${UPLOAD_DIR}/
		# Create the .nojekyll to allow subdirectories
		COMMAND ${CMAKE_COMMAND} -E touch ${UPLOAD_DIR}/.nojekyll
		# Add the newly copied files into Git
		COMMAND ${GIT_EXECUTABLE} -C ${UPLOAD_DIR} add .
		# Commit the new files
		COMMAND ${GIT_EXECUTABLE} -C ${UPLOAD_DIR} commit --quiet -m "Updated HTML documentation"
		# Push the new files into GitHub
		COMMAND ${GIT_EXECUTABLE} -C ${UPLOAD_DIR} push --quiet origin master
	)

	# Cleanup files created from upload
	set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "upload")
endif()

set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "doc")

install(DIRECTORY ${HTML_DIR} DESTINATION OpenCTR/doc
	COMPONENT documentation
	USE_SOURCE_PERMISSIONS 
)
