; --- MULTIBOOT2 HEADER ---
section .multiboot
align 8 ; looks at every 8 bytes to find magic number
header_start:
    dd 0xE85250D6                ; Magic number
    dd 0                         ; i386 32-bit Protected Mode
    dd header_end - header_start ; Header length (how much data to read)
    ; Checksum
    dd -(0xE85250D6 + 0 + (header_end - header_start))
    ; End tag
    dw 0    ; type
    dw 0    ; flags
    dd 8    ; size
header_end:

; --- KERNEL CODE ---
section .text
global _start ; export _start
extern kmain ; note that kmain is defined in the cpp file

; interrupts disabled; 32-bit mode enabled
_start:
    ; Need to set up environment immediately.
    
    mov esp, stack_top       ; Initialize stack
    
    ; Bootloader automatically pushes magic value and memory address into stack
    push ebx    
    push eax    

    call kmain ; call this function

    cli ; if kmain returns -> stop CPU
.hang:
    hlt         ; stop CPU
    jmp .hang   ; infinite loop if non-maskable interrupt (something that can't be ignored) wakes the CPU 

; --- UNINITIALIZED DATA ---
section .bss ; avoid unnecessarily writing a bunch of 0s
align 16 ; Modern CPUs grab 16 bytes at a time
stack_bottom: ; stacks grow towards lower memory addresses
    resb 0x4000 ; 16 KB stack
stack_top:
section .note.GNU-stack noalloc noexec nowrite progbits ; for modern compatability