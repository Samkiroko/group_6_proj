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
    JMP check_minute

check_minute:
    CMP CL, prevMinute
    JNE update_minute
    JMP check_second

update_minute:
    MOV prevMinute, CL
    CALL set_cursor_minute
    MOV AL, CL
    CALL ConvertAndDisplayDigit
    JMP check_second

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

DISP PROC
    ADD AL, 30h ; Convert to ASCII
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    RET
DISP ENDP

set_cursor_hour PROC
    mov ah, 02h
    mov bh, 0
    mov dh, 12  ; Row
    mov dl, 30  ; Column for hour
    int 10h
    RET
set_cursor_hour ENDP

set_cursor_minute PROC
    mov ah, 02h
    mov bh, 0
    mov dh, 12  ; Row
    mov dl, 33  ; Column for minute
    int 10h
    RET
set_cursor_minute ENDP

set_cursor_second PROC
    mov ah, 02h
    mov bh, 0
    mov dh, 12  ; Row
    mov dl, 36  ; Column for second
    int 10h
    RET
set_cursor_second ENDP

END START
