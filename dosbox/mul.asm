format MZ
entry CSEG:main

stack 100h
;------------------------------------------
segment DSEG

res db 0

segment CSEG
main: 
    push 0005h
    push 0005h

    call CSEG2:func_mul

    pop dx
    mov ax, 09
    int 21
    int 20

segment CSEG2
func_mul:
    ; manage parameter and adresses
    push bp
    mov bp, sp
    pushf
    
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

    ; manage return back
    popf
    mov sp, bp
    pop bp

    ; store result in stack
    pop bx                  ; return address from caller
    push ax                 ; save result
    push bx                 ; save return address from caller

    ret
