;
; stage2.asm - The second stage of the bootloader
;
; This is loaded in by stage 1 at the address 0x7e00. For now, just a printed message to show that
; this worked.
;

[bits 16]                   ; Still in 16-Bit Real mode
[org 0x7e00]                ; Loaded just after stage 1 is

start:
    mov si, msg_enter_stage2
    call puts

halt:
    cli                     ; Disable hardware interrupts
    hlt                     ; Halt the CPU
    jmp halt                ; Loop in case we somehow start again

%include "io.asm"

msg_enter_stage2: db 'Entering stage 2...', ENDL, 0

;
; We want to fill the rest of the sector here just in case, the `dd` command in the Makefile
; probably takes care of it but just to be safe
;
times 512-($-$$) db 0
