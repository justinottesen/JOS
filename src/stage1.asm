;
; stage1.asm - The bootloader for JOS
;
; This is the bootloader, which is loaded into memory and executed by the BIOS. It loads the first
; sector of each bootable device, checking for the boot signature, which is 0x55, 0xAA at offsets
; 510 and 511, the last two bytes in the 512 byte sector. This space restriction means that the
; bootloader is separated into two stages. The purpose of stage 1 is to load stage 2 into memory.
;
; Stage 1 is loaded to the address 0x7c00. The memory from 0x500 to 0x7FFFF is available to use.
; We will set up the stack to grow downward from 0x7c00 (towards 0x500), and stage 2 will be loaded
; at 0x7e00. This gives us 29.75 KiB of stack space and 480.5 KiB for stage 2, with stage 1 taking
; the middle 512 bytes from 0x7c00 to 0x7dff.
;

[bits 16]                   ; The bootloader is ran in 16-Bit Real mode
[org 0x7c00]                ; Tells the assembler this code will be loaded at 0x7c00

;
; Some BIOSes load to 0x07c0:0x0000 instead of 0x0000:0x7c00, this is the same physical address:
;
;       Physical Address = CS * 0x10 + IP
;                 0x7c00 = 0x07c0 * 0x10 + 0x0
;
; This can cause problems with relative addressing for short jumps, so we do a far jump to
; explicitly reset these registers. Here, we also reset the other segment regsters to 0 because
; the entire stage 1 bootloader is in sector 0.
;
start:
    ; Setup the data segments - BIOS leaves in undetermined state
    xor ax, ax              ; We cannot set ds and es directly in real mode
    mov ds, ax              ; Clear data segment
    mov es, ax              ; Clear extra segment

    ; Setup the stack
    mov ss, ax              ; Clear stack segment
    mov sp, 0x7c00          ; Initialize stack pointer

    ; Print a message indicating we are entering stage 1
    mov si, msg_enter_stage1
    call puts

    ; Load stage 2 bootloader
    mov ax, 0x07e0          ; Data segment to read to
    mov es, ax
    mov bx, 0x0000          ; Offset within segment
    mov ah, 0x02            ; Read disk in CHS mode
    mov al, 0x01            ; Read 1 sector
    mov ch, 0x00            ; Read on cylinder 0
    mov cl, 0x02            ; Read on sector 2
    mov dh, 0x00            ; Head number 0
    int 0x13

    jc disk_error           ; jump if Carry Flag set (failure)

    ; Print success message
    mov si, msg_success
    call puts
    jmp after_disk_read

disk_error:
    mov si, msg_failure
    call puts
    jmp halt

after_disk_read:
    ; Jump to stage 2
    jmp 0x7e0:0x00

;
; We should not reach this point
;
halt:
    cli                     ; Disable hardware interrupts
    hlt                     ; Halt the CPU
    jmp halt                ; Loop in case we somehow start again

%include "io.asm"

msg_enter_stage1: db 'Entering stage 1...', ENDL, 0
msg_success: db 'Disk read success', ENDL, 0
msg_failure: db 'Disk read FAILED!', ENDL, 0

;
; The BIOS looks for 0x55 and 0xAA at bytes 510 and 511 to indicate this is a bootloader. We fill
; bytes until we hit 510 with 0, then add 0x55 and 0xAA. We do this with the following:
;
;               510-($-$$) db 0
;
;   510: Goal position to fill to
;   $: Special symbol for current address
;   $$: Special symbol for start address of the section
;
times 510-($-$$) db 0
dw 0AA55h
