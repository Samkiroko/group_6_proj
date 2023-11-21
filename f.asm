get_two_digit_input PROC
    XOR AX, AX      ; Clear AX

    ; Read first digit
    MOV AH, 00h
    INT 16h         ; Wait for keypress
    SUB AL, '0'     ; Convert from ASCII
    MOV BL, AL      ; Store the first digit in BL
    MOV BH, 0       ; Clear BH to use BX as a 16-bit register

    ; Multiply BX by 10
    MOV CX, 10
    IMUL CX         ; BX = BX * 10 (result in BX)

    ; Read second digit
    MOV AH, 00h
    INT 16h         ; Wait for keypress
    SUB AL, '0'     ; Convert from ASCII

    ; Combine the two digits
    ADD BX, AX      ; BX = BX + AX (second digit)

    ; Move result to AL
    MOV AL, BL      ; AL = lower byte of BX
    RET
get_two_digit_input ENDP
