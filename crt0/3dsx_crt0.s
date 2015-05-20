@-------------------------------------------------------------------------------
@ Nintendo 3DS C RunTime - CRT0
@ 
@ Startup code for the ARM11 MPCore of the Nintendo 3DS.
@
@ This code was originally derived from ctrulib and devkitPro.
@ 
@ TODO: Add Guru handler, and/or Exception handler.
@-------------------------------------------------------------------------------

@-------------------------------------------------------------------------------
@ OpenCTR - A free and open-source SDK for Nintendo 3DS homebrew. 
@ 
@ Copyright (C) 2015 The OpenCTR Project. 
@ 
@ This file is part of OpenCTR. 
@ 
@ OpenCTR is free software: you can redistribute it and/or modify 
@ it under the terms of the GNU General Public License version 3 as 
@ published by the Free Software Foundation.
@ 
@ OpenCTR is distributed in the hope that it will be useful, 
@ but WITHOUT ANY WARRANTY; without even the implied warranty of
@ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
@ GNU General Public License for more details.
@ 
@ You should have received a copy of the GNU General Public License 
@ along with OpenCTR. If not, see <http://www.gnu.org/licenses/>.
@-------------------------------------------------------------------------------

@-------------------------------------------------------------------------------
@ Nintendo 3DS processor
@  - ARM Architecture: ARMv6k
@  - ARM CPU: MPCore
@  - FPU: VFPv2
@  - Mode: ARM 32-Bit
@-------------------------------------------------------------------------------
	.arch armv6k
	.cpu mpcore
	.fpu vfp
	.arm
	.align 2

@-------------------------------------------------------------------------------
@ CRT0 symbols
@-------------------------------------------------------------------------------
	.section ".crt0"
	.global _start
	.global __service_ptr
	.global __apt_appid
	.global __heap_size
	.global __linear_heap_size
	.global __system_arglist
	.global __system_runflags

@-------------------------------------------------------------------------------
@ Program entry point
@-------------------------------------------------------------------------------
_start:
	b startup
	.ascii "_prm"

@-------------------------------------------------------------------------------
@ Symbol to hold a list of kernel services.
@-------------------------------------------------------------------------------
__service_ptr:
	@ Pointer to service handle override list
	@ if non-NULL it is assumed that we have launched from hbmenu
	.word 0

@-------------------------------------------------------------------------------
@ Symbol to hold the Program APPID.
@-------------------------------------------------------------------------------
__apt_appid:
	.word 0x300

@-------------------------------------------------------------------------------
@ Default heap size -- 24 MiB
@-------------------------------------------------------------------------------
__heap_size:
	.word 24*1024*1024

@-------------------------------------------------------------------------------
@ Default linear heap size -- 32 MiB
@-------------------------------------------------------------------------------
__linear_heap_size:
	.word 32*1024*1024

@-------------------------------------------------------------------------------
@ Symbol for initializing <code>argc</code>
@-------------------------------------------------------------------------------
__system_arglist:
	@ Pointer to argument list
	@ uint32_t argc, followed by that many NULL terminated strings
	.word 0

@-------------------------------------------------------------------------------
@ Flags to signal runtime restrictions
@-------------------------------------------------------------------------------
__system_runflags:
	.word 0

@-------------------------------------------------------------------------------
@ Deferred startup function
@-------------------------------------------------------------------------------
startup:
	@ Save return address
	mov r4, lr

	@ Clear the BSS section
	ldr r0, =__bss_start__
	ldr r1, =__bss_end__
	sub r1, r1, r0
	bl  ClearMem

	@ System initialization
	mov r0, r4
	bl initSystem

	@ Set up argc/argv arguments for main()
	ldr r0, =__system_argc
	ldr r1, =__system_argv
	ldr r0, [r0]
	ldr r1, [r1]

	@ Jump to user code
	ldr r3, =main
	ldr lr, =__ctru_exit
	bx  r3

@-------------------------------------------------------------------------------
@ Clear memory to 0x00 if length != 0
@  r0 = Start Address
@  r1 = Length
@-------------------------------------------------------------------------------
ClearMem:
	@ Round down to nearest word boundary
	mov r2, #3
	@ Safety check.
	add r1, r1, r2
	@ Clear 2 LSB (and set Z).
	bics r1, r1, r2
	@ Quit if copy size is 0.
	bxeq lr
	@ Set r2 to hold 0x00
	mov r2, #0
	@ Continues below in ClrLoop


@-------------------------------------------------------------------------------
@ Helper function used by ClearMem above.
@-------------------------------------------------------------------------------
ClrLoop:
	@ Move 0x00 into the start address
	stmia r0!, {r2}
	@ Decrement the size.
	subs r1, r1, #4
	@ Repeat as needed
	bne ClrLoop
	@ Break the loop
	bx lr

