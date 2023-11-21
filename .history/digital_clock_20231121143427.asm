data segment
    currentHour db 0
    currentMinute db 0
    currentSecond db 0
ends

code segment
assume cs:code, ds:data

start:
    ; Initialize the data segment
    mov ax, data
    mov ds, ax

    ; Main loop
main_loop:
    ; Get the current system time
    mov ah, 2Ch ; DOS function: Get System Time
    int 21h     ; AH = 2Ch, CH = hour, CL = minute, DH = second, DL = hundredths

    ; Convert BCD to decimal and store in variables
    mov al, ch
    call convertBCD
    mov currentHour, al

    mov al, cl
    call convertBCD
    mov currentMinute, al

    mov al, dh
    call convertBCD
    mov currentSecond, al

    ; Display the time (you'll need to expand this part)
    ; ...

    jmp main_loop  ; Repeat the loop

    ; Exit program (DOS function call)
    mov ah, 4Ch
    int 21h

convertBCD:  ; Convert BCD to Decimal
    push ax    ; Save AX register
    mov ah, 0  ; Clear AH
    mov cl, 4  ; Prepare to shift the bits
    shr al, cl ; Shift the high nibble to the low nibble
    mov cl, al ; Move the lower nibble to CL
    and cl, 0Fh; Mask out the high nibble
    add al, cl ; Add the two nibbles
    pop ax     ; Restore AX register
    ret

; Add more routines here, such as displayDigit

ends
end start
