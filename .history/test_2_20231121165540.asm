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
    MOV AH, 2CH
    INT 21H

    ; Compare with previous time and update as needed
    CMP CH, prevHour
    JNE update_hour
    JMP check_minute

update_hour:
    MOV prevHour, CH
    CALL set_cursor_hour
    MOV AL, CH
    CALL ConvertAndDisplayDigit

check_minute:
    CMP CL, prevMinute
    JNE update_minute
    JMP check_second

update_minute:
    MOV prevMinute, CL
    CALL set_cursor_minute
    MOV AL, CL
    CALL ConvertAndDisplayDigit

check_second:
    CMP DH, prevSecond
    JNE update_second
    JMP main_loop

update_second:
    MOV prevSecond, DH
    CALL set_cursor_second
    MOV AL, DH
    CALL ConvertAndDisplayDigit
    JMP main_loop

; Convert and display a single digit
ConvertAndDisplayDigit PROC
    ; Assuming AL has the BCD value
    AAM         ; Convert BCD to two separate digits
    PUSH AX     ; Save AX

    MOV AL, AH  ; High digit (tens)
    CALL DISP

    POP AX      ; Restore original value
    MOV AL, AL  ; Low digit (units)
    CALL DISP

    RET
ConvertAndDisplayDigit ENDP

; Display a single digit
DISP PROC
    ADD AL, 30h ; Convert to ASCII
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    RET
DISP ENDP

; Set cursor position for hour
set_cursor_hour PROC
    mov ah, 02h
    mov bh, 0
    mov dh, 12  ; Row
    mov dl, 30  ; Column, adjust as needed
    int 10h
    RET
set_cursor_hour ENDP

; Set cursor position for minute
set_cursor_minute PROC
    mov ah, 02h
    mov bh, 0
    mov dh, 12  ; Row
    mov dl, 33  ; Column, adjust as needed
    int 10h
    RET
set_cursor_minute ENDP

; Set cursor position for second
set_cursor_second PROC
    mov ah, 02h
    mov bh, 0
    mov dh, 12  ; Row
    mov dl, 36  ; Column, adjust as needed
    int 10h
    RET
set_cursor_second ENDP

END START
