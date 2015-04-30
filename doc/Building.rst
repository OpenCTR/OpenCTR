================
Building OpenCTR
================

This page is for users who wish to download and build OpenCTR from source. 
Normal users should download a pre-built binary at :doc:`Releases`.

Even when building and installing OpenCTR from source, remember to add the runtime install 
directory to the PATH variable, or to create a new environment variable named 
``CTR_ROOT`` which contains the root install directory for OpenCTR.

===============
Getting Started
===============

To build the OpenCTR SDK from source, the following prerequisites must be installed:

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

~~~~~~~~~~~~
Requirements
~~~~~~~~~~~~

Download and install `CMake`_ from http://www.cmake.org/download/.

Download and install `Python`_ from https://www.python.org/downloads/windows/.

Download and install `Git`_ from http://git-scm.com/download/win.

Optionally, download the latest ``ninja-win.zip`` from https://github.com/martine/ninja/releases. 
Extract it, and place ``ninja.exe`` in your PATH. Ninja is not *required* but it is *recommended*, 
because it produces much faster build times.

~~~~~~~~~
mingw-get
~~~~~~~~~

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

~~~~~~~~~~~~
Requirements
~~~~~~~~~~~~

Download and install `CMake`_ from http://www.cmake.org/download/.

Download and install `Python`_ from https://www.python.org/downloads/windows/.

Download and install `Git`_ from http://git-scm.com/download/win.

Alternatively, all 3 dependencies can be installed with Brew: 

.. code-block:: bash

   brew install cmake # or cmake30
   brew install python3
   brew install git

See `Brew`_ for more on installing Homebrew.

~~~~~
Xcode
~~~~~

Xcode 5 or later is required. Xcode can be installed from the Mac App Store on Snow Leopard (10.6) or later.

After installing Xcode, several command-line tools must be installed. Open Terminal, and enter:

.. code-block:: bash

   xcode-select --install

You should get a popup window asking you to install the developer tools. 
Click "Install" to download and install the Xcode Command Line Tools. 

If you get an error saying that the command line tools are already installed, you can ignore it. 
It just means that you have already installed the Xcode command line tools.

~~~~
Brew
~~~~

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

~~~~~~~~~~~~~
Debian/Ubuntu
~~~~~~~~~~~~~

.. code-block:: bash

   sudo apt-get install build-essential cmake autoconf automake m4 libtool \
                        pkg-config bison doxygen gawk gcc g++ gettext \
                        python3 python3-sphinx wget ninja-build git-core 

~~~~~~~~~~~~~~
Fedora/Red Hat
~~~~~~~~~~~~~~

.. code-block:: bash

   sudo yum install python3-devel freetype-devel gcc gcc-c++ cmake autoconf \
                    automake make m4 libtool pkgconfig bison doxygen gawk \
                    gettext python3 python-sphinx wget ninja-build git

========
Building
========

------------------------
1. Clone the GitHub Repo
------------------------

.. code-block:: bash

   git clone https://github.com/OpenCTR/OpenCTR.git OpenCTR
   cd OpenCTR

-----------------------
2. Create the build dir
-----------------------

CMake works best with out-of-source builds, so create a separate build directory.

.. code-block:: bash

   mkdir build
   cd build

-----------------------------------
3. Generate build files using CMake
-----------------------------------

Use CMake to generate the build files for downloading, configuring, building, and 
installing the OpenCTR sub-projects. It is recommended to use a "Makefile" or 
"Ninja" generator for CMake; it increases the chances of a successful build.

CMake uses the value of ``CMAKE_INSTALL_PREFIX`` to decide where to install OpenCTR. 
OpenCTR installs everything to a sub-directory named ``OpenCTR``. For example, if 
``CMAKE_INSTALL_PREFIX`` is set to ``$HOME/Install``, then OpenCTR will be installed 
to ``$HOME/Install/OpenCTR``.

.. code-block:: bash

   cmake .. -G "Ninja" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local

CMake will check to make sure all dependencies are satisfied. If a required package could not be found, 
CMake will exit with an error message. Just fix whatever the problem was, and re-run CMake.

One of the benefits of out-of-source builds is that removing generated build files and cruft 
can be done by simply running ``rm -rf *``. **DO NOT RUN THIS IN AN IN-SOURCE BUILD**. It will 
delete all your source files if you run it from inside the source dir. But if the build dir 
is separate from the source dir, the entire build dir can be deleted to completely wipe out 
all traces of the previous build.

----------------
4. Build OpenCTR
----------------

After CMake has finished generating the build files, it is time to build OpenCTR.

.. code-block:: bash

   ninja

Wait for OpenCTR to finish building. This can take awhile, up to several hours depending on your machine. 

------------------
5. Install OpenCTR
------------------

Assuming Step 4 was successful, it is now time to install OpenCTR system-wide.

.. code-block:: bash

   ninja install

Be sure to add ``OpenCTR/bin`` to your PATH.


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

