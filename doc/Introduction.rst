=======================
Introduction to OpenCTR
=======================

Welcome to OpenCTR.

The OpenCTR project is a collection of tools designed to make developing homebrew for the Nintendo 3DS be not only possible, but easy. Developed entirely by the community, OpenCTR is free and open-source, created without any involvement from Nintendo |reg|. 

It should be warned: OpenCTR may not be ready for everyone just yet. Many parts of OpenCTR are still immature, and most of the projects target very low-level development. If you want to use OpenCTR, it recommended that you have some experience with C/C++. Of course, this is not intended to be the case forever and always. The reason that higher level libraries and tools have not been created yet is because the lower-level libraries and tools haven't been finished yet. High-level programming languages are built on-top of lower-level ones. Since many parts of the lower half of OpenCTR haven't been finalized yet, it doesn't make since to start working on anything higher level.

The reason development on the OpenCTR toolchain and tool levels has not been finished yet is because OpenCTR maintains a high commitment to quality. When everything is ready, we expect OpenCTR to be able to compete with the official Nintendo 3DS developers kit.

The developers of OpenCTR distance themselves from any form of access to the offical Nintendo 3DS developers kit. We do not condone piracy, nor intellectual theft. Because of this, everything in OpenCTR has been either taken from the open-source community (with due acknowledgements) or clean-written from scratch.

But we are aware of one fact about the official Nintendo developer kit: It is Windows only and exclusively C++ Class based. Originally an accidental coincidence, though now intentional and deliberate, OpenCTR is cross-platform, and largely language agnostic.

For maximum cross-platform compatibility, OpenCTR uses CMake_ as the offical build system. CMake is a cross-platform build system that generates project build files. With support for Microsoft Windows, Mac OS X, and GNU/Linux, CMake is clearly the build system of choice for avoiding discriminating against any Operating System. And with support for command-line Makefiles and IDE projects (including Visual Studio and XCode), CMake even avoids discriminating between developers who prefer the command-line, and those that use an IDE for development.

C++ has a long-known and documented history of being difficult to integrate with other languages. libctr (the OpenCTR library) is written in pure ANSI C99, with some special features (as you will see later). There are dozens of ways to export C types and routines for use by other languages. Haskell, Java, Python, Lua, Ruby, Go, Rust. Every modern language has _some_ way of interacting with C libraries. Because libctr is written in C, it is much easier to provide wrappings to third-party supported languages.

With that, we hope you will enjoy OpenCTR.

.. include:: <isonum.txt>

.. _CMake: http://www.cmake.org/

