========
Glossary
========

.. glossary::

  C
    Programming Language originally created by Dennis Ritchie in 1972. One of the 
    most popular programming languages of all time, it is also one of 
    the most influential. C++, Java, Javascript, and Python all inherit
    from the syntax, if not the style, of C. The most recent ISO standard
    of C was released in 2011, and is often refered to as C11. Indisputably 
    the king of systems and embedded development, C is the primary language 
    used by OpenCTR projects.

  C++
    Extension of :term:`C` designed to add Object-Oriented features. Because 
    all valid C code is also valid C++, software compatible with both C and 
    C++ will often refer to both as C/C++. More widely known than C in 
    most mainstream development, C++ is not suitable for developing the 
    system level programming that makes up OpenCTR, due to its runtime 
    requirements, heavier overhead, and greater binary size. Still perfectly 
    okay to use C++ when developing your own applications though. An 
    object-oriented wrapper for libctr is forthcoming.

  Citra
    http://citra-emu.org/. 
    Cross-platform Nintendo 3DS emulator (without stereoscopic 3D support though). 
    Written in Qt4. 
    More actively developed than :term:`3dmoo`. 

  3dmoo
    https://github.com/plutooo/3dmoo.
    Alternative to :term:`Citra`. 
    Less support for commercial games, but more hardware accurate emulation.

  3DSX
    File format for Nintendo 3DS homebrew. Able to be executed on any 
    homebrew-enabled Nintendo 3DS console, as well as the :term:`Citra` 
    and :term:`3dmoo` emulators. For more information about 3DSX, see 
    http://3dbrew.org/wiki/3DSX_Format.

  Clang
    A relative new-comer to the world of compilers, LLVM was originally 
    the Low Level Virtual Machine developed by Chris Lattner as a university 
    thesis project. Since then, LLVM has been backed by Apple and Google, 
    among others, and developed into a C/C++ compiler capable of rivaling 
    GCC. Having risen to the same heights that it took GCC 25 years to 
    reach in 7 years, LLVM/Clang support will be coming to OpenCTR soon.

  GCC
    The GNU Compiler Collection (originally called the GNU C Compiler) has 
    been the defacto cross-compiler of choice for the past 20+ years. 
    Although GCC has faced competition in recent years, in the form of 
    :term:`Clang`, GCC remains the most powerful and versatile compiler for 
    many architectures and platforms. Hence its status as the default 
    cross-compiler for OpenCTR.
