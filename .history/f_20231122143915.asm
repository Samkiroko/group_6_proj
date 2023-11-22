ConvertAndDisplayDigit PROC
    ; Assuming AL contains the BCD value of time
    PUSH AX      ; Save AX

    ; Extract tens digit
    MOV AH, AL   ; Move AL to AH for manipulation
    AND AH, 0F0h ; Isolate tens place (upper nibble)
    SHR AH, 4    ; Shift right to get the tens digit
    CALL DISP    ; Display tens digit

    ; Extract units digit
    POP AX       ; Restore original AX
    AND AL, 0Fh  ; Isolate units place (lower nibble)
    CALL DISP    ; Display units digit

    RET
ConvertAndDisplayDigit ENDP





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


