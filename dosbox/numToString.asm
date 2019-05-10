format MZ
entry CSEG:main

stack 100h
;------------------------------------------



segment CSEG
main: 
    push 000Fh

    call CSEG2:func_numtostring
    add sp, 2

    mov ds, dx
    mov dx, ax

    mov ah, 9h
    int 21h         ; output string from DS:DX

    mov ah, 10h     
    int 16h         ; read keystroke from extended keyboard

    mov ax, 4c01h   
    int 21h         ; exit program, but dont close console
    
segment CSEG2

    ; constants
    ascii_num_start equ 48
    ascii_string_ende equ 36

func_numtostring:
    push bp
    mov bp, sp
    sub sp, 5
    
    pushf
    push bx
    push cx
    push ds
    push si
    
    ; set datasegment
    mov ax, DSEG
    mov ds, ax

    ; get number parameter
    mov ax, [bp + 4 + 2]
    mov bx, 10
    mov si, bp

    ; divide by 10, write remainder value into bcd variable 
    ; and inclrement cx. quit loop if ax is 0 after devision
    ; the numbers are stored in the wrong order
_bcd:
    div bx
    dec si
    mov [ss:si], dl
    cmp ax, 0
    jg _bcd

    mov bx, string
    ; read the bcd numbers in correct order, add the ascii 0 (48)
    ; to the bcd value and store it in the datasegment string 
_string:
    mov al, [ss:si]
    add al, ascii_num_start
    mov [bx], al
    inc bx
    inc si
    cmp si, bp
    jl _string

    ; add the string end symbol to the string
    ;mov [bx], byte ascii_string_ende

    ; set return values
    mov ax, string
    mov dx, DSEG

    pop si
    pop ds
    pop cx
    pop ax
    popf

    mov sp, bp
    pop bp
    retf

segment DSEG

    string db "     $"