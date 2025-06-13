;
; boot.asm - The bootloader for JOS
;

[bits 16]           ; The bootloader is ran in 16-Bit Real mode
[org 0x7c00]        ; Tells the assembler this code will be loaded at 0x7c00

;
; Some BIOSes load to 0x07c0:0x0000 instead of 0x0000:0x7c0, this is the same physical address:
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

    ; Far jump to properly initialize CS and IP
    push es                 ; Set return sector to 0
    push word .jump         ; Set offset to .jump label
    retf                    ; Follow pushed address on stack

.jump:
    ; For now, just print a hello world message
    mov si, msg_enter_stage1
    call puts

    cli                     ; Disable hardware interrupts
halt:
    hlt                     ; Halt the CPU
    jmp halt                ; Loop in case we somehow start again

;
; Prints a string to the screen
; Params:
;   - ds:si points to string
;
puts:
    push si
    push ax
    push bx

.loop:
    lodsb                   ; Loads the next character in al
    or al, al               ; Check if we are at null terminator
    jz .done

    mov ah, 0x0e            ; Bios interrupt to display a char
    mov bh, 0               ; Set page number to 0
    int 0x10                ; Call interrupt to video display

    jmp .loop

.done:
    pop bx
    pop ax
    pop si
    ret

%define ENDL 0x0d, 0x0a

msg_enter_stage1: db 'Entering stage 1...', ENDL, 0

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
