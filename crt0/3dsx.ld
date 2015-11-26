/*
 *******************************************************************************
 * OpenCTR - A free and open-source SDK for Nintendo 3DS homebrew.
 *
 * Copyright (C) 2015 The OpenCTR Project.
 *
 * This file is part of OpenCTR.
 *
 * OpenCTR is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 3 as published by
 * the Free Software Foundation.
 *
 * OpenCTR is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OpenCTR. If not, see <http://www.gnu.org/licenses/>.
 *******************************************************************************
*/

/**
 * @file 3dsx.ld
 * @brief Linker memory layout file for the Nintendo 3DS.
 * 
 * @note This code was originally derived from ctrulib.
 */
OUTPUT_FORMAT("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)

PHDRS {
    code PT_LOAD FLAGS(5);   /* Read | Execute */
    rodata PT_LOAD FLAGS(4); /* Read */
    data PT_LOAD FLAGS(6);   /* Read | Write */
}

SECTIONS {
    /* ---------- CODE section ---------- */

    . = 0x100000;
    __start__ = . ;

    .text ALIGN(0x1000) : {
        /* .init */
        KEEP( *(.crt0) )
        KEEP( *(.init) )
        . = ALIGN(4);

        /* .text */
        *(.text)
        *(.text.*)
        *(.glue_7)
        *(.glue_7t)
        *(.stub)
        *(.gnu.warning)
        *(.gnu.linkonce.t*)
        . = ALIGN(4);

        /* .fini */
        KEEP( *(.fini) )
        . = ALIGN(4);
    } : code

    /* ---------- RODATA section ---------- */

    .rodata ALIGN(0x1000) : {
        *(.rodata)
        *(.roda)
        *(.rodata.*)
        *all.rodata*(*)
        *(.gnu.linkonce.r*)
        SORT(CONSTRUCTORS)
        . = ALIGN(4);
    } : rodata

    .ARM.extab : { *(.ARM.extab* .gnu.linkonce.armextab.*) } : rodata
    __exidx_start = .;
    ARM.exidx : { *(.ARM.exidx* .gnu.linkonce.armexidx.*) } : rodata
    __exidx_end = .;

    /* ---------- DATA section ---------- */

    .data ALIGN(0x1000) : {
        *(.data)
        *(.data.*)
        *(.gnu.linkonce.d*)
        CONSTRUCTORS
        . = ALIGN(4);
    } : data

    .preinit_array ALIGN(4) : {
        PROVIDE (__preinit_array_start = .);
        KEEP (*(.preinit_array))
        PROVIDE (__preinit_array_end = .);
    } : data

    .init_array ALIGN(4) : {
        PROVIDE (__init_array_start = .);
        KEEP (*(SORT(.init_array.*)))
        KEEP (*(.init_array))
        PROVIDE (__init_array_end = .);
    } : data

    .fini_array ALIGN(4) : {
        PROVIDE (__fini_array_start = .);
        KEEP (*(.fini_array))
        KEEP (*(SORT(.fini_array.*)))
        PROVIDE (__fini_array_end = .);
    } : data

    .ctors ALIGN(4) : {
        KEEP (*crtbegin.o(.ctors)) /* MUST be first -- GCC requires it */
        KEEP (*(EXCLUDE_FILE (*crtend.o) .ctors))
        KEEP (*(SORT(.ctors.*)))
        KEEP (*(.ctors))
    } : data

    .dtors ALIGN(4) : {
        KEEP (*crtbegin.o(.dtors))
        KEEP (*(EXCLUDE_FILE (*crtend.o) .dtors))
        KEEP (*(SORT(.dtors.*)))
        KEEP (*(.dtors))
    } : data

    __bss_start__ = .;

    .bss ALIGN(4) : {
        *(.dynbss)
        *(.bss)
        *(.bss.*)
        *(.gnu.linkonce.b*)
        *(COMMON)
        . = ALIGN(4);
    } : data
    __bss_end__ = .;

    __end__ = ABSOLUTE(.);

    /* ---------- Metadata ---------- */

    /* Discard sections that make post-processing difficult */
    /DISCARD/ : { *(.group .comment .note) }

    /* Stabs debugging sections. */
    .stab          0 : { *(.stab) }
    .stabstr       0 : { *(.stabstr) }
    .stab.excl     0 : { *(.stab.excl) }
    .stab.exclstr  0 : { *(.stab.exclstr) }
    .stab.index    0 : { *(.stab.index) }
    .stab.indexstr 0 : { *(.stab.indexstr) }

    /* DWARF debug sections */

    /* DWARF 1 */
    .debug          0 : { *(.debug) }
    .line           0 : { *(.line) }

    /* GNU DWARF 1 extensions */
    .debug_srcinfo  0 : { *(.debug_srcinfo) }
    .debug_sfnames  0 : { *(.debug_sfnames) }

    /* DWARF 1.1 and DWARF 2 */
    .debug_aranges  0 : { *(.debug_aranges) }
    .debug_pubnames 0 : { *(.debug_pubnames) }

    /* DWARF 2 */
    .debug_info     0 : { *(.debug_info) }
    .debug_abbrev   0 : { *(.debug_abbrev) }
    .debug_line     0 : { *(.debug_line) }
    .debug_frame    0 : { *(.debug_frame) }
    .debug_str      0 : { *(.debug_str) }
    .debug_loc      0 : { *(.debug_loc) }
    .debug_macinfo  0 : { *(.debug_macinfo) }
}
