|Building| |Coverage| |License|

|Logo|

:repository: `OpenCTR <https://github.com/OpenCTR/OpenCTR>`_
:license: `GPL3 <http://www.gnu.org/licenses/gpl-3.0.html>`_
:owner: `Alex Shaw <mailto:alex.shaw.as@gmail.com>`_
:description: OpenCTR is a free and open-source, cross-platform SDK and Toolchain for developing homebrew for the Nintendo 3DS.

===========
Description
===========

OpenCTR is a free and open-source, cross-platform SDK and Toolchain for developing homebrew 
for the Nintendo 3DS.

This repository contains the build logic to create a working OpenCTR Toolchain.

===============
Getting Started
===============

To build the OpenCTR Toolchain from source, the following prerequisites must be installed:

* `CMake`_ >= 3.0.0
* `Python`_ 3
* GCC 4.8+ or Clang 3.3+
* The GNU build system (`autoconf`_, `automake`_, `libtool`_, `m4`_)
* `Git`_
* `Sphinx`_ (Only if building documentation)

Follow the guide for your platform:

* `Windows`_
* `Mac OS X`_
* `Linux`_

After everything is ready, proceed to `Building`_ for instructions on building and installing OpenCTR.

-------
Windows
-------

.. todo:: Add screenshots to help Windows users.

~~~~~~~~~~~~~~~
I. Requirements
~~~~~~~~~~~~~~~

Download and install `CMake`_ from http://www.cmake.org/download/.

Download and install `Python`_ from https://www.python.org/downloads/windows/.

Download and install `Git`_ from http://git-scm.com/download/win.

Optionally, download the latest ``ninja-win.zip`` from https://github.com/martine/ninja/releases. 
Extract it, and place ``ninja.exe`` in your PATH. Ninja is not *required* but it is *recommended*, 
because it produces much faster build times.

~~~~~~~~~~~~~
II. mingw-get
~~~~~~~~~~~~~

On Windows we'll be using mingw-get to install several dependencies. 

Download `mingw-get-setup.exe`_ from http://sourceforge.net/projects/mingw/files/. 
Open mingw-get-setup.exe and install it. 

After MinGW has been installed, you need to make sure that ``C:\MinGW\bin`` has been added to your 
``PATH``. Open a command prompt (WinKey+R - Type "cmd" - Hit Enter) and enter the following command:

.. code-block:: batch

   mingw-get --help

If you get a message displaying help information for mingw-get, the test succeeded and MinGW is 
installed and ready for use. Otherwise, you still need to add MinGW to your PATH. This can be 
dangerous if done improperly, so you should find a guide for your specific version of Windows.

Afterwards, install several dependencies:

.. code-block:: batch

   mingw-get update
   mingw-get upgrade
   mingw-get install mingw-get 
   mingw-get install gcc 
   mingw-get install g++ 
   mingw-get install msys 
   mingw-get install msys-m4 
   mingw-get install msys-wget 
   mingw-get install msys-patch 
   mingw-get install msys-autoconf 
   mingw-get install msys-automake 
   mingw-get install msys-bash 
   mingw-get install msys-bison 
   mingw-get install msys-flex 
   mingw-get install msys-make 
   mingw-get install msys-libtool 
   mingw-get install msys-gawk
   mingw-get install msys-binutils

To build the OpenCTR documentation, `Sphinx`_ must be installed. Follow the setup instructions 
`here <http://sphinx-doc.org/install.html#windows-install-python-and-sphinx>`__.

--------
Mac OS X
--------

~~~~~~~~~~~~~~~
I. Requirements
~~~~~~~~~~~~~~~

Download and install `CMake`_ from http://www.cmake.org/download/.

Download and install `Python`_ from https://www.python.org/downloads/windows/.

Download and install `Git`_ from http://git-scm.com/download/win.

Alternatively, all 3 dependencies can be installed with Brew: 

.. code-block::

   brew install cmake # or cmake30
   brew install python3
   brew install git

See `Step 3 <III. Brew>`__ for more on installing Homebrew.

~~~~~~~~~
II. Xcode
~~~~~~~~~

Xcode 5 or later is required. Xcode can be installed from the Mac App Store on Snow Leopard (10.6) or later.

After installing Xcode, several command-line tools must be installed. Open Terminal, and enter:

.. code-block:: bash

   xcode-select --install

You should get a popup window asking you to install the developer tools. 
Click "Install" to download and install the Xcode Command Line Tools. 

If you get an error saying that the command line tools are already installed, you can ignore it. 
It just means that you have already installed the Xcode command line tools.

~~~~~~~~~
III. Brew
~~~~~~~~~

Install `Brew.sh`_ - the missing package manager for OS X.

After Homebrew has been installed, use it to automatically fetch and install several required 
dependencies for building OpenCTR.

.. code-block:: bash

   brew install autoconf
   brew install automake
   brew install libtool
   brew install pkg-config
   brew install bash
   brew install bison
   brew install cloog
   brew install doxygen
   brew install gawk
   brew install gcc
   brew install gettext
   brew install gmp
   brew install mpfr
   brew install mpc
   brew install isl
   brew install sphinx
   brew install wget
   brew install ninja

-----
Linux
-----

Your specific instructions depend on which Linux distro you are running. 
If your distro is not listed here, consult the documentation for your distros package manager, 
and install all of the dependencies list listed above.

If your distribution *is* listed here though, just enter the commands listed, and you should be all set.

It is also recommended that users install a terminal emulator (GNOME Terminal, Konsole, Terminology, mxrvt, xterm) 
or an IDE (Code\:\:Blocks, Codelite, Anjuta, Eclipse CDT). This may not be neccessary, as your distro may already 
come with a terminal emulator pre-installed.

~~~~~~~~~~~~~~~~
I. Debian/Ubuntu
~~~~~~~~~~~~~~~~

.. code-block:: bash

   sudo apt-get install build-essential cmake autoconf automake m4 libtool \
                        pkg-config bison doxygen gawk gcc g++ gettext \
                        python3 python3-sphinx wget ninja-build git-core 

~~~~~~~~~~~~~~~~~~
II. Fedora/Red Hat
~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   sudo yum install python3-devel freetype-devel gcc gcc-c++ cmake autoconf \
                    automake make m4 libtool pkgconfig bison doxygen gawk \
                    gettext python3 python-sphinx wget ninja-build git

========
Building
========

WHAT IS WRONG?




.. _CMake: http://www.cmake.org/

.. _Python: https://www.python.org/

.. _autoconf: https://www.gnu.org/software/autoconf/

.. _automake: https://www.gnu.org/software/automake/

.. _libtool: https://www.gnu.org/software/libtool/

.. _m4: https://www.gnu.org/software/m4/

.. _Git: http://git-scm.com

.. _Sphinx: http://sphinx-doc.org/

.. _mingw-get-setup.exe: http://sourceforge.net/projects/mingw/files/mingw-get-setup.exe

.. _Brew.sh: http://brew.sh/

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
