;------------------------------------------
; Gruppenarbeit Uebung 8
; Teilnehmer:
;    Nico Vogel
;    Viet Do
;    Lukas Sopora
;    Leopold Stenger
;------------------------------------------

format mz
entry cseg:main
stack 100h


segment cseg
main:
    call code_seg_8_1:clear_screen

    call code_seg_8_2:output ; cs = address of code_seg_8_2 and ip = address of output

    call code_seg_8_3:second_output
    
    call code_seg_8_4:third_output

    mov ax, data_seg_8_2
    mov ds, ax
    lea si, [message]
loop_fife:
    mov al, [ds:si]

    ; exit if end of string
    cmp al, '$'
    je end_fifth_loop
    inc si
    call code_seg_8_5:fourth_output
    jmp loop_fife
    
end_fifth_loop:

    mov ax, 4c01h   
    int 21h         ; exit program, but dont close console    


; Uebung 8.1
;------------------------------------------

segment code_seg_8_1
clear_screen:

    mov ax, 0700h   ; Bios param for clearing screen
    mov cx, 0000h
    mov dx, 184Fh
    mov bh, 07h

    int 10h         ; Video Bios interrupt
    retf
;------------------------------------------


; Uebung 8.2
;------------------------------------------

segment data_seg_8_2
message db '8086 Assembler-Programmier-Uebung$'
display_segment_with_first_line dd 0B800h:00A0h


segment code_seg_8_2

output:
    mov ax, data_seg_8_2
    mov ds, ax
    
    ; load buffer address in es/di 
    les di, [display_segment_with_first_line] ; di=00A0h es=B800h

    ; equivalent to les
    ; mov ax, 0B800h
    ; mov es, ax
    ; mov ax, 00A0h
    ; mov di, ax

    lea si, [message]

print_loop:
    ; get next char
    mov al, [si]

    mov al, [bx + message]

    ; exit if end of string
    cmp al, '$'
    je end_loop

    ; write to display buffer
    mov [es:di], al           ; actual char

    ; increment pointer
    inc si
    add di, 2
    jmp print_loop

end_loop:
    retf
;------------------------------------------
  

; Uebung 8.3
;------------------------------------------

segment data_seg_8_3

display_segment dd 0B800h:0000h

segment code_seg_8_3

; constants
one_line equ 160
third_line equ one_line*2

second_output:
    
    mov ax, data_seg_8_3
    mov ds, ax
    
    ; load buffer address in es/di 
    les di, [display_segment] ; di=00A0h es=B800h

    mov ax, data_seg_8_2
    mov ds, ax
    lea si, [message]

second_print_loop:
    ; get next char
    mov al, [ds:si]

    ; exit if end of string
    cmp al, '$'
    je second_end_loop

    ; write to display buffer 
    mov bx, 0
    mov byte [es:di + bx + third_line], al
    mov bx, 1
    mov byte [es:di + bx + third_line], 0ah

    ; increment pointer
    inc si
    add di, 2
    jmp second_print_loop

second_end_loop:
    retf
;------------------------------------------
    

; Uebung 8.4
;------------------------------------------

segment data_seg_8_4
    word_message db '8p0p8p6p pApspspepmpbplpeprp-pPprpopgprpapmpmpipeprp-pUpepbpupnpgp'
    display_segment_forth_line dd 0B800h:160*3

segment code_seg_8_4

;constants
one_line equ 160
fourth_line equ one_line*3

third_output:

    mov ax, data_seg_8_4
    mov ds, ax
    
    ; load buffer address in es/di 
    les di, [display_segment_forth_line] ; di=00A0h es=B800h
    
    ; this works, but is bad practice !
    ;mov si, word_message
    
    lea si, [word_message]

    cld
    mov cx,33
    rep movsw

    retf
;------------------------------------------


; Uebung 8.5
;------------------------------------------
segment data_seg_8_5
    display_segment_fifth_line dd 0B800h:160*4
    current_position db 0

segment code_seg_8_5

fourth_output:

    pushf
    ; save used register and index/pointer and restore after the program is done
    push ds
    push es
    push di
    push bx

    ; change data segment
    mov bx, data_seg_8_5
    mov ds, bx

    ; load display address
    les di, [display_segment_fifth_line]
    
    ; set bx to 0  
    xor bx,bxuuuuu

    ; get current position
    mov bl, [current_position]

    ; set di to current position
    add di, bx

    ; change current_position to next position
    add bl,2
    mov [current_position], bl

    ; set char in display
    mov byte [es:di], al

    pop bx
    pop di
    pop es
    pop ds
    popf
    retf
;------------------------------------------