OUTPUT_FORMAT(elf32-i386) /* output standard format for OS kernels */
ENTRY(_start) /* _start from boot.s */
SECTIONS {
   . = 0x100000; /* standardized for 32-bit Protected Mode */
   .text    : { KEEP(*(.multiboot)) *(.text) } /* code */
   .data    : { *(.data) } /* initialized data */
   .rodata  : { *(.rodata)  } /* read only data */
   .bss     : { *(.bss)  } /* variables with no starting value (or are set to zero) */
}