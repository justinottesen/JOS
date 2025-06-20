;
; io.asm - Contains useful IO functions like puts
;

%ifndef _IO_ASM_
%define _IO_ASM_

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

%endif