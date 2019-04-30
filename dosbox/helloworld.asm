format mz
entry CSEG:main

;------------------------------------------
; DATA
;------------------------------------------

segment DSEG
msg db "Hello World$" 

;------------------------------------------
; CODE
;------------------------------------------
segment CSEG
main:
    mov ax, DSEG  ; put .data segment into ax
    mov ds, ax      ; setup DS to print string
    mov dx, msg     ; put 'msg' address into dx

    mov ah, 9h
    int 21h         ; output string from DS:DX

    mov ah, 10h     
    int 16h         ; read keystroke from extended keyboard

    mov ax, 4c01h   
    int 21h         ; exit program, but dont close console
