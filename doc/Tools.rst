=====
Tools
=====

All tools used in OpenCTR are found at https://github.com/OpenCTR/OpenCTR-Tools.

========
3dsxtool
========

Imported from https://github.com/devkitPro/3dstools

Used to convert ARM ELF executables into :term:`3DSX`, for running in 
emulators and on consoles.

========
smdhtool
========

Imported from https://github.com/devkitPro/3dstools

Used to create banner files.

======
artool
======

Converts any binary resource (including text files) directly into 
ARM ELF Objects. Key word here is *directly*. Instead of converting 
the binary code into a C/ASM array like bin2c and bin2s, artool 
uses libelf to directly embed the binary data into an object file 
for linking.

