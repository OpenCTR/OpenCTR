========
Releases
========

As of 04-01-2015, OpenCTR is still in beta, with no public releases available yet.

When OpenCTR has reached a more mature state, releases will be uploaded to GitHub, with mirrors available on sites like Mega.co, CloudFlare, MediaFire, RapidShare, MaxCDN, and Sendspace.

OpenCTR is released as both :ref:`binary <binary_releases>` and :ref:`source <source_releases>` releases.

.. _binary_releases:

===============
Binary Releases
===============

Binary releases are available on GitHub, with mirrors available elsewhere.

.. warning:: As mentioned above, there are no binary releases yet because OpenCTR is still in beta.

---------
Toolchain
---------

Binary releases for tools such as ``3dsxtool``, ``smdhtool``, and the GNU Compiler Toolchain are made available for the following platforms:
  + Windows (XP or later)
  + Mac OS X (10.6 or later)
  + Linux (i386 and AMD64)

Please remember that binary releases for your platform may have been compiled using a cross-compiler (ex. i686-unknown-mingw32-gcc on a Mac OS X host). This may cause problems, and may result in a binary toolchain release that is broken and unusable on your machine. Please be patient and we will try to fix these problems when they occur.

The OpenCTR toolchain is made available in the following formats:
  + XZ-Compressed tarball archive (.tar.xz)
  + ZIP archive (.zip)
  + Windows NSIS Installer (.msi)
  + Mac OS X Package (.pkg)
  + Debian GNU/Linux Package (.deb)
  + Red Hat/Fedora Package (.rpm)

The various installer packages (.msi, .pkg, .rpm) may not be available for every release, but the tar.xz and zip archives will always be made available for every release.

Debian and Red Hat packages are automatically generated and uploaded, but are not a part of any repository at this time.

---------
Libraries
---------

Unlike the toolchain, a binary release of an OpenCTR library is never platform specific. Libraries (such as libctr) are cross-compiled to ARM, meaning it makes no difference if the library was created on e.g. Windows and then used on e.g. Linux.

A typical library release package contains one or header files, and one or more static library files. Often, these files will be inside subdirectories, and it can be important that they be installed with the same name and location.

Libraries are usually released as both tar.xz and zip archives. UNIX-Like users (including Mac OS X) should download tar.xz files, while Windows users should download the zip archive. After downloading the release, extract it into the installation folder, usually the root of OpenCTR.

Binary releases of the OpenCTR toolchain usually have libraries like libctr bundled, but the user will still need to install any future updates themselves.

.. _source_releases:

====================
Source Code Releases
====================

The latest development source code of all OpenCTR projects can be found on GitHub at `https://github.com/OpenCTR/ <https://github.com/OpenCTR/>`__.

Source code releases are available on GitHub, with mirrors available at TBD.

The source code for a particular version may be checked out from GitHub as a tag. For example, to download libctr version 1.0.5, you would use ``git clone -b v1.0.5 https://github.com/OpenCTR/libctr.git libctr-1.0.5``.

OpenCTR libraries are released as tar.xz and zip archives. The tar.xz archives use UNIX line-encoding for source files, while zip archives use Windows style line-encoding.

