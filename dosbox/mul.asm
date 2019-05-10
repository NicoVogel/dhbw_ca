format MZ
entry CSEG:main

stack 100h
;------------------------------------------
segment DSEG

segment CSEG
main: 
    push 0005h
    push 0005h

    call CSEG2:func_mul
    add sp, 4

    mov dx, ax

    mov ax, 4c01h   
    int 21h

segment CSEG2
func_mul:
    push bp
    mov bp, sp

    pushf    
    push bx
    push cx

    ; 4 bytes are used for the return (ip) and bp from the calling function 
    mov cx, [bp + 4 + 4]    ; first param
    mov bx, [bp + 4 + 2]    ; second param

    ; program start
    mov ax, 0
_mul:
    add ax, bx
    dec cx
    jnz _mul

    ; program end

    pop cx
    pop bx
    popf

    mov sp, bp
    pop bp
    retf
