|Building| |Coverage| |License|

|Logo|

=======
OpenCTR
=======

:repository: `OpenCTR <https://github.com/OpenCTR/OpenCTR>`_
:license: `GPL3 <http://www.gnu.org/licenses/gpl-3.0.html>`_
:owner: `Alex Shaw <mailto:alex.shaw.as@gmail.com>`_
:description: OpenCTR is a free, open-source, and cross-platform SDK for developing homebrew for the Nintendo 3DS.

===========
Description
===========

OpenCTR is a free, open-source, and cross-platform SDK for developing homebrew for the Nintendo 3DS.

This repository contains the build logic to create a working OpenCTR SDK.

===============
Getting Started
===============

See https://openctr.github.io/Building.html for help building OpenCTR.

=====================
Configuration Options
=====================

Pass these values to CMake to change how OpenCTR should behave.

:CMAKE_BUILD_TYPE: Build Configuration. Debug/Release/RelWithDebInfo/MinSizeRel
:CMAKE_INSTALL_PREFIX: Directory to install OpenCTR into.
:ENABLE_DOC: Enable/Disable building the OpenCTR Documentation.
:ENABLE_TOOLS: Enable/Disable building the OpenCTR Tools.
:ENABLE_TOOLCHAIN: Enable/Disable building the OpenCTR Toolchain.
:ENABLE_LIBCTR: Enable/Disable building libctr as part of OpenCTR.

=============
Documentation
=============

https://openctr.github.io/

=======
Authors
=======

* Symbitic

https://openctr.github.io/Authors.html

=======
Credits
=======

https://openctr.github.io/Credits.html

=======
License
=======

OpenCTR is licensed under version 3 of the `GNU General Public License`_. 
See `LICENSE`_ for terms.

.. _GNU General Public License: http://www.gnu.org/licenses/gpl.html

.. _LICENSE: ./LICENSE.txt

.. |Building| image:: http://img.shields.io/travis/OpenCTR/OpenCTR/master.svg?style=flat
   :alt: TravisCI build status
   :target: https://travis-ci.org/OpenCTR/OpenCTR

.. |Coverage| image:: http://img.shields.io/coveralls/OpenCTR/OpenCTR/master.svg?style=flat
   :alt: Coveralls.io coverage
   :target: https://coveralls.io/r/OpenCTR/OpenCTR?branch=master

.. |License| image:: http://img.shields.io/badge/license-gpl3-blue.svg?style=flat
   :alt: GNU GPL3 License
   :target: http://www.gnu.org/licenses/gpl-3.0.html

.. |Logo| image:: https://avatars2.githubusercontent.com/u/11789047
