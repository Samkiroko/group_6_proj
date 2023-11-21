.MODEL SMALL
.DATA
    prevHour db 0
    prevMinute db 0
    prevSecond db 0

.CODE
START: 
    MOV AX, @DATA
    MOV DS, AX

main_loop:
    ; Fetch current time
    MOV AH, 2CH   ; Function to get system time
    INT 21H       ; CH = hour, CL = minute, DH = second in BCD format

    ; Compare with previous time and update as needed
    CMP CH, prevHour
    JNE update_hour  ; If hour has changed, update hour display
    JMP check_minute ; Else, check minute

update_hour:
    MOV prevHour, CH
    CALL set_cursor_hour
    MOV AL, CH
    CALL ConvertAndDisplayDigit
    ; Fall through to check minute

check_minute:
    CMP CL, prevMinute
    JNE update_minute  ; If minute has changed, update minute display
    JMP check_second   ; Else, check second

update_minute:
    MOV prevMinute, CL
    CALL set_cursor_minute
    MOV AL, CL
    CALL ConvertAndDisplayDigit
    ; Fall through to check second

check_second:
    CMP DH, prevSecond
    JNE update_second  ; If second has changed, update second display
    JMP main_loop      ; Else, repeat loop

update_second:
    MOV prevSecond, DH
    CALL set_cursor_second
    MOV AL, DH
    CALL ConvertAndDisplayDigit
    JMP main_loop

; Convert BCD to decimal and display a single digit
ConvertAndDisplayDigit PROC
    AAM          ; Convert BCD to two separate digits (AH = tens, AL = units)
    PUSH AX      ; Save AX

    MOV AL, AH   ; Display tens digit
    CALL DISP

    POP AX       ; Restore original AX
    MOV AL, AL   ; Display units digit
    CALL DISP

    RET
ConvertAndDisplayDigit ENDP

; Display a single digit
DISP PROC
    ADD AL, 30h  ; Convert digit to ASCII
    MOV DL, AL   ; DL = character to display
    MOV AH, 02H  ; Function to display a character
    INT 21H      ; Display the character
    RET
DISP ENDP

; Set cursor position for hour
set_cursor_hour PROC
    mov ah, 02h
    mov bh, 0
    mov dh, 12  ; Row for hour display
    mov dl, 30  ; Column for hour
    int 10h
    RET
set_cursor_hour ENDP

; Set cursor position for minute
set_cursor_minute PROC
    mov ah, 02h
    mov bh, 0
    mov dh, 12  ; Row for minute display
    mov dl, 33  ; Column for minute
    int 10h
    RET
set_cursor_minute ENDP

; Set cursor position for second
set_cursor_second PROC
    mov ah, 02h
    mov bh, 0
    mov dh, 12  ; Row for second display
    mov dl, 36  ; Column for second
    int 10h
    RET
set_cursor_second ENDP

END START
