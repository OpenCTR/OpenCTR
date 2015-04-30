================
3DSX File Format
================

The 3DSX file format is a relocatable and executable binary format used for Nintendo 3DS Homebrew software.

For more information about the 3DSX format, see http://3dbrew.org/wiki/3DSX_Format.

===================
Creating 3DSX Files
===================

3dsxtool is used to convert binary ELF executables into 3DSX format. 
Because 3dsxtool is invoked by CMake, through the ``ctr_convert_binary`` function, 
most ordinary users will not need to invoke 3dsxtool directly.
For more about 3dsxtool, see :doc:`Tools`.

=============
Specification
=============

3DSX is not a formally defined specification.

3DSX is a derivative of the Executable Linkable Format standard. 
Refer to the offical `ELF`_ specification and the `ELF for ARM`_ ABI addendum for more information about the ELF standard.

3DSX differs from the ELF standard in the following ways:
  + 3DSX is currently not a formally defined standard.
  + The 3DSX format only supports a fixed number of sections.
  + The 3DSX format only defines an executable object.
    - Shared object files and relocatable object files are not supported.
    - The 3DSX executable object itself is relocatable.
  + It only supports a fixed number of sections. 
  + Only defines relocatable, statically-linked executables. No shared libraries, or modules. 
  + Restricted to 32-Bit ARM platforms.
  + No debugging support features.


.. _ELF: http://www.sco.com/developers/gabi/2003-12-17/contents.html

.. _ELF for ARM: http://infocenter.arm.com/help/topic/com.arm.doc.ihi0044e/IHI0044E_aaelf.pdf

