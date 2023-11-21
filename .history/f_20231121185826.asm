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

