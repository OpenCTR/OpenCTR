===============
Getting Started
===============

Your guide to downloading OpenCTR and getting it up and running. 

First, download the latest version of OpenCTR from :doc:`Releases` for your platform. 
Users interested in building OpenCTR from source should read the :doc:`Building` guide. 

If you downloaded a zip or tar archive, read `Setup`_. 
If you downloaded a package installer, then skip to `Post Setup`_. 

=====
Setup
=====

After extracting OpenCTR, you should end up with a directory named OpenCTR-X.Y.Z, where X.Y.Z is the release version number (e.x. `OpenCTR-1.2.3.zip` should give you `OpenCTR-1.2.3/`).

First, if you want to be able to install updates without needing to change any settings, you should probably rename the `OpenCTR-X.Y.Z/` directory to something like `OpenCTR/`. Otherwise, you will have to change your environment settings every time you want to download a new version of OpenCTR.

Move the OpenCTR directory, whatever it is named, to where-ever you want it to reside. If you want OpenCTR to be in `Program Files`, put `OpenCTR` inside `C:\Program Files` (so you should end up with `C:\Program Files\OpenCTR`). Linux/UNIX users (including OSX users) should probably place the OpenCTR directory somewhere like `/usr/local/OpenCTR` or `/opt/OpenCTR`.

Now that OpenCTR has been installed to your filesystem, read `Post Setup`_ for information about setting up your environment to use OpenCTR.

==========
Post Setup
==========

After OpenCTR has been installed, several environment settings must be changed before OpenCTR can be used automatically (without manual setup with each use). 

OpenCTR software (including apps and games) are built using CMake. The details of using CMake with OpenCTR are described in :doc:`CMake`. 

But for CMake to be able to find and use the OpenCTR toolchain automatically, it needs a reference to where OpenCTR is installed. There are two ways to accomplish this:
  1. Adding `OpenCTR/bin` to the `PATH` environment variable.
  2. Creating a new environment variable named `CTR_ROOT` and setting it to the root install dir of OpenCTR.

The automated installers for Windows and OSX _should_ take care of this automatically (although it wouldn't kill you to check for yourself). If you have no idea how to do either step (in which case, you are probably a Windows user), you should be using the automatic installer.

Options 1 and 2 are not mutually exclusive. That is, it is perfectly okay to have both options setup at the same time.

