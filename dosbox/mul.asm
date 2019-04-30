format MZ
entry CSEG:main

stack 100h

segment CSEG
main: 
    mov ax, 0
    mov bx, 5
    mov cx, 5

_mul:
    add ax, bx
    dec cx
    cmp cx, 0
    jne _mul

    mov dx, ax
    mov ax, 09
    int 21
    int 20