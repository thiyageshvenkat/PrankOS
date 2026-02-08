OUTPUT_FORMAT(elf32-i386) /* output standard format for OS kernels */
ENTRY(_start)             /* _start from boot.s */

/* Program headers (segments) to avoid one giant RWX LOAD segment */
PHDRS {
  text PT_LOAD FLAGS(5); /* 5 = R(4) + X(1) -> read + execute (code/rodata/multiboot header) */
  data PT_LOAD FLAGS(6); /* 6 = R(4) + W(2) -> read + write (data/bss/stack) */
}

SECTIONS {
   . = 0x00100000; /* load kernel at 1 MiB (common for 32-bit protected-mode kernels) */

   /* --- MULTIBOOT2 HEADER ---
      Must be within the first 32 KiB of the image. Doesn't have to be at offset 0.
      Keeping it early and aligned avoids GRUB/QEMU headaches. */
   .multiboot ALIGN(8) : {
      KEEP(*(.multiboot)) /* keep header even if not referenced */
   } :text

   /* --- KERNEL CODE --- */
   .text ALIGN(4K) : {
      *(.text*)           /* code */
   } :text

   /* --- READ-ONLY DATA --- */
   .rodata ALIGN(4K) : {
      *(.rodata*)         /* read only data */
   } :text

   /* --- INITIALIZED DATA --- */
   .data ALIGN(4K) : {
      *(.data*)           /* initialized data */
   } :data

   /* --- UNINITIALIZED DATA / BSS --- */
   .bss ALIGN(4K) : {
      *(COMMON)           /* common symbols (just in case) */
      *(.bss*)            /* variables with no starting value (or are set to zero) */
   } :data

   /* Drop toolchain metadata we don't want in a freestanding kernel */
   /DISCARD/ : {
      *(.eh_frame*)       /* exception unwind info (we disabled exceptions anyway) */
      *(.comment*)
      *(.note*)
   }
}