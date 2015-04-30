# -*- coding: utf-8 -*-

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

needs_sphinx = "1.3"

project = u"OpenCTR"
copyright = u"2015"
version = u"1.0.0"

source_suffix = ".rst"

master_doc = "index"

extensions = [ "sphinx.ext.todo" ]

todo_include_todos = True

html_title = "OpenCTR"
html_theme = "haiku"
html_static_path = [ "_static" ]
html_use_index = True
html_show_sourcelink = False
html_show_sphinx = False
html_show_copyright = False
html_favicon = "_static/favicon.ico"
html_add_permalinks = ""
html_logo = "_static/logo.svg"

html_theme_options = { 
	"nosidebar": True, 
	"full_logo": True, 
	"visitedlinkcolor": "#dc3c01"
}

